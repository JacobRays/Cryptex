(function(){
  'use strict';

  // Prevent this script from running more than once
  if (window.Core) return;

  const Core = {};
  const listeners = [];

  // Safely parse JSON from localStorage, with a fallback value
  Core.safeParse = (str, fallback) => {
    try {
      const val = JSON.parse(str);
      return (val === null || val === undefined) ? fallback : val;
    } catch {
      return fallback;
    }
  };

  // User settings helpers
  Core.settings = () => Core.safeParse(localStorage.getItem('settings'), {});
  Core.setSettings = (obj) => {
    localStorage.setItem('settings', JSON.stringify(obj));
    // Notify the current page of the change
    window.dispatchEvent(new CustomEvent('settings:changed', { detail: { next: obj } }));
  };
  Core.mergeSettings = (partial) => {
    const next = { ...Core.settings(), ...partial };
    Core.setSettings(next);
    return next;
  };

  // Currency Formatter
  Core.format = (value, currency) => {
    const curr = currency || Core.settings()['prefs.currency'] || 'MWK';
    const num = Number(value || 0);
    if (curr === 'USD') {
      return num.toLocaleString(undefined, { style: 'currency', currency: 'USD', minimumFractionDigits: 2, maximumFractionDigits: 2 });
    }
    // Default to MWK
    return 'MK ' + num.toLocaleString(undefined, { maximumFractionDigits: 0 });
  };

  // Simple i18n (Internationalization)
  const dict = {
    en: { home: 'Home', wallet: 'Wallet', merchants: 'Merchants', settings: 'Settings' },
    ny: { home: 'Pakhomo', wallet: 'Chikwama', merchants: 'Amalonda', settings: 'Zokonda' }
  };
  Core.t = (key) => {
    const lang = Core.settings()['prefs.lang'] || 'en';
    return (dict[lang] && dict[lang][key]) || dict.en[key] || key;
  };

  // Listen for settings changes across tabs
  Core.onSettings = (callback) => {
    if (typeof callback !== 'function') return () => {};
    const handler = (event) => {
      // Respond to storage events from other tabs or custom events on this tab
      if (event.type === 'storage' && event.key !== 'settings') return;
      try {
        callback({ settings: Core.settings(), source: event.type });
      } catch (e) {
        console.error('Error in onSettings callback:', e);
      }
    };
    window.addEventListener('storage', handler);
    window.addEventListener('settings:changed', handler);
    listeners.push(handler);
    // Return a function to unsubscribe the listener
    return () => {
      window.removeEventListener('storage', handler);
      window.removeEventListener('settings:changed', handler);
    };
  };

  // Simple toast notification function
  Core.toast = (message) => {
    let toastEl = document.getElementById('toast');
    if (!toastEl) {
      // If no toast element exists, create one
      toastEl = document.createElement('div');
      toastEl.id = 'toast';
      toastEl.style.cssText = `
        position: fixed;
        bottom: 24px;
        left: 50%;
        transform: translateX(-50%);
        background: #1b1b1b;
        color: var(--gold-2, #E0C16A);
        padding: .7rem 1rem;
        border-radius: 10px;
        box-shadow: var(--shadow, 0 10px 30px rgba(0,0,0,.45));
        z-index: 10000;
        display: none;
      `;
      document.body.appendChild(toastEl);
    }
    toastEl.textContent = message;
    toastEl.style.display = 'block';
    setTimeout(() => {
      toastEl.style.display = 'none';
    }, 2200);
  };

  // Expose Core to the global window object
  window.Core = Core;

  // Bridge to SettingsAPI if other scripts use it
  if (!window.SettingsAPI) {
    window.SettingsAPI = {
      get: (key, def) => (key in Core.settings() ? Core.settings()[key] : def),
      set: (key, val) => Core.mergeSettings({ [key]: val }),
      all: () => Core.settings(),
      onChange: (cb) => Core.onSettings(({ settings }) => cb({ settings })),
      format: (val, curr) => Core.format(val, curr),
      i18n: { t: Core.t, apply: () => {} }
    };
  }
})();