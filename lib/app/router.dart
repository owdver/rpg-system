import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/authentication/presentation/pages/auth_page.dart';
import '../features/authentication/presentation/pages/splash_page.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/home/presentation/pages/main_shell.dart';
import '../features/missions/presentation/pages/missions_page.dart';
import '../features/training/presentation/pages/training_page.dart';
import '../features/recovery/presentation/pages/recovery_page.dart';
import '../features/progress/presentation/pages/progress_page.dart';
import '../features/inventory/presentation/pages/inventory_page.dart';
import '../features/achievements/presentation/pages/achievement_detail_page.dart';
import '../features/profile/presentation/pages/profile_page.dart';
import '../features/settings/presentation/pages/settings_page.dart';
import '../features/onboarding/presentation/pages/onboarding_page.dart';
import '../features/skills/presentation/pages/skill_tree_page.dart';
import '../features/boss/presentation/pages/boss_arena_page.dart';
import '../features/analytics/presentation/pages/analytics_dashboard_page.dart';
import 'providers/auth_provider.dart';
import '../core/services/logger_service.dart';

// Router trace logger
final _trace = LoggerService.instance.getLogger('Router');

/// Route paths following the navigation spec.
abstract final class AppRoutes {
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const auth = '/auth';
  static const home = '/home';
  static const missions = '/missions';
  static const missionDetail = '/missions/:id';
  static const training = '/training';
  static const workoutSession = '/training/session';
  static const recovery = '/recovery';
  static const progress = '/progress';
  static const inventory = '/inventory';
  static const profile = '/profile';
  static const settings = '/settings';
  static const achievementDetail = '/achievement/:id';
  static const titleDetail = '/title/:id';
  static const skillTree = '/skill-tree';
  static const bossMission = '/boss/:id';
  static const notifications = '/notifications';
  static const analytics = '/analytics';
}

/// Navigation keys for nested navigation.
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

