# Performance Budget

## Targets
- 120 FPS on supported devices for core UI and animation.
- Maximum 10 widget rebuilds per frame for a single screen when idle.
- Maximum 3 expensive particle systems visible at once.
- Memory usage target: under 180MB for normal app usage.
- Texture count target: under 60 active textures on a screen.
- Particle limit: 250 active particles per scene.

## Optimization Rules
- Use lazy loading for lower-priority panels.
- Avoid large list rebuilds and unnecessary state updates.
- Partition animations by priority and reduce intensity under battery saver mode.
