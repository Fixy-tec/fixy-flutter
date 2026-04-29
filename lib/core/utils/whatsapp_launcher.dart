import 'package:url_launcher/url_launcher.dart';

/// Abre WhatsApp con el numero dado. Asume formato peruano sin codigo pais
/// (9 digitos) o con +51. Si tiene espacios o guiones, los limpia.
Future<bool> openWhatsApp(String rawNumber, {String? message}) async {
  final cleaned = rawNumber.replaceAll(RegExp(r'[\s\-+()]'), '');
  // Si son 9 digitos asume Peru y antepone 51
  final number = cleaned.length == 9 ? '51$cleaned' : cleaned;

  final uri = Uri.parse(
    'https://wa.me/$number${message != null ? '?text=${Uri.encodeComponent(message)}' : ''}',
  );

  return launchUrl(uri, mode: LaunchMode.externalApplication);
}
