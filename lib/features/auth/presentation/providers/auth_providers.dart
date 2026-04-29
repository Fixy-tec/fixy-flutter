import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/supabase/supabase_client.dart';
import '../../data/auth_repository.dart';
import '../../domain/app_user.dart';

/// Repositorio de auth, expuesto via DI Riverpod.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(supabase);
});

/// Stream de cambios de sesion (login, logout, token refresh).
/// El router lo escucha para redirigir automaticamente.
final authStateProvider = StreamProvider<AuthState>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.authStateChanges();
});

/// Sesion actual (sincronico). Cambia cuando authStateProvider emite.
final currentSessionProvider = Provider<Session?>((ref) {
  ref.watch(authStateProvider);
  return ref.watch(authRepositoryProvider).currentSession;
});

/// Perfil del usuario autenticado (lectura desde tabla profiles).
final currentUserProvider = FutureProvider<AppUser?>((ref) {
  ref.watch(currentSessionProvider);
  return ref.watch(authRepositoryProvider).fetchCurrentProfile();
});
