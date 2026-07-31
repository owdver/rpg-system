import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const SystemTestApp());
}

/// Route paths
abstract final class AppRoutes {
  static const home = '/home';
  static const splash = '/splash';
}

/// Navigation keys
final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Router configuration
final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Stage 1: Router'),
              Text('System Test'),
            ],
          ),
        ),
      ),
    ),
  ],
);

/// Minimal system test app with GoRouter - Stage 1
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
