import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router.dart';
import '../../../../core/constants/constants.dart';

/// Main shell with bottom navigation.
class MainShell extends StatefulWidget {
  const MainShell({super.key, required this.child});

  final Widget child;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  int _selectedIndex = 0;

  static const _navItems = [
    _NavItem(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      label: 'Home',
      route: AppRoutes.home,
    ),
    _NavItem(
      icon: Icons.assignment_outlined,
      selectedIcon: Icons.assignment,
      label: 'Missions',
      route: AppRoutes.missions,
    ),
    _NavItem(
      icon: Icons.fitness_center_outlined,
      selectedIcon: Icons.fitness_center,
      label: 'Train',
      route: AppRoutes.training,
    ),
    _NavItem(
      icon: Icons.trending_up_outlined,
      selectedIcon: Icons.trending_up,
      label: 'Progress',
      route: AppRoutes.progress,
    ),
    _NavItem(
      icon: Icons.inventory_2_outlined,
      selectedIcon: Icons.inventory_2,
      label: 'Inventory',
      route: AppRoutes.inventory,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _updateSelectedIndex();
  }

  void _updateSelectedIndex() {
    final location = GoRouterState.of(context).matchedLocation;
    for (int i = 0; i < _navItems.length; i++) {
      if (location.startsWith(_navItems[i].route)) {
        if (_selectedIndex != i) {
          setState(() => _selectedIndex = i);
        }
        break;
      }
    }
  }

  @override
  void didUpdateWidget(MainShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateSelectedIndex();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onNavTap(int index) {
    if (index != _selectedIndex) {
      context.go(_navItems[index].route);
      setState(() => _selectedIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.ambientBackground,
        ),
        child: Stack(
          children: [
            // Background effects
            const _BackgroundGrid(),

            // Main content
            widget.child,

            // Bottom navigation
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceGlassStrong,
                  border: Border(
                    top: BorderSide(
                      color: AppColors.borderAccent.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(_navItems.length, (index) {
                        final item = _navItems[index];
                        final isSelected = index == _selectedIndex;

                        return _NavBarItem(
                          icon: item.icon,
                          selectedIcon: item.selectedIcon,
                          label: item.label,
                          isSelected: isSelected,
                          onTap: () => _onNavTap(index),
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.route,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final String route;
}

class _NavBarItem extends StatefulWidget {
  const _NavBarItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_NavBarItem> createState() => _NavBarItemState();
}

class _NavBarItemState extends State<_NavBarItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );
  }

  @override
  void didUpdateWidget(_NavBarItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _controller.forward().then((_) => _controller.reverse());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          color: widget.isSelected
              ? AppColors.accentCyan.withOpacity(0.1)
              : Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: widget.isSelected ? _scaleAnimation.value : 1.0,
                  child: Icon(
                    widget.isSelected ? widget.selectedIcon : widget.icon,
                    color: widget.isSelected
                        ? AppColors.accentCyan
                        : AppColors.textSecondary,
                    size: 24,
                  ),
                );
              },
            ),
            const SizedBox(height: 4),
            Text(
              widget.label,
              style: AppTypography.labelSmall.copyWith(
                color: widget.isSelected
                    ? AppColors.accentCyan
                    : AppColors.textSecondary,
                fontWeight:
                    widget.isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
            if (widget.isSelected)
              Container(
                margin: const EdgeInsets.only(top: 4),
                width: 20,
                height: 2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1),
                  gradient: AppColors.energyActive,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _BackgroundGrid extends StatelessWidget {
  const _BackgroundGrid();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: MediaQuery.of(context).size,
      painter: _GridPainter(),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.accentCyan.withOpacity(0.03)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    const spacing = 60.0;

    // Vertical lines
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Horizontal lines
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
