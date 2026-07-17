import 'package:go_router/go_router.dart';
import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/profile_setup.dart';
import '../screens/farmer_home_screen.dart';
import '../screens/buyer_home_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/profile-setup',
      builder: (context, state) => const ProfileSetupScreen(),
    ),
    GoRoute(
      path: '/farmer/home',
      builder: (context, state) => const FarmerHomeScreen(),
    ),
    GoRoute(
      path: '/buyer/home',
      builder: (context, state) => const BuyerHomeScreen(),
    ),
  ],
);
