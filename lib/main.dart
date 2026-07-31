import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(
    const ProviderScope(
      child: SystemTestApp(),
    ),
  );
}

// ============================================================================
// STAGE 6: GAME ENGINE
// ============================================================================

/// Route paths
abstract final class AppRoutes {
  static const home = '/home';
  static const splash = '/splash';
  static const auth = '/auth';
}

/// Navigation keys
final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Simple counter provider for testing Riverpod
final counterProvider = StateProvider<int>((ref) => 0);

// ============================================================================
// GAME ENGINE (Simplified)
// ============================================================================

/// XP source enum
enum XPSource {
  workoutCompletion,
  missionCompletion,
  achievementUnlock,
  dailyBonus
}

/// User stats model
class UserStats {
  final int strength;
  final int endurance;
  final int agility;
  final int intelligence;

  const UserStats({
    this.strength = 10,
    this.endurance = 10,
    this.agility = 10,
    this.intelligence = 10,
  });

  int get total => strength + endurance + agility + intelligence;

  UserStats copyWith({
    int? strength,
    int? endurance,
    int? agility,
    int? intelligence,
  }) {
    return UserStats(
      strength: strength ?? this.strength,
      endurance: endurance ?? this.endurance,
      agility: agility ?? this.agility,
      intelligence: intelligence ?? this.intelligence,
    );
  }
}

/// XP State
class XPState {
  final int totalXP;
  final int level;
  final int currentLevelXP;
  final int xpToNextLevel;
  final int streakDays;

  const XPState({
    this.totalXP = 0,
    this.level = 1,
    this.currentLevelXP = 0,
    this.xpToNextLevel = 100,
    this.streakDays = 0,
  });

  double get levelProgress => currentLevelXP / xpToNextLevel;
}

/// Game state
class GameState {
  final XPState xpState;
  final UserStats userStats;
  final int missionCount;
  final int achievementCount;
  final bool isLoading;

  const GameState({
    this.xpState = const XPState(),
    this.userStats = const UserStats(),
    this.missionCount = 0,
    this.achievementCount = 0,
    this.isLoading = true,
  });

  GameState copyWith({
    XPState? xpState,
    UserStats? userStats,
    int? missionCount,
    int? achievementCount,
    bool? isLoading,
  }) {
    return GameState(
      xpState: xpState ?? this.xpState,
      userStats: userStats ?? this.userStats,
      missionCount: missionCount ?? this.missionCount,
      achievementCount: achievementCount ?? this.achievementCount,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Game engine notifier
class GameEngineNotifier extends StateNotifier<GameState> {
  GameEngineNotifier() : super(const GameState()) {
    _initialize();
  }

  void _initialize() {
    // Simulate loading
    Future.delayed(const Duration(milliseconds: 500), () {
      state = const GameState(
        xpState: XPState(
            totalXP: 1250,
            level: 5,
            currentLevelXP: 50,
            xpToNextLevel: 100,
            streakDays: 3),
        userStats: UserStats(
            strength: 15, endurance: 12, agility: 18, intelligence: 14),
        missionCount: 12,
        achievementCount: 8,
        isLoading: false,
      );
    });
  }

  void addXP(int amount) {
    var newXP = state.xpState.currentLevelXP + amount;
    var newLevel = state.xpState.level;
    var newTotalXP = state.xpState.totalXP + amount;

    while (newXP >= state.xpState.xpToNextLevel) {
      newXP -= state.xpState.xpToNextLevel;
      newLevel++;
    }

    state = state.copyWith(
      xpState: XPState(
        totalXP: newTotalXP,
        level: newLevel,
        currentLevelXP: newXP,
        xpToNextLevel: state.xpState.xpToNextLevel,
        streakDays: state.xpState.streakDays,
      ),
    );
  }

  void completeWorkout(int xpEarned) {
    addXP(xpEarned);
    state = state.copyWith(
      userStats: state.userStats.copyWith(
        strength: state.userStats.strength + 1,
      ),
      missionCount: state.missionCount + 1,
    );
  }
}

/// Game engine provider
final gameEngineProvider =
    StateNotifierProvider<GameEngineNotifier, GameState>((ref) {
  return GameEngineNotifier();
});

/// XP state provider
final xpStateProvider = Provider<XPState>((ref) {
  return ref.watch(gameEngineProvider).xpState;
});

/// User stats provider
final userStatsProvider = Provider<UserStats>((ref) {
  return ref.watch(gameEngineProvider).userStats;
});

// ============================================================================
// DESIGN TOKENS
// ============================================================================

abstract final class AppColors {
  static const Color backgroundPrimary = Color(0xFF050816);
  static const Color backgroundSecondary = Color(0xFF0B1428);
  static const Color accentCyan = Color(0xFF54E6FF);
  static const Color accentBlue = Color(0xFF3C7DFF);
  static const Color accentViolet = Color(0xFF8C7DFF);
  static const Color accentSuccess = Color(0xFF44E28A);
  static const Color accentAmber = Color(0xFFFFB84D);
  static const Color textPrimary = Color(0xFFF5FAFF);
  static const Color textSecondary = Color(0xFF9FB2C8);

  static Color get surfaceGlass => const Color(0xFF0A1626).withOpacity(0.72);
  static Color get surfaceGlassStrong =>
      const Color(0xFF101F36).withOpacity(0.88);
  static const LinearGradient glassOverlay = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x33FFFFFF), Color(0x00FFFFFF)],
  );
}

