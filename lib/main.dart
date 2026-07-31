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
}

/// Navigation keys
final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Simple counter provider for testing Riverpod
final counterProvider = StateProvider<int>((ref) => 0);

/// Router configuration
final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);

/// Home screen using Riverpod
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Stage 2: Riverpod'),
            const Text('System Test'),
            const SizedBox(height: 20),
            Text('Counter: $count'),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => ref.read(counterProvider.notifier).state++,
              child: const Text('Increment'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Minimal system test app with GoRouter + Riverpod - Stage 2
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
