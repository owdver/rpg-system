import 'dart:async';
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

/// Home screen using Riverpod
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    final authState = ref.watch(authNotifierProvider);
    
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Stage 4: Authentication',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text('System Test'),
            const SizedBox(height: 8),
            Text(
              'Welcome, ${authState.userName ?? "User"}!',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            Text('Counter: $count'),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => ref.read(counterProvider.notifier).state++,
              child: const Text('Increment'),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () async {
                await ref.read(authNotifierProvider.notifier).signOut();
                if (context.mounted) {
                  context.go(AppRoutes.auth);
                }
              },
              child: const Text('Sign Out'),
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

/// Minimal system test app with GoRouter + Riverpod + Splash + Auth - Stage 4
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
