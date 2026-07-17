import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_models.dart';
import '../services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authStateProvider = StreamProvider<AuthState>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

class CurrentUserNotifier extends StateNotifier<AsyncValue<AppUser?>> {
  final AuthService _authService;

  CurrentUserNotifier(this._authService) : super(const AsyncValue.data(null)) {
    _init();
  }

  Future<void> _init() async {
    final authUser = _authService.currentAuthUser;
    if (authUser != null) {
      await refresh();
    }
  }

  Future<void> refresh() async {
    final authUser = _authService.currentAuthUser;
    if (authUser == null) {
      state = const AsyncValue.data(null);
      return;
    }
    state = const AsyncValue.loading();
    try {
      final profile = await _authService.fetchUserProfile(authUser.id);
      state = AsyncValue.data(profile);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String businessName,
    required String contactPerson,
    required String phoneNumber,
    required UserRole role,
  }) async {
    state = const AsyncValue.loading();
    try {
      final user = await _authService.signUp(
        email: email,
        password: password,
        businessName: businessName,
        contactPerson: contactPerson,
        phoneNumber: phoneNumber,
        role: role,
      );
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncValue.loading();
    try {
      final user = await _authService.signIn(email: email, password: password);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    state = const AsyncValue.data(null);
  }
}

final currentUserProvider = StateNotifierProvider<CurrentUserNotifier, AsyncValue<AppUser?>>((ref) {
  return CurrentUserNotifier(ref.watch(authServiceProvider));
});