abstract final class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double radiusMd = 12.0;
}

abstract final class AppBlur {
  static const double strong = 24.0;
}

abstract final class AppAnimations {
  static const Duration standard = Duration(milliseconds: 240);
  static const Curve curveStandard = Curves.easeOutCubic;
}

// ============================================================================
// ACCESSIBILITY SERVICE
// ============================================================================

class AccessibilityService {
  static final AccessibilityService _instance =
      AccessibilityService._internal();
  factory AccessibilityService() => _instance;
  AccessibilityService._internal();

  bool get prefersReducedMotion => false; // Simplified for test
}

/// Auth status enum
enum AuthStatus {
  unknown,
  authenticated,
  unauthenticated,
}

/// Auth state
class AuthState {
  const AuthState({
    this.status = AuthStatus.unknown,
    this.userName,
    this.error,
    this.isLoading = false,
  });

  final AuthStatus status;
  final String? userName;
  final String? error;
  final bool isLoading;

  AuthState copyWith({
    AuthStatus? status,
    String? userName,
    String? error,
    bool? isLoading,
  }) {
    return AuthState(
      status: status ?? this.status,
      userName: userName ?? this.userName,
      error: error,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Auth notifier for managing authentication state
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState()) {
    // Auto-initialize
    Future.microtask(() => checkAuthStatus());
  }

  Future<void> checkAuthStatus() async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 500));
    // For testing: assume not authenticated
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  Future<bool> signIn(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    await Future.delayed(const Duration(seconds: 1));

    // Simple validation for testing
    if (email.isNotEmpty && password.length >= 4) {
      state = AuthState(
        status: AuthStatus.authenticated,
        userName: email.split('@').first,
      );
      return true;
    } else {
      state = state.copyWith(
        isLoading: false,
        error: 'Invalid email or password',
      );
      return false;
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 500));
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}

/// Auth provider
final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

