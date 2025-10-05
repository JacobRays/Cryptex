'use strict';

// Admin allowlist (keep in sync with settings/admin security)
const ADMIN_EMAILS = ['admin@cryptex.mw', 'jacob@cryptex.mw'];

// Lightweight toast (falls back to alert if toast container missing)
function showToast(msg, type = 'info') {
  const el = document.getElementById('toast');
  if (!el) { alert(msg); return; }
  el.textContent = msg;
  el.style.borderColor =
    type === 'error' ? 'rgba(244,67,54,.55)' :
    type === 'success' ? 'rgba(76,175,80,.55)' :
    'rgba(212,175,55,.35)';
  el.classList.add('show');
  clearTimeout(showToast._t);
  showToast._t = setTimeout(() => el.classList.remove('show'), 2200);
}

// Basic fingerprint used by admin security
function getFingerprint() {
  try {
    const fp = {
      ua: navigator.userAgent,
      lang: navigator.language,
      platform: navigator.platform,
      tz: Intl.DateTimeFormat().resolvedOptions().timeZone
    };
    return btoa(JSON.stringify(fp));
  } catch { return ''; }
}

// Spinner state for login button
function setLoading(isLoading) {
  const btn = document.getElementById('loginBtn');
  if (!btn) return;
  btn.classList.toggle('loading', !!isLoading);
}

// Simple login function that works (beautified UX)
function login() {
  const emailEl = document.getElementById('email');
  const passEl = document.getElementById('password');
  const rememberEl = document.getElementById('rememberMe');

  const email = (emailEl?.value || '').trim().toLowerCase();
  const password = passEl?.value || '';

  if (!email || !password) {
    showToast('Please enter email and password', 'error');
    return;
  }

  setLoading(true);

  // Simple user database
  const users = {
    'admin@cryptex.mw':   { password: 'admin123', role: 'admin', name: 'Admin User' },
    'jacob@cryptex.mw':   { password: 'jacob123', role: 'admin', name: 'Jacob' },
    'merchant@cryptex.mw':{ password: 'merchant123', role: 'merchant', name: 'Merchant User' },
    'user@cryptex.mw':    { password: 'user123', role: 'user', name: 'John Doe' }
  };

  // Simulate small latency for nicer UX
  setTimeout(() => {
    const user = users[email];

    if (!user) {
      setLoading(false);
      showToast('User not found', 'error');
      return;
    }

    if (user.password !== password) {
      setLoading(false);
      showToast('Incorrect password', 'error');
      return;
    }

    // Save user info
    localStorage.setItem('user', email);
    localStorage.setItem('role', user.role);
    localStorage.setItem('userName', user.name);

    // Remember me
    if (rememberEl?.checked) localStorage.setItem('rememberEmail', email);
    else localStorage.removeItem('rememberEmail');

    // If admin, prepare admin token + fingerprint (works with your settings/admin checks)
    if (user.role === 'admin' && ADMIN_EMAILS.includes(email)) {
      const token = 'ADM-' + Date.now() + '-' + Math.random().toString(36).substr(2,9);
      localStorage.setItem('adminToken', token);
      localStorage.setItem('tokenTime', Date.now().toString());
      localStorage.setItem('adminDeviceFingerprint', getFingerprint());
    }

    showToast(`Welcome ${user.name}!`, 'success');

    // Redirect based on role
    const go = () => {
      if (user.role === 'merchant') {
        fetch('merchant_dashboard.html')
          .then(r => r.ok ? 'merchant_dashboard.html' : 'dashboard.html')
          .catch(() => 'dashboard.html')
          .then(url => window.location.href = url);
      } else {
        window.location.href = 'dashboard.html';
      }
    };

    setTimeout(go, 300);
  }, 350);
}

// Quick login for testing
function quickLogin(role) {
  const credentials = {
    'admin': { email: 'admin@cryptex.mw', password: 'admin123' },
    'merchant': { email: 'merchant@cryptex.mw', password: 'merchant123' },
    'user': { email: 'user@cryptex.mw', password: 'user123' }
  };
  const cred = credentials[role];
  if (cred) {
    const e = document.getElementById('email');
    const p = document.getElementById('password');
    if (e) e.value = cred.email;
    if (p) p.value = cred.password;
    login();
  }
}

// Register function
function register() {
  window.location.href = 'register.html';
}

// Logout function
function logout() {
  localStorage.clear();
  showToast('Logged out successfully!', 'success');
  setTimeout(() => window.location.href = 'index.html', 300);
}

// Check auth on protected pages
function checkAuth() {
  const user = localStorage.getItem('user');
  if (!user) {
    const currentPage = window.location.pathname.split('/').pop();
    if (!['', 'index.html'].includes(currentPage)) {
      showToast('Please login first!', 'error');
      setTimeout(() => window.location.href = 'index.html', 300);
    }
  }
}

// Toggle password visibility
function bindPasswordToggle() {
  const btn = document.getElementById('togglePwd');
  const input = document.getElementById('password');
  if (!btn || !input) return;
  btn.addEventListener('click', () => {
    input.type = input.type === 'password' ? 'text' : 'password';
    btn.textContent = input.type === 'password' ? '👁' : '🙈';
    input.focus();
  });
}

// Prefill remember me email and handle Enter key
function bindLoginUX() {
  const emailEl = document.getElementById('email');
  const passEl = document.getElementById('password');
  const remembered = localStorage.getItem('rememberEmail');
  if (remembered && emailEl) emailEl.value = remembered;

  const submitOnEnter = (e) => { if (e.key === 'Enter') login(); };
  emailEl?.addEventListener('keydown', submitOnEnter);
  passEl?.addEventListener('keydown', submitOnEnter);
}

// Run on DOM ready
window.addEventListener('DOMContentLoaded', () => {
  // Bind UI only on index.html (based on presence of email input)
  if (document.getElementById('email')) {
    bindPasswordToggle();
    bindLoginUX();
  }

  // Auth checks for protected pages
  const protectedPages = ['dashboard.html', 'wallet.html', 'settings.html', 'merchants.html'];
  const currentPage = window.location.pathname.split('/').pop();
  if (protectedPages.includes(currentPage)) checkAuth();
});