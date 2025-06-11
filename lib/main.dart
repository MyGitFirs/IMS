import 'package:flutter/material.dart';
import 'package:flutter_application_1/app_theme.dart';
import 'package:flutter_application_1/controllers/menu_app_controller.dart';
import 'package:flutter_application_1/screens/auth/login.dart';
import 'package:flutter_application_1/screens/admin/admin_screen.dart';
import 'package:flutter_application_1/screens/main/fifth_screen.dart';
import 'package:flutter_application_1/screens/main/fourth_screen.dart';
import 'package:flutter_application_1/screens/main/main_screen.dart';
import 'package:flutter_application_1/screens/auth/sign_up.dart';
import 'package:flutter_application_1/screens/main/second_screen.dart';
import 'package:flutter_application_1/screens/main/third_screen.dart';
import 'package:flutter_application_1/screens/product/product.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/product/dialog/edit_product.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Use the generated options
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Add observer
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Remove observer
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // Handle app lifecycle changes
    switch (state) {
      case AppLifecycleState.resumed:
        print("App resumed");
        break;
      case AppLifecycleState.inactive:
        print("App inactive");
        break;
      case AppLifecycleState.paused:
        print("App paused");
        break;
      case AppLifecycleState.detached:
        print("App detached");
        break;
      case AppLifecycleState.hidden:
        print("App hidden (Web-specific)");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MenuAppController(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Scan IT',
        theme: AppTheme.theme,
        routerConfig: _router,
      ),
    );
  }
}


// Define the routes using GoRouter
final GoRouter _router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginInPage(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignInPage1(),
    ),
    GoRoute(
      path: '/admin',
      builder: (context, state) => const AdminDashboard(),
    ),
    GoRoute(
      path: '/main',
      builder: (context, state) => const MainScreen(),
    ),
    GoRoute(
      path: '/second',
      builder: (context, state) => const SecondScreen(),
    ),
    GoRoute(
      path: '/third',
      builder: (context, state) => const ThirdScreen(),
    ),
    GoRoute(
      path: '/fourth',
      builder: (context, state) => const FourthScreen(),
    ),
    GoRoute(
      path: '/fifth',
      builder: (context, state) => const FifthScreen(),
    ),
    GoRoute(
      path: '/product/:id',
      builder: (context, state) {
        // Use state.pathParameters to access route parameters
        final productId = state.pathParameters['id']!;
        return ProductDetailScreen(productId: productId);
      },
    ),
    GoRoute(
      path: '/edit-product',
      builder: (context, state) {
        final product = state.extra as Map<String, dynamic>;
        return ProductEditScreen(product: product);
      },
    ),
  ],
);
