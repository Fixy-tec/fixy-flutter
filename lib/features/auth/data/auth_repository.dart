import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/app_user.dart';

/// Datos del registro (4 pasos). career/cycle/avatar/tags/etc son opcionales
/// porque el usuario puede skip varios pasos.
class SignUpData {
  const SignUpData({
    required this.email,
    required this.password,
    this.fullName,
    this.career,
    this.cycle,
    this.avatarSlug,
    this.whatsappNumber,
    this.bio,
    this.githubUrl,
    this.linkedinUrl,
    this.portfolioUrl,
    this.tagIds = const [],
  });

  final String email;
  final String password;
  final String? fullName;
  final String? career;
  final int? cycle;
  final String? avatarSlug;
  final String? whatsappNumber;
  final String? bio;
  final String? githubUrl;
  final String? linkedinUrl;
  final String? portfolioUrl;
  final List<String> tagIds;
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
      data: {if (data.fullName != null) 'full_name': data.fullName},
    );

    final user = response.user;
    if (user == null) {
      throw const AuthException('No se pudo crear el usuario');
    }

    // El trigger handle_new_auth_user creo la fila base en profiles.
    // Completamos los datos opcionales del onboarding.
    final updates = <String, dynamic>{
      if (data.career != null) 'career': data.career,
      if (data.cycle != null) 'cycle': data.cycle,
      if (data.avatarSlug != null) 'avatar_slug': data.avatarSlug,
      if (data.whatsappNumber != null) 'whatsapp_number': data.whatsappNumber,
      if (data.bio != null) 'bio': data.bio,
      if (data.portfolioUrl != null) 'portfolio_url': data.portfolioUrl,
      if (data.linkedinUrl != null) 'linkedin_url': data.linkedinUrl,
      if (data.githubUrl != null) 'github_url': data.githubUrl,
    };
    if (updates.isNotEmpty) {
      await _client.from('profiles').update(updates).eq('id', user.id);
    }

    // Tags seleccionados
    if (data.tagIds.isNotEmpty) {
      await _client.from('user_tags').insert(
            data.tagIds
                .map((tagId) => {'user_id': user.id, 'tag_id': tagId})
                .toList(),
          );
    }
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
