# Animation Library

## Motion Principles
Every transition must feel like a system event. No animation may simply fade. Each motion should combine projection, scan, bloom, particle, or energy effects.

## Animation Definitions

### Window Materialize
- Duration: 360ms
- Easing: Curves.easeOutQuint
- Trigger: screen open, panel open
- Completion state: fully visible with scanline overlay
- Effects: scale from 0.96 to 1.0, subtle blur, particle bloom

### Window Dissolve
- Duration: 260ms
- Easing: Curves.easeOutCubic
- Trigger: panel close
- Completion state: removed with energy fragment effect
- Effects: scale down, dissolve stripes, glow fade

### Scan Reveal
- Duration: 500ms
- Easing: Curves.easeOutExpo
- Trigger: content surface reveal
- Completion state: content fully exposed
- Effects: linear light sweep, scanline mask, subtle parallax

### Particle Burst
- Duration: 420ms
- Easing: Curves.easeOutCubic
- Trigger: achievement unlock, mission complete, level up
- Completion state: particles dissipate
- Effects: burst particles, glow halo, soft screen shake

### Energy Sweep
- Duration: 280ms
- Easing: Curves.easeOutQuad
- Trigger: stat increase, XP gain, mission status change
- Completion state: sweep ends in target state
- Effects: moving light line, glow trail, ripple ring

### XP Overflow
- Duration: 700ms
- Easing: Curves.easeOutExpo
- Trigger: XP crossing threshold
- Completion state: next level state active
- Effects: overflow spark, count-up burst, level flash

### Stat Increase
- Duration: 320ms
- Easing: Curves.easeOutBack
- Trigger: stat value change
- Completion state: bar settles at new value
- Effects: bar pulse, glow, floating numeric delta

### Mission Complete
- Duration: 800ms
- Easing: Curves.easeOutQuint
- Trigger: mission success
- Completion state: reward summary visible
- Effects: shockwave, bloom, particle stream, haptic pulse

### Achievement Reveal
- Duration: 640ms
- Easing: Curves.easeOutCubic
- Trigger: achievement unlocked
- Completion state: card enters completed state
- Effects: ring expansion, scanline, particle burst

### Level Up
- Duration: 900ms
- Easing: Curves.easeOutExpo
- Trigger: level threshold reached
- Completion state: level badge displayed and celebration complete
- Effects: radial burst, title flash, ambient bloom

### Recovery Pulse
- Duration: 460ms
- Easing: Curves.easeOutSine
- Trigger: recovery update or warning state
- Completion state: pulse settles
- Effects: soft ring pulse, color shift, subtle vibration

### System Boot
- Duration: 1200ms
- Easing: Curves.easeOutExpo
- Trigger: app launch or system wake
- Completion state: shell ready and interactive
- Effects: grid scan, ambient particle bloom, HUD fade in
