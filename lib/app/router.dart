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
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    routes: [
      // Splash route
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),

      // Onboarding route
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),

      // Authentication routes
      GoRoute(
        path: AppRoutes.auth,
        name: 'auth',
        builder: (context, state) => const AuthPage(),
      ),

      // Main app shell with bottom navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          // Home tab
          GoRoute(
            path: AppRoutes.home,
            name: 'home',
            pageBuilder: (context, state) => _buildPageWithTransition(
              context,
              state,
              const HomePage(),
            ),
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
      final isAuthenticated = authState.status == AuthStatus.authenticated;
      final isLoading = authState.isLoading;
      final isOnAuthRoute = state.matchedLocation == AppRoutes.auth ||
          state.matchedLocation == AppRoutes.splash ||
          state.matchedLocation == AppRoutes.onboarding;

      if (isLoading) {
        return null;
      }

      if (!isAuthenticated && !isOnAuthRoute) {
        return AppRoutes.auth;
      }

      if (isAuthenticated && isOnAuthRoute) {
        return AppRoutes.home;
      }

      return null;
    },

    // Error handling
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              state.uri.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
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