/// Auth page
class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'STAGE 4',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Authentication',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              if (authState.error != null) ...[
                const SizedBox(height: 16),
                Text(
                  authState.error!,
                  style: const TextStyle(color: Colors.red),
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: authState.isLoading
                      ? null
                      : () async {
                          final success = await ref
                              .read(authNotifierProvider.notifier)
                              .signIn(
                                _emailController.text,
                                _passwordController.text,
                              );
                          if (success && context.mounted) {
                            context.go(AppRoutes.home);
                          }
                        },
                  child: authState.isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Sign In'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Splash screen with initialization
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );

    _controller.forward();
    _initializeAndNavigate();
  }

  Future<void> _initializeAndNavigate() async {
    // Initialize auth
    await ref.read(authNotifierProvider.notifier).checkAuthStatus();

    // Additional splash delay
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      final authState = ref.read(authNotifierProvider);
      if (authState.status == AuthStatus.authenticated) {
        context.go(AppRoutes.home);
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
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'STAGE 4',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Splash Page + Auth',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 32),
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    const Text('Initializing...'),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ============================================================================
// HOLOGRAPHIC CONTAINER WIDGET
// ============================================================================

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

    if (widget.animateGlow) {
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final glowIntensity = widget.animateGlow
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
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    border: Border.all(
                      color: widget.glowColor.withOpacity(0.45),
                      width: widget.borderWidth,
                    ),
                  ),
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

// ============================================================================
// HOME SCREEN WITH HOLOGRAPHIC UI + GAME ENGINE
// ============================================================================

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    final authState = ref.watch(authNotifierProvider);
    final gameState = ref.watch(gameEngineProvider);
    final xpState = ref.watch(xpStateProvider);
    final userStats = ref.watch(userStatsProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.backgroundPrimary,
              AppColors.backgroundSecondary,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'STAGE 6',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                    color: AppColors.accentCyan,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Game Engine',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),

                // XP Progress Card
                HolographicContainer(
                  glowColor: AppColors.accentViolet,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Level ${xpState.level}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              '${xpState.totalXP} XP',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.accentViolet,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: xpState.levelProgress,
                            backgroundColor: AppColors.backgroundSecondary,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                AppColors.accentViolet),
                            minHeight: 8,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          '${xpState.currentLevelXP} / ${xpState.xpToNextLevel} to next level',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                // Stats Grid
                Row(
                  children: [
                    Expanded(
                        child: _StatCard(
                            title: 'STR',
                            value: userStats.strength,
                            color: AppColors.accentSuccess)),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                        child: _StatCard(
                            title: 'END',
                            value: userStats.endurance,
                            color: AppColors.accentAmber)),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                        child: _StatCard(
                            title: 'AGI',
                            value: userStats.agility,
                            color: AppColors.accentCyan)),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                        child: _StatCard(
                            title: 'INT',
                            value: userStats.intelligence,
                            color: AppColors.accentViolet)),
                  ],
                ),

                const SizedBox(height: AppSpacing.xxl),

                // Game Actions
                Center(
                  child: HolographicContainer(
                    width: double.infinity,
                    glowColor: AppColors.accentCyan,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      child: Column(
                        children: [
                          const Text(
                            'Mission Console',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            'Missions: ${gameState.missionCount} | Achievements: ${gameState.achievementCount}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          Text(
                            '$count',
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: AppColors.accentCyan,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          const Text(
                            'Operations Completed',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _ActionButton(
                                icon: Icons.fitness_center,
                                label: 'Train (+25 XP)',
                                color: AppColors.accentSuccess,
                                onPressed: () {
                                  ref.read(counterProvider.notifier).state++;
                                  ref
                                      .read(gameEngineProvider.notifier)
                                      .completeWorkout(25);
                                },
                              ),
                              const SizedBox(width: AppSpacing.md),
                              _ActionButton(
                                icon: Icons.refresh,
                                label: 'Reset',
                                color: AppColors.accentAmber,
                                onPressed: () => ref
                                    .read(counterProvider.notifier)
                                    .state = 0,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.xxl),

                // Streak Info
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.local_fire_department,
                        color: AppColors.accentAmber, size: 20),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      '${xpState.streakDays} Day Streak!',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.accentAmber,
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () async {
                      await ref.read(authNotifierProvider.notifier).signOut();
                      if (context.mounted) {
                        context.go(AppRoutes.auth);
                      }
                    },
                    child: const Text(
                      'Sign Out',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.color,
  });

  final String title;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return HolographicContainer(
      glowColor: color,
      glowIntensity: 0.15,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.md, horizontal: AppSpacing.sm),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              '$value',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return HolographicContainer(
      glowColor: color,
      glowIntensity: 0.2,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  label,
                  style: TextStyle(color: color, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.title,
    required this.value,
    required this.color,
  });

  final String title;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return HolographicContainer(
      glowColor: color,
      glowIntensity: 0.15,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Router configuration
final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.auth,
      name: 'auth',
      builder: (context, state) => const AuthPage(),
    ),
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);

/// Minimal system test app with GoRouter + Riverpod + Splash + Auth + Holographic UI + Game Engine - Stage 6
class SystemTestApp extends StatelessWidget {
  const SystemTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'System Test',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      routerConfig: router,
    );
  }
}
