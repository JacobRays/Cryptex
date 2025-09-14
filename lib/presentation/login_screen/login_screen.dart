import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/biometric_auth_widget.dart';
import './widgets/cryptex_logo_widget.dart';
import './widgets/login_form_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  bool _isLoading = false;
  bool _isBiometricAvailable = true;
  String? _emailError;
  String? _passwordError;
  String? _generalError;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Mock credentials for different user roles
  final List<Map<String, dynamic>> _mockCredentials = [
    {
      "email": "admin@cryptex.mw",
      "password": "admin123",
      "role": "admin",
      "name": "System Administrator"
    },
    {
      "email": "merchant@cryptex.mw",
      "password": "merchant123",
      "role": "merchant",
      "name": "John Merchant"
    },
    {
      "email": "user@cryptex.mw",
      "password": "user123",
      "role": "user",
      "name": "Jane User"
    },
    {
      "email": "+265991234567",
      "password": "mobile123",
      "role": "user",
      "name": "Mobile User"
    }
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkBiometricAvailability();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
    ));

    _animationController.forward();
  }

  void _checkBiometricAvailability() {
    // Simulate biometric availability check
    setState(() {
      _isBiometricAvailable = true;
    });
  }

  void _validateInputs() {
    setState(() {
      _emailError = null;
      _passwordError = null;
      _generalError = null;
    });

    bool isValid = true;

    if (_emailController.text.trim().isEmpty) {
      setState(() {
        _emailError = 'Email or phone number is required';
      });
      isValid = false;
    } else if (!_isValidEmailOrPhone(_emailController.text.trim())) {
      setState(() {
        _emailError = 'Please enter a valid email or phone number';
      });
      isValid = false;
    }

    if (_passwordController.text.isEmpty) {
      setState(() {
        _passwordError = 'Password is required';
      });
      isValid = false;
    } else if (_passwordController.text.length < 6) {
      setState(() {
        _passwordError = 'Password must be at least 6 characters';
      });
      isValid = false;
    }

    if (isValid) {
      _performLogin();
    }
  }

  bool _isValidEmailOrPhone(String input) {
    // Email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    // Malawian phone number validation (+265 followed by 9 digits)
    final phoneRegex = RegExp(r'^\+265[0-9]{9}$');

    return emailRegex.hasMatch(input) || phoneRegex.hasMatch(input);
  }

  void _performLogin() async {
    setState(() {
      _isLoading = true;
      _generalError = null;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Check credentials against mock data
    final credential = _mockCredentials.firstWhere(
      (cred) =>
          cred['email'] == _emailController.text.trim() &&
          cred['password'] == _passwordController.text,
      orElse: () => {},
    );

    if (credential.isNotEmpty) {
      // Success - trigger haptic feedback
      HapticFeedback.lightImpact();

      // Navigate based on role
      _navigateBasedOnRole(credential['role'] as String);
    } else {
      setState(() {
        _isLoading = false;
        _generalError =
            'Invalid credentials. Please check your email/phone and password.';
      });
      HapticFeedback.heavyImpact();
    }
  }

  void _navigateBasedOnRole(String role) {
    String route;
    switch (role) {
      case 'admin':
        route = '/admin-dashboard';
        break;
      case 'merchant':
        route = '/merchant-dashboard';
        break;
      case 'user':
      default:
        route = '/user-dashboard';
        break;
    }

    Navigator.pushReplacementNamed(context, route);
  }

  void _handleBiometricAuth() async {
    HapticFeedback.selectionClick();

    // Simulate biometric authentication
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    // Simulate successful biometric auth for demo user
    setState(() {
      _isLoading = false;
    });

    HapticFeedback.lightImpact();
    Navigator.pushReplacementNamed(context, '/user-dashboard');
  }

  void _handleForgotPassword() {
    HapticFeedback.selectionClick();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
          ),
        ),
        title: Text(
          'Reset Password',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.lightTheme.primaryColor,
          ),
        ),
        content: Text(
          'Password reset functionality will be available soon. Please contact support for assistance.',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: TextStyle(color: AppTheme.lightTheme.primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.lightTheme.scaffoldBackgroundColor,
              AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.1),
              AppTheme.lightTheme.scaffoldBackgroundColor,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: IntrinsicHeight(
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 8.h),

                              // Logo Section
                              const CryptexLogoWidget(),

                              // Login Form Card
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(6.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: AppTheme.lightTheme.colorScheme.surface
                                      .withValues(alpha: 0.1),
                                  border: Border.all(
                                    color: AppTheme.lightTheme.primaryColor
                                        .withValues(alpha: 0.2),
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.lightTheme.primaryColor
                                          .withValues(alpha: 0.1),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    // Welcome Text
                                    Text(
                                      'Welcome Back',
                                      style: AppTheme
                                          .lightTheme.textTheme.headlineSmall
                                          ?.copyWith(
                                        color: AppTheme
                                            .lightTheme.colorScheme.onSurface,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 1.h),
                                    Text(
                                      'Sign in to continue trading',
                                      style: AppTheme
                                          .lightTheme.textTheme.bodyMedium
                                          ?.copyWith(
                                        color: AppTheme
                                            .lightTheme.colorScheme.onSurface
                                            .withValues(alpha: 0.7),
                                      ),
                                    ),
                                    SizedBox(height: 4.h),

                                    // General Error Message
                                    if (_generalError != null) ...[
                                      Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.all(3.w),
                                        margin: EdgeInsets.only(bottom: 2.h),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: AppTheme
                                              .lightTheme.colorScheme.error
                                              .withValues(alpha: 0.1),
                                          border: Border.all(
                                            color: AppTheme
                                                .lightTheme.colorScheme.error
                                                .withValues(alpha: 0.3),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            CustomIconWidget(
                                              iconName: 'error_outline',
                                              color: AppTheme
                                                  .lightTheme.colorScheme.error,
                                              size: 4.w,
                                            ),
                                            SizedBox(width: 2.w),
                                            Expanded(
                                              child: Text(
                                                _generalError!,
                                                style: AppTheme.lightTheme
                                                    .textTheme.bodySmall
                                                    ?.copyWith(
                                                  color: AppTheme.lightTheme
                                                      .colorScheme.error,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],

                                    // Login Form
                                    LoginFormWidget(
                                      emailController: _emailController,
                                      passwordController: _passwordController,
                                      isLoading: _isLoading,
                                      onLogin: _validateInputs,
                                      onForgotPassword: _handleForgotPassword,
                                      emailError: _emailError,
                                      passwordError: _passwordError,
                                    ),

                                    SizedBox(height: 3.h),

                                    // Divider with "OR"
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: 1,
                                            color: AppTheme
                                                .lightTheme.colorScheme.outline
                                                .withValues(alpha: 0.3),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 4.w),
                                          child: Text(
                                            'OR',
                                            style: AppTheme
                                                .lightTheme.textTheme.bodySmall
                                                ?.copyWith(
                                              color: AppTheme.lightTheme
                                                  .colorScheme.onSurface
                                                  .withValues(alpha: 0.6),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            height: 1,
                                            color: AppTheme
                                                .lightTheme.colorScheme.outline
                                                .withValues(alpha: 0.3),
                                          ),
                                        ),
                                      ],
                                    ),

                                    // Biometric Authentication
                                    BiometricAuthWidget(
                                      onBiometricPressed: _handleBiometricAuth,
                                      isAvailable: _isBiometricAvailable,
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 4.h),

                              // Demo Credentials Info
                              Container(
                                padding: EdgeInsets.all(4.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: AppTheme.lightTheme.colorScheme.surface
                                      .withValues(alpha: 0.05),
                                  border: Border.all(
                                    color: AppTheme.lightTheme.primaryColor
                                        .withValues(alpha: 0.1),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Demo Credentials:',
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall
                                          ?.copyWith(
                                        color: AppTheme.lightTheme.primaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 1.h),
                                    Text(
                                      'Admin: admin@cryptex.mw / admin123\nMerchant: merchant@cryptex.mw / merchant123\nUser: user@cryptex.mw / user123',
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall
                                          ?.copyWith(
                                        color: AppTheme
                                            .lightTheme.colorScheme.onSurface
                                            .withValues(alpha: 0.7),
                                        fontSize: 9.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 4.h),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
