import 'dart:ui';
import 'package:flutter/material.dart';
import '../../constants/constants.dart';
import '../../services/accessibility_service.dart';

/// A holographic container widget with glass morphism effects.
/// Creates a floating window effect with glow, blur, and animated borders.
class HolographicContainer extends StatefulWidget {
  const HolographicContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.borderRadius = AppSpacing.radiusMd,
    this.glowColor = AppColors.accentCyan,
    this.glowIntensity = 0.3,
    this.blurAmount = AppBlur.strong,
    this.borderWidth = 1.0,
    this.animateGlow = true,
    this.animateBorder = true,
    this.enableScanline = false,
  });

  final Widget child;
  final double? width;
  final double? height;
  final double borderRadius;
  final Color glowColor;
  final double glowIntensity;
  final double blurAmount;
  final double borderWidth;
  final bool animateGlow;
  final bool animateBorder;
  final bool enableScanline;

  @override
  State<HolographicContainer> createState() => _HolographicContainerState();
}

class _HolographicContainerState extends State<HolographicContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    // Respect reduced motion preference
    final prefersReducedMotion = AccessibilityService().prefersReducedMotion;

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _glowAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Only animate if enabled and reduced motion is not preferred
    if (widget.animateGlow && !prefersReducedMotion) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Respect reduced motion preference
    final prefersReducedMotion = AccessibilityService().prefersReducedMotion;
    final shouldAnimate = !prefersReducedMotion;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final glowIntensity = widget.animateGlow && shouldAnimate
            ? widget.glowIntensity * _glowAnimation.value
            : widget.glowIntensity;

        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: [
              BoxShadow(
                color: widget.glowColor.withOpacity(glowIntensity),
                blurRadius: 24,
                spreadRadius: 0,
              ),
              BoxShadow(
                color: widget.glowColor.withOpacity(glowIntensity * 0.5),
                blurRadius: 48,
                spreadRadius: -8,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            child: Stack(
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: widget.blurAmount * 0.5,
                    sigmaY: widget.blurAmount * 0.5,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.surfaceGlass,
                          AppColors.surfaceGlassStrong,
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    gradient: AppColors.glassOverlay,
                  ),
                ),
                if (widget.animateBorder && shouldAnimate)
                  _AnimatedBorder(
                    borderRadius: widget.borderRadius,
                    glowColor: widget.glowColor,
                    glowIntensity: glowIntensity,
                    borderWidth: widget.borderWidth,
                    progress: _glowAnimation.value,
                  )
                else
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      border: Border.all(
                        color: widget.glowColor.withOpacity(0.45),
                        width: widget.borderWidth,
                      ),
                    ),
                  ),
                if (widget.enableScanline)
                  CustomPaint(
                    size: Size(widget.width ?? 0, widget.height ?? 0),
                    painter: _ScanlinePainter(),
                  ),
                widget.child,
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AnimatedBorder extends StatelessWidget {
  const _AnimatedBorder({
    required this.borderRadius,
    required this.glowColor,
    required this.glowIntensity,
    required this.borderWidth,
    required this.progress,
  });

  final double borderRadius;
  final Color glowColor;
  final double glowIntensity;
  final double borderWidth;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: _BorderPainter(
        borderRadius: borderRadius,
        glowColor: glowColor,
        glowIntensity: glowIntensity,
        borderWidth: borderWidth,
        progress: progress,
      ),
    );
  }
}

class _BorderPainter extends CustomPainter {
  _BorderPainter({
    required this.borderRadius,
    required this.glowColor,
    required this.glowIntensity,
    required this.borderWidth,
    required this.progress,
  });

  final double borderRadius;
  final Color glowColor;
  final double glowIntensity;
  final double borderWidth;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
      borderWidth / 2,
      borderWidth / 2,
      size.width - borderWidth,
      size.height - borderWidth,
    );
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));

    final glowPaint = Paint()
      ..color = glowColor.withOpacity(glowIntensity * 0.5 * progress)
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth + 2
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 4);

    canvas.drawRRect(rrect, glowPaint);

    final borderPaint = Paint()
      ..color = glowColor.withOpacity(0.45 + glowIntensity * 0.2 * progress)
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    canvas.drawRRect(rrect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _BorderPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _ScanlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.03)
      ..style = PaintingStyle.fill;

    const lineHeight = 2.0;
    const gap = 4.0;

    for (double y = 0; y < size.height; y += lineHeight + gap) {
      canvas.drawRect(
        Rect.fromLTWH(0, y, size.width, lineHeight),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
