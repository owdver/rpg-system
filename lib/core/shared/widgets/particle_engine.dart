import 'dart:math';
import 'package:flutter/material.dart';

/// A performant particle engine for holographic effects.
/// Supports various particle behaviors and customizable parameters.
class ParticleEngine extends StatefulWidget {
  const ParticleEngine({
    super.key,
    required this.child,
    this.particleCount = 30,
    this.particleColor = const Color(0xFF54E6FF),
    this.minSize = 1.0,
    this.maxSize = 4.0,
    this.minSpeed = 0.2,
    this.maxSpeed = 1.0,
    this.fadeOut = true,
    this.emitContinuously = true,
    this.emissionRate = 5,
  });

  final Widget child;
  final int particleCount;
  final Color particleColor;
  final double minSize;
  final double maxSize;
  final double minSpeed;
  final double maxSpeed;
  final bool fadeOut;
  final bool emitContinuously;
  final int emissionRate;

  @override
  State<ParticleEngine> createState() => _ParticleEngineState();
}

class _ParticleEngineState extends State<ParticleEngine>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();

    // Initialize particles
    for (int i = 0; i < widget.particleCount; i++) {
      _particles.add(_createParticle());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _Particle _createParticle() {
    return _Particle(
      x: _random.nextDouble(),
      y: _random.nextDouble(),
      size: widget.minSize +
          _random.nextDouble() * (widget.maxSize - widget.minSize),
      speed: widget.minSpeed +
          _random.nextDouble() * (widget.maxSpeed - widget.minSpeed),
      opacity: 0.3 + _random.nextDouble() * 0.5,
      angle: _random.nextDouble() * 2 * pi,
    );
  }

  void _updateParticles() {
    for (int i = 0; i < _particles.length; i++) {
      final particle = _particles[i];

      // Update position based on angle
      particle.x += cos(particle.angle) * particle.speed * 0.01;
      particle.y += sin(particle.angle) * particle.speed * 0.01 - 0.005;

      // Fade out effect
      if (widget.fadeOut) {
        particle.opacity -= 0.005;
        if (particle.opacity <= 0) {
          _particles[i] = _createParticle();
          _particles[i].opacity = 0.3 + _random.nextDouble() * 0.5;
        }
      }

      // Wrap around screen
      if (particle.x < 0) particle.x = 1.0;
      if (particle.x > 1) particle.x = 0.0;
      if (particle.y < 0) particle.y = 1.0;
      if (particle.y > 1) particle.y = 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned.fill(
          child: IgnorePointer(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                _updateParticles();
                return CustomPaint(
                  painter: _ParticlePainter(
                    particles: _particles,
                    color: widget.particleColor,
                  ),
                );
              },
            ),
          ),
        ),
      ],
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
    required this.angle,
  });

  double x;
  double y;
  double size;
  double speed;
  double opacity;
  double angle;
}

class _ParticlePainter extends CustomPainter {
  _ParticlePainter({
    required this.particles,
    required this.color,
  });

  final List<_Particle> particles;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final paint = Paint()
        ..color = color.withOpacity(particle.opacity.clamp(0.0, 1.0))
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(particle.x * size.width, particle.y * size.height),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}

/// Particle burst effect for achievements and celebrations.
class ParticleBurst extends StatefulWidget {
  const ParticleBurst({
    super.key,
    required this.child,
    required this.trigger,
    this.particleCount = 50,
    this.particleColor = const Color(0xFFFFB84D),
    this.onComplete,
  });

  final Widget child;
  final bool trigger;
  final int particleCount;
  final Color particleColor;
  final VoidCallback? onComplete;

  @override
  State<ParticleBurst> createState() => _ParticleBurstState();
}

class _ParticleBurstState extends State<ParticleBurst>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_BurstParticle> _particles = [];
  final Random _random = Random();
  bool _hasTriggered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete?.call();
        _hasTriggered = false;
        _particles.clear();
      }
    });
  }

  @override
  void didUpdateWidget(ParticleBurst oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger && !_hasTriggered) {
      _triggerBurst();
    }
  }

  void _triggerBurst() {
    _hasTriggered = true;
    _particles.clear();

    final center = Offset(
      MediaQuery.of(context).size.width / 2,
      MediaQuery.of(context).size.height / 2,
    );

    for (int i = 0; i < widget.particleCount; i++) {
      final angle = _random.nextDouble() * 2 * pi;
      final speed = 2.0 + _random.nextDouble() * 4.0;
      _particles.add(_BurstParticle(
        position: center,
        velocity: Offset(cos(angle) * speed, sin(angle) * speed),
        size: 2.0 + _random.nextDouble() * 4.0,
        opacity: 1.0,
        color: Color.lerp(
          widget.particleColor,
          Colors.white,
          _random.nextDouble() * 0.3,
        )!,
      ));
    }

    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_hasTriggered)
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  for (final particle in _particles) {
                    particle.position += particle.velocity;
                    particle.velocity *= 0.95;
                    particle.opacity = 1.0 - _controller.value;
                    particle.size *= 0.98;
                  }
                  return CustomPaint(
                    painter: _BurstParticlePainter(particles: _particles),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}

class _BurstParticle {
  _BurstParticle({
    required this.position,
    required this.velocity,
    required this.size,
    required this.opacity,
    required this.color,
  });

  Offset position;
  Offset velocity;
  double size;
  double opacity;
  Color color;
}

class _BurstParticlePainter extends CustomPainter {
  _BurstParticlePainter({required this.particles});

  final List<_BurstParticle> particles;

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final paint = Paint()
        ..color = particle.color.withOpacity(particle.opacity.clamp(0.0, 1.0))
        ..style = PaintingStyle.fill;

      canvas.drawCircle(particle.position, particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BurstParticlePainter oldDelegate) => true;
}
