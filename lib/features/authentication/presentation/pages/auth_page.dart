import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router.dart';
import '../../../../app/providers/auth_provider.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/shared/widgets/holographic_container.dart';

/// Authentication page with sign-in and sign-up options.
class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _displayNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isSignUp = false;
  bool _obscurePassword = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _displayNameController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final authNotifier = ref.read(authNotifierProvider.notifier);

    if (_isSignUp) {
      final success = await authNotifier.signUpWithEmail(
        _emailController.text.trim(),
        _passwordController.text,
        _displayNameController.text.trim(),
      );
      if (success && mounted) {
        context.go(AppRoutes.onboarding);
      }
    } else {
      final success = await authNotifier.signInWithEmail(
        _emailController.text.trim(),
        _passwordController.text,
      );
      if (success && mounted) {
        final user = ref.read(currentUserProvider);
        if (user?.onboardingCompleted ?? false) {
          context.go(AppRoutes.home);
        } else {
          context.go(AppRoutes.onboarding);
        }
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    final authNotifier = ref.read(authNotifierProvider.notifier);
    final success = await authNotifier.signInWithGoogle();
    if (success && mounted) {
      final user = ref.read(currentUserProvider);
      if (user?.onboardingCompleted ?? false) {
        context.go(AppRoutes.home);
      } else {
        context.go(AppRoutes.onboarding);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.ambientBackground,
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: HolographicContainer(
                      width: double.infinity,
                      borderRadius: AppSpacing.radiusXl,
                      glowColor: AppColors.accentCyan,
                      glowIntensity: 0.25,
                      enableScanline: true,
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.xxl),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Logo
                              Center(
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        AppSpacing.radiusLg),
                                    gradient: AppColors.energyActive,
                                  ),
                                  child: const Icon(
                                    Icons.psychology_outlined,
                                    size: 48,
                                    color: AppColors.backgroundPrimary,
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xl),

                              // Title
                              Center(
                                child: ShaderMask(
                                  shaderCallback: (bounds) =>
                                      const LinearGradient(
                                    colors: [
                                      AppColors.accentCyan,
                                      AppColors.accentBlue
                                    ],
                                  ).createShader(bounds),
                                  child: Text(
                                    _isSignUp
                                        ? 'CREATE ACCOUNT'
                                        : 'SYSTEM ACCESS',
                                    style: AppTypography.headingMedium.copyWith(
                                      letterSpacing: 2,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Center(
                                child: Text(
                                  _isSignUp
                                      ? 'Join the system'
                                      : 'Authenticate to continue',
                                  style: AppTypography.bodySmall,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xxl),

                              // Display name (sign up only)
                              if (_isSignUp) ...[
                                _HolographicTextField(
                                  controller: _displayNameController,
                                  label: 'Designation',
                                  hint: 'Enter your name',
                                  icon: Icons.badge_outlined,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Designation required';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: AppSpacing.lg),
                              ],

                              // Email field
                              _HolographicTextField(
                                controller: _emailController,
                                label: 'Identity',
                                hint: 'Enter your email',
                                icon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Identity required';
                                  }
                                  if (!value.contains('@')) {
                                    return 'Invalid identity format';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: AppSpacing.lg),

                              // Password field
                              _HolographicTextField(
                                controller: _passwordController,
                                label: 'Access Key',
                                hint: 'Enter your password',
                                icon: Icons.lock_outline,
                                obscureText: _obscurePassword,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: AppColors.textSecondary,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Access key required';
                                  }
                                  if (_isSignUp && value.length < 8) {
                                    return 'Minimum 8 characters';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: AppSpacing.xxl),

                              // Error message
                              if (authState.error != null)
                                Container(
                                  padding: const EdgeInsets.all(AppSpacing.md),
                                  decoration: BoxDecoration(
                                    color:
                                        AppColors.accentError.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(
                                        AppSpacing.radiusSm),
                                    border: Border.all(
                                      color: AppColors.accentError
                                          .withOpacity(0.3),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.error_outline,
                                        color: AppColors.accentError,
                                        size: 20,
                                      ),
                                      const SizedBox(width: AppSpacing.sm),
                                      Expanded(
                                        child: Text(
                                          authState.error!,
                                          style:
                                              AppTypography.bodySmall.copyWith(
                                            color: AppColors.accentError,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              if (authState.error != null)
                                const SizedBox(height: AppSpacing.lg),

                              // Submit button
                              _HolographicButton(
                                onPressed:
                                    authState.isLoading ? null : _handleSubmit,
                                isLoading: authState.isLoading,
                                label:
                                    _isSignUp ? 'INITIALIZE' : 'AUTHENTICATE',
                              ),
                              const SizedBox(height: AppSpacing.lg),

                              // Divider
                              Row(
                                children: [
                                  Expanded(
                                      child: Divider(
                                          color: AppColors.borderSubtle)),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: AppSpacing.md),
                                    child: Text(
                                      'OR',
                                      style: AppTypography.labelSmall,
                                    ),
                                  ),
                                  Expanded(
                                      child: Divider(
                                          color: AppColors.borderSubtle)),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.lg),

                              // Google sign in
                              _GoogleSignInButton(
                                onPressed: authState.isLoading
                                    ? null
                                    : _handleGoogleSignIn,
                              ),
                              const SizedBox(height: AppSpacing.xxl),

                              // Toggle sign in/up
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _isSignUp
                                        ? 'Already initialized?'
                                        : 'New operative?',
                                    style: AppTypography.bodySmall,
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _isSignUp = !_isSignUp;
                                      });
                                    },
                                    child: Text(
                                      _isSignUp
                                          ? 'Access system'
                                          : 'Create account',
                                      style: AppTypography.labelLarge.copyWith(
                                        color: AppColors.accentCyan,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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

class _HolographicTextField extends StatelessWidget {
  const _HolographicTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceGlass,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(
              color: AppColors.borderAccent.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            validator: validator,
            style: AppTypography.bodyMedium,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTypography.bodyMedium.copyWith(
                color: AppColors.textMuted,
              ),
              prefixIcon: Icon(icon, color: AppColors.accentCyan, size: 20),
              suffixIcon: suffixIcon,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HolographicButton extends StatelessWidget {
  const _HolographicButton({
    required this.onPressed,
    required this.label,
    this.isLoading = false,
  });

  final VoidCallback? onPressed;
  final String label;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSpacing.buttonHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        gradient: onPressed != null ? AppColors.energyActive : null,
        color: onPressed == null ? AppColors.textMuted.withOpacity(0.3) : null,
        boxShadow: onPressed != null
            ? [
                BoxShadow(
                  color: AppColors.accentCyan.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.backgroundPrimary,
                      ),
                    ),
                  )
                : Text(
                    label,
                    style: AppTypography.buttonLarge.copyWith(
                      color: AppColors.backgroundPrimary,
                      letterSpacing: 2,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _GoogleSignInButton extends StatelessWidget {
  const _GoogleSignInButton({required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSpacing.buttonHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        color: AppColors.surfaceGlass,
        border: Border.all(
          color: AppColors.borderAccent.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.white,
                ),
                child: const Center(
                  child: Text(
                    'G',
                    style: TextStyle(
                      color: Color(0xFF4285F4),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                'Continue with Google',
                style: AppTypography.buttonMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