/// The application router configuration.
final routerProvider = Provider<GoRouter>((ref) {
  _trace.enter('routerProvider');

  _trace.enter('authNotifierProvider.watch');
  final authState = ref.watch(authNotifierProvider);
  _trace.exit('authNotifierProvider.watch', authState.status);

  _trace.enter('GoRouter.new');
  final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    routes: [
      // Splash route
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) {
          _trace.enter('SplashPage.build');
          final result = const SplashPage();
          _trace.exit('SplashPage.build');
          return result;
        },
      ),

      // Onboarding route
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (context, state) {
          _trace.enter('OnboardingPage.build');
          final result = const OnboardingPage();
          _trace.exit('OnboardingPage.build');
          return result;
        },
      ),

      // Authentication routes
      GoRoute(
        path: AppRoutes.auth,
        name: 'auth',
        builder: (context, state) {
          _trace.enter('AuthPage.build');
          final result = const AuthPage();
          _trace.exit('AuthPage.build');
          return result;
        },
      ),

      // Main app shell with bottom navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          _trace.enter('MainShell.build');
          final result = MainShell(child: child);
          _trace.exit('MainShell.build');
          return result;
        },
        routes: [
          // Home tab
          GoRoute(
            path: AppRoutes.home,
            name: 'home',
            pageBuilder: (context, state) {
              _trace.enter('HomePage.pageBuilder');
              _trace.exit('HomePage.pageBuilder');
              return _buildPageWithTransition(
                context,
                state,
                const HomePage(),
              );
            },
          ),

          // Missions tab
          GoRoute(
            path: AppRoutes.missions,
            name: 'missions',
            pageBuilder: (context, state) => _buildPageWithTransition(
              context,
              state,
              const MissionsPage(),
            ),
            routes: [
              GoRoute(
                path: ':id',
                name: 'missionDetail',
                pageBuilder: (context, state) {
                  final missionId = state.pathParameters['id']!;
                  return _buildPageWithTransition(
                    context,
                    state,
                    MissionDetailPage(missionId: missionId),
                  );
                },
              ),
            ],
          ),

          // Training tab
          GoRoute(
            path: AppRoutes.training,
            name: 'training',
            pageBuilder: (context, state) => _buildPageWithTransition(
              context,
              state,
              const TrainingPage(),
            ),
          ),

          // Progress tab
          GoRoute(
            path: AppRoutes.progress,
            name: 'progress',
            pageBuilder: (context, state) => _buildPageWithTransition(
              context,
              state,
              const ProgressPage(),
            ),
          ),

          // Inventory tab
          GoRoute(
            path: AppRoutes.inventory,
            name: 'inventory',
            pageBuilder: (context, state) => _buildPageWithTransition(
              context,
              state,
              const InventoryPage(),
            ),
          ),
        ],
      ),

      // Full-screen routes outside the shell
      GoRoute(
        path: AppRoutes.workoutSession,
        name: 'workoutSession',
        pageBuilder: (context, state) => _buildFullscreenPage(
          context,
          state,
          const TrainingPage(), // TODO: Replace with WorkoutSessionPage
        ),
      ),
      GoRoute(
        path: AppRoutes.recovery,
        name: 'recovery',
        pageBuilder: (context, state) => _buildFullscreenPage(
          context,
          state,
          const RecoveryPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        pageBuilder: (context, state) => _buildFullscreenPage(
          context,
          state,
          const ProfilePage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        pageBuilder: (context, state) => _buildFullscreenPage(
          context,
          state,
          const SettingsPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.achievementDetail,
        name: 'achievementDetail',
        pageBuilder: (context, state) {
          final achievementId = state.pathParameters['id']!;
          return _buildFullscreenPage(
            context,
            state,
            AchievementDetailPage(achievementId: achievementId),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.skillTree,
        name: 'skillTree',
        pageBuilder: (context, state) => _buildFullscreenPage(
          context,
          state,
          const SkillTreePage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.bossMission,
        name: 'bossMission',
        pageBuilder: (context, state) => _buildFullscreenPage(
          context,
          state,
          const BossArenaPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        name: 'notifications',
        pageBuilder: (context, state) => _buildFullscreenPage(
          context,
          state,
          const Scaffold(
            body: Center(child: Text('Notifications (Coming Soon)')),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.analytics,
        name: 'analytics',
        pageBuilder: (context, state) => _buildFullscreenPage(
          context,
          state,
          const AnalyticsDashboardPage(),
        ),
      ),
    ],

    // Redirect logic based on authentication state
    redirect: (context, state) {
      _trace.enter('GoRouter.redirect', {'path': state.matchedLocation});

      final isAuthenticated = authState.status == AuthStatus.authenticated;
      final isLoading = authState.isLoading;
      final isOnAuthRoute = state.matchedLocation == AppRoutes.auth ||
          state.matchedLocation == AppRoutes.splash ||
          state.matchedLocation == AppRoutes.onboarding;

      String? result;
      if (isLoading) {
        _trace.debug('Redirect: isLoading=true, returning null');
        result = null;
      } else if (!isAuthenticated && !isOnAuthRoute) {
        _trace.debug('Redirect: !authenticated && !onAuthRoute, going to auth');
        result = AppRoutes.auth;
      } else if (isAuthenticated && isOnAuthRoute) {
        _trace.debug('Redirect: authenticated && onAuthRoute, going to home');
        result = AppRoutes.home;
      } else {
        _trace.debug('Redirect: no redirect needed');
        result = null;
      }

      _trace.exit('GoRouter.redirect', result);
      return result;
    },

    // Error handling
    errorBuilder: (context, state) {
      _trace.error('GoRouter error', state.error);
      debugPrint('[ROUTER ERROR] Path: ${state.uri}');
      debugPrint('[ROUTER ERROR] Error: ${state.error}');
      debugPrint('[ROUTER ERROR] ErrorType: ${state.error?.runtimeType}');
      return Scaffold(
        backgroundColor: Colors.red.shade900,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 80,
                  color: Colors.white,
                ),
                const SizedBox(height: 24),
                const Text(
                  'ROUTER ERROR',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Path: ${state.uri}',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 24),
                if (state.error != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: SingleChildScrollView(
                      child: SelectableText(
                        '${state.error}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => context.go(AppRoutes.home),
                  child: const Text('Go Home'),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
  _trace.exit('GoRouter.new', router);
  _trace.exit('routerProvider');

  return router;
});

/// Builds a page with holographic transition animation.
Page<void> _buildPageWithTransition(
  BuildContext context,
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 360),
    reverseTransitionDuration: const Duration(milliseconds: 260),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curve = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutQuint,
        reverseCurve: Curves.easeOutCubic,
      );

      return FadeTransition(
        opacity: curve,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.96, end: 1.0).animate(curve),
          child: child,
        ),
      );
    },
  );
}

/// Builds a full-screen page with materialize animation.
Page<void> _buildFullscreenPage(
  BuildContext context,
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 400),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curve = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutExpo,
        reverseCurve: Curves.easeOutCubic,
      );

      return FadeTransition(
        opacity: curve,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.05),
            end: Offset.zero,
          ).animate(curve),
          child: child,
        ),
      );
    },
  );
}
