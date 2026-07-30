import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

/// Dynamic background with animated holographic effects.
class DynamicBackground extends StatefulWidget {
  const DynamicBackground({super.key});

  @override
  State<DynamicBackground> createState() => _DynamicBackgroundState();
}

class _DynamicBackgroundState extends State<DynamicBackground>
    with TickerProviderStateMixin {
  late AnimationController _primaryController;
  late AnimationController _secondaryController;
  late AnimationController _particleController;

  @override
  void initState() {
    super.initState();
    _primaryController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _secondaryController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _primaryController.dispose();
    _secondaryController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Base gradient
        Container(
          decoration: const BoxDecoration(
            gradient: AppColors.ambientBackground,
          ),
        ),

        // Animated gradient orbs
        AnimatedBuilder(
          animation: _primaryController,
          builder: (context, child) {
            return CustomPaint(
              painter: _GradientOrbPainter(
                progress: _primaryController.value,
                color1: AppColors.accentCyan.withOpacity(0.15),
                color2: AppColors.accentBlue.withOpacity(0.1),
                color3: AppColors.accentViolet.withOpacity(0.08),
              ),
              size: Size.infinite,
            );
          },
        ),

        // Secondary orb layer
        AnimatedBuilder(
          animation: _secondaryController,
          builder: (context, child) {
            return CustomPaint(
              painter: _GradientOrbPainter(
                progress: _secondaryController.value,
                color1: AppColors.accentAmber.withOpacity(0.05),
                color2: AppColors.accentCyan.withOpacity(0.08),
                color3: Colors.transparent,
                offset: 0.5,
              ),
              size: Size.infinite,
            );
          },
        ),

        // Floating particles
        AnimatedBuilder(
          animation: _particleController,
          builder: (context, child) {
            return CustomPaint(
              painter: _ParticlePainter(
                progress: _particleController.value,
              ),
              size: Size.infinite,
            );
          },
        ),

        // Scanline overlay
        _ScanlineOverlay(
          controller: _primaryController,
        ),

        // Vignette effect
        Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.2,
              colors: [
                Colors.transparent,
                AppColors.backgroundPrimary.withOpacity(0.3),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _GradientOrbPainter extends CustomPainter {
  _GradientOrbPainter({
    required this.progress,
    required this.color1,
    required this.color2,
    required this.color3,
    this.offset = 0,
  });

  final double progress;
  final Color color1;
  final Color color2;
  final Color color3;
  final double offset;

  @override
  void paint(Canvas canvas, Size size) {
    final center1 = Offset(
      size.width * (0.2 + 0.3 * math.sin((progress + offset) * 2 * math.pi)),
      size.height * (0.3 + 0.2 * math.cos((progress + offset) * 2 * math.pi)),
    );

    final center2 = Offset(
      size.width * (0.7 + 0.2 * math.cos((progress + offset) * 2 * math.pi)),
      size.height * (0.6 + 0.25 * math.sin((progress + offset) * 2 * math.pi)),
    );

    final center3 = Offset(
      size.width * (0.5 + 0.25 * math.sin((progress + offset + 0.5) * 2 * math.pi)),
      size.height * (0.4 + 0.3 * math.cos((progress + offset + 0.5) * 2 * math.pi)),
    );

    // Draw orbs with radial gradients
    _drawOrb(canvas, center1, size.width * 0.5, color1);
    _drawOrb(canvas, center2, size.width * 0.4, color2);
    _drawOrb(canvas, center3, size.width * 0.35, color3);
  }

  void _drawOrb(Canvas canvas, Offset center, double radius, Color color) {
    if (color == Colors.transparent) return;

    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          color,
          color.withOpacity(0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant _GradientOrbPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _ParticlePainter extends CustomPainter {
  _ParticlePainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(42); // Fixed seed for consistent particles
    final particleCount = 30;

    for (var i = 0; i < particleCount; i++) {
      final baseX = random.nextDouble() * size.width;
      final baseY = random.nextDouble() * size.height;
      final particleSize = random.nextDouble() * 2 + 1;
      final speed = random.nextDouble() * 0.5 + 0.5;

      // Animate particle position
      final animatedProgress = (progress * speed + i / particleCount) % 1.0;
      final y = baseY - animatedProgress * size.height * 0.2;

      final opacity = (1 - animatedProgress) * 0.6;

      final paint = Paint()
        ..color = AppColors.accentCyan.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(baseX, y),
        particleSize,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _ScanlineOverlay extends StatelessWidget {
  const _ScanlineOverlay({required this.controller});

  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _ScanlinePainter(progress: controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class _ScanlinePainter extends CustomPainter {
  _ScanlinePainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    // Subtle horizontal scanlines
    final paint = Paint()
      ..color = AppColors.textPrimary.withOpacity(0.02)
      ..strokeWidth = 1;

    for (var y = 0.0; y < size.height; y += 4) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }

    // Moving scan line
    final scanY = size.height * progress;
    final scanPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          AppColors.accentCyan.withOpacity(0.1),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, scanY - 50, size.width, 100));

    canvas.drawRect(
      Rect.fromLTWH(0, scanY - 50, size.width, 100),
      scanPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ScanlinePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
