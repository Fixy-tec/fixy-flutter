import 'package:supabase_flutter/supabase_flutter.dart';

/// Traduce errores de Supabase a mensajes en espanol.
String authErrorMessage(Object error) {
  if (error is AuthException) {
    final msg = error.message.toLowerCase();
    if (msg.contains('invalid login') || msg.contains('invalid credentials')) {
      return 'Correo o contrasena incorrectos';
    }
    if (msg.contains('already registered') || msg.contains('already been registered')) {
      return 'Este correo ya esta registrado';
    }
    if (msg.contains('email not confirmed')) {
      return 'Confirma tu correo antes de iniciar sesion';
    }
    if (msg.contains('weak password') || msg.contains('password should be')) {
      return 'La contrasena es muy debil';
    }
    return error.message;
  }
  if (error is PostgrestException) {
    final msg = error.message.toLowerCase();
    if (msg.contains('email_tecsup')) {
      return 'Debe usar un correo @tecsup.edu.pe';
    }
    return error.message;
  }
  return 'Ocurrio un error inesperado';
}
