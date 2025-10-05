cat > admin_security.js << 'EOF'
// Advanced Admin Detection System for Cryptex Malawi
// This file handles all security checks and intrusion detection

const AdminSecurity = {
    // Security configuration
    config: {
        maxLoginAttempts: 3,
        lockoutDuration: 30 * 60 * 1000, // 30 minutes
        sessionTimeout: 30 * 60 * 1000, // 30 minutes
        adminFingerprint: null,
        suspiciousPatterns: []
    },

    // List of authorized admin emails (encrypted in production)
    authorizedAdmins: [
        'admin@cryptex.mw',
        'jacob@cryptex.mw'
    ],

    // Initialize security system
    init() {
        this.createDeviceFingerprint();
        this.detectDevTools();
        this.preventInspection();
        this.monitorSuspiciousActivity();
        this.validateSession();
        this.setupHoneypots();
    },

    // DETECTION METHOD 1: Device Fingerprinting
    createDeviceFingerprint() {
        const fingerprint = {
            userAgent: navigator.userAgent,
            language: navigator.language,
            platform: navigator.platform,
            screenResolution: `${screen.width}x${screen.height}`,
            timezone: Intl.DateTimeFormat().resolvedOptions().timeZone,
            colorDepth: screen.colorDepth,
            pixelRatio: window.devicePixelRatio,
            touchSupport: 'ontouchstart' in window,
            sessionStorage: typeof(Storage) !== "undefined",
            localStorage: typeof(Storage) !== "undefined",
            cookieEnabled: navigator.cookieEnabled,
            doNotTrack: navigator.doNotTrack,
            plugins: this.getPlugins(),
            webGL: this.getWebGLFingerprint(),
            timestamp: Date.now()
        };

        // Create unique hash from fingerprint
        const hash = this.hashFingerprint(fingerprint);
        
        // Store trusted admin device fingerprints
        const trustedDevices = [
            'ADMIN_DEVICE_HASH_1', // Replace with your actual device hash
            'ADMIN_DEVICE_HASH_2'
        ];

        // Check if current device is trusted
        const isTrustedDevice = this.checkTrustedDevice(hash);
        
        if (!isTrustedDevice) {
            this.logSuspiciousActivity('Unknown device attempting admin access', fingerprint);
        }

        return hash;
    },

    // DETECTION METHOD 2: Developer Tools Detection
    detectDevTools() {
        let devtools = {open: false, orientation: null};
        const threshold = 160;
        
        setInterval(() => {
            if (window.outerHeight - window.innerHeight > threshold || 
                window.outerWidth - window.innerWidth > threshold) {
                if (!devtools.open) {
                    devtools.open = true;
                    this.handleDevToolsOpen();
                }
            } else {
                devtools.open = false;
            }
        }, 500);

        // Detect console.log timing
        let startTime = new Date();
        debugger;
        let endTime = new Date();
        
        if (endTime - startTime > 100) {
            this.handleDebuggerDetected();
        }
    },

    // DETECTION METHOD 3: Prevent Right-Click and Inspection
    preventInspection() {
        // Disable right-click
        document.addEventListener('contextmenu', (e) => {
            if (window.location.pathname.includes('admin')) {
                e.preventDefault();
                this.logSuspiciousActivity('Right-click attempted on admin page');
                return false;
            }
        });

        // Disable F12, Ctrl+Shift+I, Ctrl+Shift+J, Ctrl+U
        document.addEventListener('keydown', (e) => {
            if (window.location.pathname.includes('admin')) {
                if (e.keyCode === 123 || // F12
                    (e.ctrlKey && e.shiftKey && e.keyCode === 73) || // Ctrl+Shift+I
                    (e.ctrlKey && e.shiftKey && e.keyCode === 74) || // Ctrl+Shift+J
                    (e.ctrlKey && e.keyCode === 85)) { // Ctrl+U
                    e.preventDefault();
                    this.logSuspiciousActivity('Inspection keys detected');
                    this.showWarning();
                    return false;
                }
            }
        });

        // Disable text selection on admin pages
        if (window.location.pathname.includes('admin')) {
            document.body.style.userSelect = 'none';
            document.body.style.webkitUserSelect = 'none';
            document.body.style.msUserSelect = 'none';
            document.body.style.mozUserSelect = 'none';
        }
    },

    // DETECTION METHOD 4: Monitor Suspicious Patterns
    monitorSuspiciousActivity() {
        let failedAttempts = parseInt(localStorage.getItem('failedAdminAttempts') || '0');
        let lastAttemptTime = parseInt(localStorage.getItem('lastFailedAttempt') || '0');
        
        // Check for brute force attempts
        if (failedAttempts >= this.config.maxLoginAttempts) {
            const timeSinceLastAttempt = Date.now() - lastAttemptTime;
            
            if (timeSinceLastAttempt < this.config.lockoutDuration) {
                this.lockAccount();
                return false;
            } else {
                // Reset after lockout period
                localStorage.setItem('failedAdminAttempts', '0');
            }
        }

        // Monitor rapid page refreshes (bot detection)
        let refreshCount = parseInt(sessionStorage.getItem('refreshCount') || '0');
        let firstRefreshTime = parseInt(sessionStorage.getItem('firstRefreshTime') || Date.now());
        
        refreshCount++;
        sessionStorage.setItem('refreshCount', refreshCount.toString());
        
        if (refreshCount > 10) {
            const timeElapsed = Date.now() - firstRefreshTime;
            if (timeElapsed < 60000) { // 10 refreshes in 1 minute
                this.logSuspiciousActivity('Rapid refresh detected - possible bot');
                this.blockAccess();
            }
        }

        // Check for modified localStorage (tampering)
        this.detectLocalStorageTampering();
    },

    // DETECTION METHOD 5: Session Validation
    validateSession() {
        const userRole = localStorage.getItem('role');
        const userEmail = localStorage.getItem('user');
        const adminToken = localStorage.getItem('adminToken');
        const tokenTime = parseInt(localStorage.getItem('tokenTime') || '0');

        // Check 1: Role must be admin
        if (userRole !== 'admin') {
            this.logUnauthorizedAccess('Invalid role', userEmail);
            return false;
        }

        // Check 2: Email must be in authorized list
        if (!this.authorizedAdmins.includes(userEmail)) {
            this.logUnauthorizedAccess('Unauthorized email', userEmail);
            return false;
        }

        // Check 3: Valid token must exist
        if (!adminToken || !this.validateToken(adminToken)) {
            this.logUnauthorizedAccess('Invalid or missing token', userEmail);
            return false;
        }

        // Check 4: Token must not be expired
        if (Date.now() - tokenTime > this.config.sessionTimeout) {
            this.logUnauthorizedAccess('Expired session', userEmail);
            localStorage.clear();
            window.location.href = 'index.html';
            return false;
        }

        // Check 5: Verify against backend (in production)
        this.verifyWithBackend(userEmail, adminToken);

        return true;
    },

    // DETECTION METHOD 6: Honeypot Traps
    setupHoneypots() {
        // Create hidden form fields that bots might fill
        const honeypot = document.createElement('input');
        honeypot.type = 'text';
        honeypot.name = 'username_admin';
        honeypot.id = 'username_admin';
        honeypot.style.position = 'absolute';
        honeypot.style.left = '-9999px';
        honeypot.setAttribute('tabindex', '-1');
        honeypot.setAttribute('autocomplete', 'off');
        
        // If honeypot is filled, it's a bot
        honeypot.addEventListener('change', () => {
            if (honeypot.value !== '') {
                this.logSuspiciousActivity('Honeypot triggered - bot detected');
                this.blockAccess();
            }
        });

        // Add fake admin URLs that redirect hackers
        this.createFakeEndpoints();
    },

    // DETECTION METHOD 7: Browser Behavior Analysis
    analyzeBrowserBehavior() {
        // Check for headless browser (often used by hackers)
        const isHeadless = navigator.webdriver || 
                          navigator.plugins.length === 0 ||
                          navigator.languages === '';
        
        if (isHeadless) {
            this.logSuspiciousActivity('Headless browser detected');
            this.blockAccess();
        }

        // Check for automated browser
        if (navigator.webdriver === true) {
            this.logSuspiciousActivity('Automated browser detected');
            this.blockAccess();
        }

        // Check mouse movement (bots don't move mouse naturally)
        let mouseMovements = 0;
        document.addEventListener('mousemove', () => {
            mouseMovements++;
        });

        setTimeout(() => {
            if (mouseMovements < 10) {
                this.logSuspiciousActivity('No mouse movement - possible bot');
            }
        }, 5000);
    },

    // DETECTION METHOD 8: Network Analysis
    analyzeNetworkPatterns() {
        // Check for VPN/Proxy (in production, use IP analysis API)
        fetch('https://api.ipify.org?format=json')
            .then(response => response.json())
            .then(data => {
                const ip = data.ip;
                // Check against known VPN/proxy IPs
                this.checkSuspiciousIP(ip);
            });

        // Monitor API call patterns
        this.monitorAPIUsage();
    },

    // Helper Functions
    hashFingerprint(fingerprint) {
        const str = JSON.stringify(fingerprint);
        let hash = 0;
        for (let i = 0; i < str.length; i++) {
            const char = str.charCodeAt(i);
            hash = ((hash << 5) - hash) + char;
            hash = hash & hash;
        }
        return hash.toString(36);
    },

    getPlugins() {
        const plugins = [];
        for (let i = 0; i < navigator.plugins.length; i++) {
            plugins.push(navigator.plugins[i].name);
        }
        return plugins.join(',');
    },

    getWebGLFingerprint() {
        const canvas = document.createElement('canvas');
        const gl = canvas.getContext('webgl') || canvas.getContext('experimental-webgl');
        if (!gl) return null;
        
        const debugInfo = gl.getExtension('WEBGL_debug_renderer_info');
        if (!debugInfo) return null;
        
        return {
            vendor: gl.getParameter(debugInfo.UNMASKED_VENDOR_WEBGL),
            renderer: gl.getParameter(debugInfo.UNMASKED_RENDERER_WEBGL)
        };
    },

    checkTrustedDevice(hash) {
        const trustedDevices = JSON.parse(localStorage.getItem('trustedAdminDevices') || '[]');
        return trustedDevices.includes(hash);
    },

    validateToken(token) {
        // Check token format
        const tokenPattern = /^ADM-\d{13}-[a-z0-9]{9}$/;
        return tokenPattern.test(token);
    },

    detectLocalStorageTampering() {
        // Create a checksum of critical values
        const criticalData = {
            role: localStorage.getItem('role'),
            user: localStorage.getItem('user'),
            adminToken: localStorage.getItem('adminToken')
        };
        
        const checksum = this.hashFingerprint(criticalData);
        const storedChecksum = sessionStorage.getItem('dataChecksum');
        
        if (storedChecksum && storedChecksum !== checksum) {
            this.logSuspiciousActivity('LocalStorage tampering detected');
            this.blockAccess();
        }
        
        sessionStorage.setItem('dataChecksum', checksum);
    },

    createFakeEndpoints() {
        // These are fake paths that hackers might try
        const fakePaths = [
            '/admin',
            '/wp-admin',
            '/administrator',
            '/admin.php',
            '/admin/login',
            '/phpmyadmin'
        ];

        fakePaths.forEach(path => {
            if (window.location.pathname === path) {
                this.logSuspiciousActivity(`Fake endpoint accessed: ${path}`);
                this.honeypotTriggered();
            }
        });
    },

    monitorAPIUsage() {
        let apiCallCount = parseInt(sessionStorage.getItem('apiCallCount') || '0');
        let firstCallTime = parseInt(sessionStorage.getItem('firstAPICall') || Date.now());
        
        apiCallCount++;
        sessionStorage.setItem('apiCallCount', apiCallCount.toString());
        
        // Check for unusual API activity
        if (apiCallCount > 50) {
            const timeElapsed = Date.now() - firstCallTime;
            if (timeElapsed < 60000) { // 50 calls in 1 minute
                this.logSuspiciousActivity('Excessive API calls detected');
                this.blockAccess();
            }
        }
    },

    checkSuspiciousIP(ip) {
        // In production, check against:
        // - Known VPN/proxy IPs
        // - Blacklisted IPs
        // - Geographic restrictions
        console.log('Checking IP:', ip);
    },

    // Response Functions
    handleDevToolsOpen() {
        if (window.location.pathname.includes('admin')) {
            this.logSuspiciousActivity('Developer tools opened on admin page');
            this.showWarning();
            
            // Optional: Redirect away from admin
            setTimeout(() => {
                window.location.href = 'index.html';
            }, 3000);
        }
    },

    handleDebuggerDetected() {
        this.logSuspiciousActivity('Debugger detected');
        this.blockAccess();
    },

    showWarning() {
        const warning = document.createElement('div');
        warning.style.cssText = `
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(244, 67, 54, 0.98);
            color: white;
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 999999;
            font-size: 24px;
            font-family: Arial, sans-serif;
            text-align: center;
            padding: 20px;
        `;
        warning.innerHTML = `
            <div>
                <h1>⚠️ SECURITY WARNING</h1>
                <p>Unauthorized access attempt detected!</p>
                <p>Your IP address and device information have been logged.</p>
                <p>This incident will be reported.</p>
                <br>
                <p style="font-size: 16px;">You will be redirected in 5 seconds...</p>
            </div>
        `;
        document.body.appendChild(warning);
        
        setTimeout(() => {
            window.location.href = 'index.html';
        }, 5000);
    },

    lockAccount() {
        localStorage.setItem('accountLocked', 'true');
        localStorage.setItem('lockTime', Date.now().toString());
        
        alert('Account locked due to multiple failed attempts. Try again in 30 minutes.');
        window.location.href = 'index.html';
    },

    blockAccess() {
        // Clear all data
        localStorage.clear();
        sessionStorage.clear();
        
        // Show blocked message
        document.body.innerHTML = `
            <div style="background: #121212; color: #F44336; display: flex; justify-content: center; align-items: center; height: 100vh; font-family: Arial;">
                <div style="text-align: center;">
                    <h1>🚫 ACCESS BLOCKED</h1>
                    <p>Suspicious activity detected.</p>
                    <p>Your access has been permanently blocked.</p>
                    <p>IP: ${this.getClientIP()}</p>
                    <p>Time: ${new Date().toISOString()}</p>
                </div>
            </div>
        `;
        
        // Log to server
        this.reportToServer('ACCESS_BLOCKED');
    },

    honeypotTriggered() {
        this.logSuspiciousActivity('Honeypot triggered');
        document.body.innerHTML = `
            <div style="background: #000; color: #0F0; font-family: monospace; padding: 20px;">
                <pre>
 ██████╗ ██████╗  ██████╗ ████████╗███████╗ ██████╗████████╗███████╗██████╗ 
██╔══██╗██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██╔════╝╚══██╔══╝██╔════╝██╔══██╗
██████╔╝██████╔╝██║   ██║   ██║   █████╗  ██║        ██║   █████╗  ██║  ██║
██╔═══╝ ██╔══██╗██║   ██║   ██║   ██╔══╝  ██║        ██║   ██╔══╝  ██║  ██║
██║     ██║  ██║╚██████╔╝   ██║   ███████╗╚██████╗   ██║   ███████╗██████╔╝
╚═╝     ╚═╝  ╚═╝ ╚═════╝    ╚═╝   ╚══════╝ ╚═════╝   ╚═╝   ╚══════╝╚═════╝ 
                                                                              
                    Nice try! Your attempt has been logged.
                    IP: ${this.getClientIP()}
                    Time: ${new Date().toISOString()}
                    
                    "The only way to win is not to play."
                </pre>
            </div>
        `;
    },

    logSuspiciousActivity(activity, details = {}) {
        const log = {
            timestamp: new Date().toISOString(),
            activity: activity,
            details: details,
            userAgent: navigator.userAgent,
            ip: this.getClientIP(),
            fingerprint: this.createDeviceFingerprint()
        };
        
        // Store locally
        let logs = JSON.parse(localStorage.getItem('suspiciousLogs') || '[]');
        logs.push(log);
        localStorage.setItem('suspiciousLogs', JSON.stringify(logs));
        
        // Send to server (in production)
        this.reportToServer('SUSPICIOUS_ACTIVITY', log);
        
        console.warn('🔐 Security Alert:', activity);
    },

    logUnauthorizedAccess(reason, email) {
        const log = {
            timestamp: new Date().toISOString(),
            reason: reason,
            attemptedEmail: email,
            ip: this.getClientIP(),
            userAgent: navigator.userAgent
        };
        
        // Increment failed attempts
        let failedAttempts = parseInt(localStorage.getItem('failedAdminAttempts') || '0');
        failedAttempts++;
        localStorage.setItem('failedAdminAttempts', failedAttempts.toString());
        localStorage.setItem('lastFailedAttempt', Date.now().toString());
        
        // Report to server
        this.reportToServer('UNAUTHORIZED_ACCESS', log);
        
        console.error('⛔ Unauthorized Access:', reason);
    },

    getClientIP() {
        // In production, get real IP from server
        return 'Client IP';
    },

    reportToServer(type, data) {
        // In production, send to your backend
        console.log(`Reporting to server: ${type}`, data);
        
        // Example:
        // fetch('/api/security/report', {
        //     method: 'POST',
        //     headers: {'Content-Type': 'application/json'},
        //     body: JSON.stringify({type, data})
        // });
    },

    verifyWithBackend(email, token) {
        // In production, verify with server
        // fetch('/api/admin/verify', {
        //     method: 'POST',
        //     headers: {'Content-Type': 'application/json'},
        //     body: JSON.stringify({email, token})
        // }).then(response => {
        //     if (!response.ok) {
        //         this.blockAccess();
        //     }
        // });
    }
};

// Initialize security when script loads
if (typeof window !== 'undefined') {
    window.AdminSecurity = AdminSecurity;
    
    // Auto-initialize on admin pages
    if (window.location.pathname.includes('admin')) {
        document.addEventListener('DOMContentLoaded', () => {
            AdminSecurity.init();
        });
    }
}
EOF