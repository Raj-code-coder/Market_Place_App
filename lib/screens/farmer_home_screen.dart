import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';

class FarmerHomeScreen extends ConsumerWidget {
  const FarmerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farmer Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(currentUserProvider.notifier).signOut();
              if (context.mounted) context.go('/login');
            },
          ),
        ],
      ),
      body: Center(child: Text('Welcome, ${user?.name ?? 'farmer'} 🌾')),
    );
  }
}
