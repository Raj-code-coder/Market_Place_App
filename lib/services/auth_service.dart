import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/supabase_config.dart';
import '../models/user_models.dart';

class AuthService {
  final SupabaseClient _client = supabase;

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  User? get currentAuthUser => _client.auth.currentUser;

  Future<AppUser> signUp({
    required String email,
    required String password,
    required String businessName,
    required String contactPerson,
    required String phoneNumber,
    required UserRole role,
  }) async {
    final response = await _client.auth.signUp(email: email, password: password);
    final authUser = response.user;
    if (authUser == null) {
      throw Exception('Sign up failed: no user returned.');
    }

    final appUser = AppUser(
      id: authUser.id,
      businessName: businessName,
      contactPerson: contactPerson,
      phoneNumber: phoneNumber,
      role: role,
    );

    await _client.from('profiles').insert(appUser.toMap());
    return appUser;
  }

  Future<AppUser> signIn({required String email, required String password}) async {
    final response = await _client.auth.signInWithPassword(email: email, password: password);
    final authUser = response.user;
    if (authUser == null) {
      throw Exception('Sign in failed: invalid credentials.');
    }
    return fetchUserProfile(authUser.id);
  }

  Future<AppUser> fetchUserProfile(String uid) async {
    final data = await _client.from('profiles').select().eq('id', uid).single();
    return AppUser.fromMap(data);
  }

  Future<void> signOut() => _client.auth.signOut();
}