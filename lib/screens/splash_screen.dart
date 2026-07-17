import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:market_placeapp/models/user_models.dart';
import '../providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _route());
  }

  Future<void> _route() async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;

    final authUser = ref.read(authServiceProvider).currentAuthUser;
    if (authUser == null) {
      context.go('/login');
      return;
    }

    await ref.read(currentUserProvider.notifier).refresh();
    if (!mounted) return;

    final user = ref.read(currentUserProvider).value;

    if (user == null) {
      context.go('/login');
    } else if (!user.profileComplete) {
      context.go('/profile-setup');
    } else if (user.role.value == 'farmer') {
      context.go('/farmer/home');
    } else {
      context.go('/buyer/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.agriculture, size: 72, color: Colors.green),
            SizedBox(height: 16),
            Text(
              'Farm Marketplace',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
