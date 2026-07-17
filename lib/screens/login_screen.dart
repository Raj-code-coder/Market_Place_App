import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/user_models.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isSignUp = true;
  UserRole _selectedRole = UserRole.farmer;
  bool _isSubmitting = false;
  String? _errorMessage;

  static const gold = Color(0xFFD4AF37);

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      final notifier = ref.read(currentUserProvider.notifier);
      if (_isSignUp) {
        await notifier.signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          name: _nameController.text.trim(),
          role: _selectedRole,
        );
        if (!mounted) return;
        context.go('/profile-setup');
      } else {
        await notifier.signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
        if (!mounted) return;
        final user = ref.read(currentUserProvider).value;
        if (user == null) return;
        if (!user.profileComplete) {
          context.go('/profile-setup');
        } else if (user.role == UserRole.farmer) {
          context.go('/farmer/home');
        } else {
          context.go('/buyer/home');
        }
      }
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  InputDecoration _fieldDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 1),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 2),
      ),
      border: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[900],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                Text(
                  _isSignUp ? 'Create your account' : 'Akwaaba',
                  style: const TextStyle(
                    color: gold,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                if (_isSignUp) ...[
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<UserRole>(
                          title: const Text(
                            'Farmer',
                            style: TextStyle(color: Colors.white),
                          ),
                          value: UserRole.farmer,
                          groupValue: _selectedRole,
                          activeColor: gold,
                          onChanged: (v) => setState(() => _selectedRole = v!),
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<UserRole>(
                          title: const Text(
                            'Buyer',
                            style: TextStyle(color: Colors.white),
                          ),
                          value: UserRole.buyer,
                          groupValue: _selectedRole,
                          activeColor: gold,
                          onChanged: (v) => setState(() => _selectedRole = v!),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: _fieldDecoration('Full name'),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Enter your name'
                        : null,
                  ),
                  const SizedBox(height: 16),
                ],
                TextFormField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.emailAddress,
                  decoration: _fieldDecoration('Email'),
                  validator: (v) => (v == null || !v.contains('@'))
                      ? 'Enter a valid email'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  style: const TextStyle(color: Colors.white),
                  obscureText: true,
                  decoration: _fieldDecoration('Password'),
                  validator: (v) => (v == null || v.length < 6)
                      ? 'At least 6 characters'
                      : null,
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.redAccent),
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _isSubmitting ? null : _submit,
                  style: FilledButton.styleFrom(
                    backgroundColor: gold,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.black,
                          ),
                        )
                      : Text(
                          _isSignUp ? 'Sign up' : 'Log in',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => setState(() => _isSignUp = !_isSignUp),
                  child: Text(
                    _isSignUp
                        ? 'Already have an account? Log in'
                        : "Don't have an account? Sign up",
                    style: const TextStyle(color: gold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}