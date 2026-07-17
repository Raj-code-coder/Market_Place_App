import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/user_models.dart';
import '../providers/auth_provider.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _businessNameController = TextEditingController();
  final _locationController = TextEditingController();
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _phoneController.dispose();
    _businessNameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _submit(UserRole role) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      await ref
          .read(currentUserProvider.notifier)
          .completeProfile(
            phone: _phoneController.text.trim(),
            businessName: _businessNameController.text.trim(),
            location: _locationController.text.trim(),
          );
      if (!mounted) return;
      if (role == UserRole.farmer) {
        context.go('/farmer/home');
      } else {
        context.go('/buyer/home');
      }
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider).value;
    final role = user?.role ?? UserRole.buyer;
    final isFarmer = role == UserRole.farmer;

    return Scaffold(
      appBar: AppBar(title: const Text('Complete your profile')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Phone number',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => (v == null || v.trim().length < 7)
                      ? 'Enter a valid phone number'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _businessNameController,
                  decoration: InputDecoration(
                    labelText: isFarmer
                        ? 'Farm name'
                        : 'Restaurant / hotel name',
                    border: const OutlineInputBorder(),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'This field is required'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    labelText: 'Location / address',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'This field is required'
                      : null,
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _isSubmitting ? null : () => _submit(role),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Continue'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
