import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router.dart';
import '../../../../app/providers/auth_provider.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/shared/widgets/holographic_container.dart';

/// Splash screen with system boot animation.
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _scanAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutExpo),
      ),
    );

    _scanAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.9, curve: Curves.easeOutExpo),
      ),
    );

    _controller.forward();
    _initializeAndNavigate();
  }

  Future<void> _initializeAndNavigate() async {
    await ref.read(authNotifierProvider.notifier).initialize();
    
    // Wait for animation to complete minimum display time
    await Future.delayed(const Duration(milliseconds: 1800));
    
    if (mounted) {
      final authState = ref.read(authNotifierProvider);
      if (authState.status == AuthStatus.authenticated) {
        if (authState.user?.onboardingCompleted ?? false) {
          context.go(AppRoutes.home);
        } else {
          context.go(AppRoutes.onboarding);
        }
      } else {
        context.go(AppRoutes.auth);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.ambientBackground,
        ),
        child: Stack(
          children: [
            // Background particles
            const _BackgroundParticles(),

            // Scan line effect
            AnimatedBuilder(
              animation: _scanAnimation,
              builder: (context, child) {
                return CustomPaint(
                  size: MediaQuery.of(context).size,
                  painter: _ScanLinePainter(
                    progress: _scanAnimation.value,
                  ),
                );
              },
            ),

            // Main content
            Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // System logo/icon
                          HolographicContainer(
                            width: 120,
                            height: 120,
                            borderRadius: AppSpacing.radiusXl,
                            glowColor: AppColors.accentCyan,
                            glowIntensity: 0.4,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    AppColors.accentCyan.withOpacity(0.2),
                                    AppColors.accentBlue.withOpacity(0.1),
                                  ],
                                ),
                              ),
                              child: const Icon(
                                Icons.psychology_outlined,
                                size: 64,
                                color: AppColors.accentCyan,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xxl),

                          // System name
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [
                                AppColors.accentCyan,
                                AppColors.accentBlue,
                              ],
                            ).createShader(bounds),
                            child: Text(
                              'SYSTEM',
                              style: AppTypography.displayLarge.copyWith(
                                letterSpacing: 8,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),

                          // Loading indicator
                          SizedBox(
                            width: 160,
                            child: LinearProgressIndicator(
                              backgroundColor: AppColors.surfaceGlass,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.accentCyan.withOpacity(_fadeAnimation.value),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),

                          // Status text
                          AnimatedOpacity(
                            opacity: _scanAnimation.value > 0.5 ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 300),
                            child: Text(
                              'INITIALIZING...',
                              style: AppTypography.labelMedium.copyWith(
                                color: AppColors.textSecondary,
                                letterSpacing: 4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Background particle system.
class _BackgroundParticles extends StatefulWidget {
  const _BackgroundParticles();

  @override
  State<_BackgroundParticles> createState() => _BackgroundParticlesState();
}

class _BackgroundParticlesState extends State<_BackgroundParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Particle> _particles = [];
  final int _particleCount = 30;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _particles.addAll(List.generate(_particleCount, (_) => _Particle.random()));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          size: MediaQuery.of(context).size,
          painter: _ParticlesPainter(
            particles: _particles,
            animationValue: _controller.value,
          ),
        );
      },
    );
  }
}

class _Particle {
  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
  });

  factory _Particle.random() {
    final random = DateTime.now().microsecondsSinceEpoch;
    return _Particle(
      x: (random % 1000) / 1000.0,
      y: (random % 500) / 500.0,
      size: 1.0 + (random % 300) / 100.0,
      speed: 0.2 + (random % 200) / 100.0,
      opacity: 0.2 + (random % 500) / 1000.0,
    );
  }

  double x;
  double y;
  final double size;
  final double speed;
  final double opacity;
}

class _ParticlesPainter extends CustomPainter {
  _ParticlesPainter({
    required this.particles,
    required this.animationValue,
  });

  final List<_Particle> particles;
  final double animationValue;

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final paint = Paint()
        ..color = AppColors.accentCyan.withOpacity(particle.opacity)
        ..style = PaintingStyle.fill;

      final y = (particle.y + animationValue * particle.speed) % 1.0;
      canvas.drawCircle(
        Offset(particle.x * size.width, y * size.height),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlesPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

class _ScanLinePainter extends CustomPainter {
  _ScanLinePainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          AppColors.accentCyan.withOpacity(0.1),
          AppColors.accentCyan.withOpacity(0.3),
          AppColors.accentCyan.withOpacity(0.1),
          Colors.transparent,
        ],
        stops: [
          (progress - 0.2).clamp(0.0, 1.0),
          progress,
          progress + 0.01,
          (progress + 0.2).clamp(0.0, 1.0),
          (progress + 0.3).clamp(0.0, 1.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _ScanLinePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
