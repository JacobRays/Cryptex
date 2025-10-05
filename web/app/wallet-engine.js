/* Cryptex Wallet Engine
   - Single source of truth for balances and transactions
   - Validates inputs, checks PIN, prevents duplicates
   - Recomputes wallet from history (completed tx only)
   - Notifies other tabs via BroadcastChannel + localStorage ping
*/
(function () {
  'use strict';

  const DEFAULT_RATE = 1770; // fallback MWK per USD/USDT
  const channel = ('BroadcastChannel' in window) ? new BroadcastChannel('cryptex-wallet') : null;

  // Utils
  const nowISO = () => new Date().toISOString();
  const toInt = v => Math.round(Number(v || 0));
  const toNum = v => Number(v || 0);
  const id = () => 'tx_' + Date.now() + '_' + Math.random().toString(36).slice(2, 9);
  const fmtMWK = v => 'MK ' + Number(v || 0).toLocaleString();
  const clamp2 = n => Math.max(0, Math.round(n * 100) / 100);

  function getFxRate() {
    const local = Number(localStorage.getItem('fxRateMWK'));
    return isFinite(local) && local > 0 ? local : DEFAULT_RATE;
  }

  function getTransactions() {
    try {
      const list = JSON.parse(localStorage.getItem('transactions') || '[]');
      return Array.isArray(list) ? list : [];
    } catch {
      return [];
    }
  }

  function saveTransactions(list) {
    localStorage.setItem('transactions', JSON.stringify(list));
  }

  function getWallet() {
    try {
      const w = JSON.parse(localStorage.getItem('wallet') || 'null');
      if (w && typeof w.usdt === 'number' && typeof w.mwk === 'number') return w;
    } catch {}
    const rebuilt = recomputeWalletFromHistory();
    localStorage.setItem('wallet', JSON.stringify(rebuilt));
    return rebuilt;
  }

  function saveWallet(w) {
    localStorage.setItem('wallet', JSON.stringify({ usdt: +w.usdt || 0, mwk: +w.mwk || 0 }));
  }

  // Recompute wallet strictly from completed transactions
  function recomputeWalletFromHistory() {
    const tx = getTransactions();
    const rate = getFxRate();
    const w = { usdt: 0, mwk: 0 };
    tx.forEach(t => {
      if ((t.status || '') !== 'completed') return;
      const typ = (t.type || '').toLowerCase();
      if (typ === 'deposit') {
        w.mwk += toInt(t.amount || t.totalMWK);
      } else if (typ === 'withdraw') {
        w.mwk -= toInt(t.amount || t.totalMWK);
      } else if (typ === 'buy') {
        const usdt = toNum(t.amount);
        const mwk = toInt(t.totalMWK || Math.round(usdt * rate));
        w.usdt += usdt;
        w.mwk -= mwk;
      } else if (typ === 'sell') {
        const usdt = toNum(t.amount);
        const mwk = toInt(t.totalMWK || Math.round(usdt * rate));
        w.usdt -= usdt;
        w.mwk += mwk;
      }
    });
    w.usdt = Math.max(0, +w.usdt.toFixed(6));
    w.mwk = Math.max(0, Math.round(w.mwk));
    return w;
  }

  // Notify other tabs and listeners
  function notify(tx) {
    try { if (channel) channel.postMessage({ type: 'wallet-updated', at: Date.now(), tx }); } catch {}
    try { localStorage.setItem('walletPing', String(Date.now())); } catch {}
  }

  // PIN helpers
  function hasPin() {
    return !!localStorage.getItem('userPin');
  }
  function verifyPin(pin) {
    if (!hasPin()) return true; // allow if no PIN set yet
    return pin && pin === localStorage.getItem('userPin');
  }

  // Insert transaction safely (idempotent on id)
  function addTransaction(t) {
    const tx = {
      id: t.id || id(),
      date: nowISO(),
      type: t.type,
      status: t.status || 'completed',
      direction: t.direction,
      amount: typeof t.amount === 'number' ? t.amount : toNum(t.amount),
      totalMWK: t.totalMWK != null ? toInt(t.totalMWK) : undefined,
      reference: t.reference || '',
      paymentMethod: t.paymentMethod || '',
      note: t.note || ''
    };
    const list = getTransactions();
    if (!list.some(x => x.id === tx.id)) {
      list.unshift(tx);
      saveTransactions(list);
      saveWallet(recomputeWalletFromHistory());
      notify(tx);
    }
    return tx;
  }
    // Public API
  const WalletEngine = {
    getFxRate,
    getWallet,
    recompute: () => {
      const w = recomputeWalletFromHistory();
      saveWallet(w);
      notify({ type: 'recompute' });
      return w;
    },
    listTransactions: getTransactions,
    hasPin,
    verifyPin,

    deposit({ amount, method, reference, pin }) {
      amount = toInt(amount);
      if (!(amount > 0)) throw new Error('Enter a valid amount (MWK)');
      if (!method) throw new Error('Select a deposit method');
      if (!reference) throw new Error('Enter a reference');
      if (!verifyPin(pin)) throw new Error('Invalid PIN');

      const tx = addTransaction({
        type: 'deposit',
        amount,
        totalMWK: amount,
        direction: 'in',
        paymentMethod: method,
        reference,
        status: 'completed'
      });
      return { ok: true, tx };
    },

    withdraw({ amount, method, account, pin }) {
      amount = toInt(amount);
      if (!(amount > 0)) throw new Error('Enter a valid amount (MWK)');
      if (!method) throw new Error('Select a withdrawal method');
      if (!account || String(account).length < 5) throw new Error('Enter a valid account/number');
      if (!verifyPin(pin)) throw new Error('Invalid PIN');

      const w = getWallet();
      if (w.mwk < amount) throw new Error('Insufficient MWK balance');

      const tx = addTransaction({
        type: 'withdraw',
        amount,
        totalMWK: amount,
        direction: 'out',
        paymentMethod: method,
        reference: account,
        status: 'completed'
      });
      return { ok: true, tx };
    },

    buy({ usdt, pin }) {
      usdt = clamp2(toNum(usdt));
      if (!(usdt > 0)) throw new Error('Enter a valid USDT amount');
      if (!verifyPin(pin)) throw new Error('Invalid PIN');

      const rate = getFxRate();
      const mwkCost = Math.round(usdt * rate);
      const w = getWallet();
      if (w.mwk < mwkCost) throw new Error(`Insufficient MWK. Need ${fmtMWK(mwkCost)}`);

      const tx = addTransaction({
        type: 'buy',
        amount: usdt,
        totalMWK: mwkCost,
        direction: 'in',
        status: 'completed'
      });
      return { ok: true, tx, mwkCost };
    },

    sell({ usdt, pin }) {
      usdt = clamp2(toNum(usdt));
      if (!(usdt > 0)) throw new Error('Enter a valid USDT amount');
      if (!verifyPin(pin)) throw new Error('Invalid PIN');

      const w = getWallet();
      if (w.usdt < usdt) throw new Error('Insufficient USDT balance');

      const rate = getFxRate();
      const mwkGain = Math.round(usdt * rate);

      const tx = addTransaction({
        type: 'sell',
        amount: usdt,
        totalMWK: mwkGain,
        direction: 'out',
        status: 'completed'
      });
      return { ok: true, tx, mwkGain };
    }
  };

  // Expose
  window.WalletEngine = WalletEngine;
})();