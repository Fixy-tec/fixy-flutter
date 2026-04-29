import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Inicializa Supabase usando las variables de .env.
/// Llamar desde main() antes de runApp().
Future<void> initSupabase() async {
  await dotenv.load();

  final url = dotenv.env['SUPABASE_URL'];
  final anonKey = dotenv.env['SUPABASE_ANON_KEY'];

  if (url == null || anonKey == null || url.contains('YOUR_PROJECT_ID')) {
    throw StateError(
      'Falta configurar .env con SUPABASE_URL y SUPABASE_ANON_KEY. '
      'Copia .env.example a .env y reemplaza los valores.',
    );
  }

  await Supabase.initialize(
    url: url,
    anonKey: anonKey,
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
  );
}

/// Atajo para acceder al cliente Supabase desde cualquier lugar.
SupabaseClient get supabase => Supabase.instance.client;
