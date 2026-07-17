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
    required String name,
    required UserRole role,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
    );
    final authUser = response.user;
    if (authUser == null) {
      throw Exception('Sign up failed: no user returned.');
    }

    final appUser = AppUser(
      id: authUser.id,
      name: name,
      email: email,
      role: role,
    );
    await _client.from('users').insert(appUser.toMap());
    return appUser;
  }

  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    final authUser = response.user;
    if (authUser == null) {
      throw Exception('Sign in failed: invalid credentials.');
    }
    return fetchUserProfile(authUser.id);
  }

  Future<AppUser> fetchUserProfile(String uid) async {
    final data = await _client.from('users').select().eq('id', uid).single();
    return AppUser.fromMap(data);
  }

  Future<void> completeProfile({
    required String uid,
    required String phone,
    required String businessName,
    required String location,
  }) async {
    await _client
        .from('users')
        .update({
          'phone': phone,
          'business_name': businessName,
          'location': location,
          'profile_complete': true,
        })
        .eq('id', uid);
  }

  Future<void> signOut() => _client.auth.signOut();
}
