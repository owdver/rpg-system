import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// This test simulates the exact startup flow of the RPG System app
/// to identify where execution might stop or loop.

void main() {
  testWidgets('RPG System Startup Flow - Full Integration Test',
      (WidgetTester tester) async {
    final executionLog = <String>[];

    void log(String step) {
      final timestamp = DateTime.now().toIso8601String().substring(11, 23);
      final msg = '[$timestamp] $step';
      executionLog.add(msg);
      debugPrint(msg);
    }

    log('TEST START');

    // Step 1: Simulate main() entry
    log('1. main() called');

    // Step 2: Simulate WidgetsFlutterBinding.ensureInitialized
    log('2. WidgetsFlutterBinding.ensureInitialized');
    WidgetsFlutterBinding.ensureInitialized();
    log('2. COMPLETE');

    // Step 3: Simulate runApp with ProviderScope
    log('3. runApp with ProviderScope');

    await tester.pumpWidget(
      ProviderScope(
        child: TestApp(log: log),
      ),
    );

    log('3. COMPLETE');

    // Step 4: Wait for initial frame
    log('4. pump (waiting for initial frame)');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    log('4. COMPLETE');

    // Step 5: Check if SplashPage is rendered
    log('5. Checking for SplashPage');
    final splashFinder = find.text('INITIALIZING...');
    if (splashFinder.evaluate().isNotEmpty) {
      log('5. FOUND SplashPage - rendering correctly');
    } else {
      log('5. SplashPage NOT FOUND - checking what IS on screen');
      final allText = find.byType(Text);
      for (final text in allText.evaluate()) {
        final widget = text.widget as Text;
        log('   Found Text widget: "${widget.data}"');
      }
    }

    // Step 6: Wait for navigation (2000ms = animation + 1800ms wait)
    log('6. Waiting for navigation (2000ms)');
    await tester.pump(const Duration(milliseconds: 2000));
    await tester.pumpAndSettle();
    log('6. COMPLETE');

    // Step 7: Check for AuthPage or HomePage
    log('7. Checking for target page');
    final authFinder = find.text('Sign In');
    final homeFinder = find.text('OPERATIVE');

    if (authFinder.evaluate().isNotEmpty) {
      log('7. FOUND AuthPage - navigation works!');
    } else if (homeFinder.evaluate().isNotEmpty) {
      log('7. FOUND HomePage - already authenticated!');
    } else {
      log('7. WARNING: Neither AuthPage nor HomePage found');
      // Dump all widgets on screen
      log('   Current widgets: ${_dumpWidgets(tester)}');
    }

    // Print summary
    log('\\n=== STARTUP EXECUTION LOG ===');
    for (final entry in executionLog) {
      print(entry);
    }
    log('=== END LOG ===\\n');

    // Assertions - verify we can find either the splash page OR the target page
    // (the splash page might navigate quickly)
    expect(
      splashFinder.evaluate().isNotEmpty ||
          authFinder.evaluate().isNotEmpty ||
          homeFinder.evaluate().isNotEmpty,
      true,
      reason: 'App should be rendering something',
    );
  });
}

String _dumpWidgets(WidgetTester tester) {
  final buffer = StringBuffer();
  tester.allWidgets.forEach((widget) {
    if (widget is Text) {
      buffer.write('Text("${widget.data}"), ');
    } else if (widget is Scaffold) {
      buffer.write('Scaffold, ');
    } else if (widget is AppBar) {
      buffer.write('AppBar, ');
    } else if (widget is CircularProgressIndicator) {
      buffer.write('CircularProgressIndicator, ');
    }
  });
  return buffer.toString();
}

/// Test app that mirrors the RPG System app structure
class TestApp extends StatelessWidget {
  final void Function(String) log;

  const TestApp({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    log('TestApp.build');

    return MaterialApp.router(
      title: 'System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      routerConfig: _createRouter(),
    );
  }

  GoRouter _createRouter() {
    log('_createRouter');

    return GoRouter(
      initialLocation: '/splash',
      debugLogDiagnostics: true,
      routes: [
        GoRoute(
          path: '/splash',
          name: 'splash',
          builder: (context, state) {
            log('SplashPage.build');
            return const TestSplashPage();
          },
        ),
        GoRoute(
          path: '/auth',
          name: 'auth',
          builder: (context, state) {
            log('AuthPage.build');
            return const Scaffold(
              body: Center(
                child: Text('Sign In'),
              ),
            );
          },
        ),
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) {
            log('HomePage.build');
            return const Scaffold(
              body: Center(
                child: Text('OPERATIVE'),
              ),
            );
          },
        ),
      ],
    );
  }
}

/// Test splash page that mirrors the actual SplashPage
class TestSplashPage extends StatefulWidget {
  const TestSplashPage({super.key});

  @override
  State<TestSplashPage> createState() => _TestSplashPageState();
}

class _TestSplashPageState extends State<TestSplashPage> {
  void log(String msg) {
    debugPrint('[$msg]');
  }

  @override
  void initState() {
    log('TestSplashPage.initState START');
    super.initState();
    log('TestSplashPage.initState: scheduling _initializeAndNavigate');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      log('TestSplashPage: post-frame callback');
    });
    _initializeAndNavigate();
    log('TestSplashPage.initState END');
  }

  Future<void> _initializeAndNavigate() async {
    log('_initializeAndNavigate START');

    // Simulate auth check
    log('_initializeAndNavigate: checking auth...');
    await Future.delayed(const Duration(milliseconds: 100));

    log('_initializeAndNavigate: navigating to /auth');
    if (mounted) {
      context.go('/auth');
    } else {
      log('_initializeAndNavigate: SKIPPED - not mounted');
    }

    log('_initializeAndNavigate END');
  }

  @override
  void dispose() {
    log('TestSplashPage.dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log('TestSplashPage.build START');

    final result = Scaffold(
      body: Container(
        color: const Color(0xFF050816),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.psychology_outlined,
                  size: 64, color: Color(0xFF00BCD4)),
              const SizedBox(height: 20),
              const Text(
                'SYSTEM',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  letterSpacing: 8,
                ),
              ),
              const SizedBox(height: 20),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00BCD4)),
              ),
              const SizedBox(height: 20),
              const Text(
                'INITIALIZING...',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  letterSpacing: 4,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    log('TestSplashPage.build END');
    return result;
  }
}
