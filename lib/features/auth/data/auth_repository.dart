import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/app_user.dart';

/// Datos requeridos para registro segun RF-U01.
class SignUpData {
  const SignUpData({
    required this.email,
    required this.password,
    required this.fullName,
    required this.career,
    required this.cycle,
  });

  final String email;
  final String password;
  final String fullName;
  final String career;
  final int cycle;
}

class AuthRepository {
  AuthRepository(this._client);

  final SupabaseClient _client;

  GoTrueClient get _auth => _client.auth;

  Session? get currentSession => _auth.currentSession;
  User? get currentAuthUser => _auth.currentUser;

  Stream<AuthState> authStateChanges() => _auth.onAuthStateChange;

  Future<void> signIn({required String email, required String password}) async {
    await _auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signUp(SignUpData data) async {
    final response = await _auth.signUp(
      email: data.email,
      password: data.password,
      data: {'full_name': data.fullName},
    );

    final user = response.user;
    if (user == null) {
      throw const AuthException('No se pudo crear el usuario');
    }

    // El trigger handle_new_auth_user creo la fila base en profiles.
    // Completamos los campos de carrera y ciclo.
    await _client.from('profiles').update({
      'career': data.career,
      'cycle': data.cycle,
    }).eq('id', user.id);
  }

  Future<void> signOut() => _auth.signOut();

  Future<AppUser?> fetchCurrentProfile() async {
    final user = currentAuthUser;
    if (user == null) return null;

    final row = await _client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    if (row == null) return null;
    return AppUser.fromJson(row);
  }
}
