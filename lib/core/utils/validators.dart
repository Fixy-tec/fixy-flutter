/// Validadores compartidos. La validacion final tambien existe en Postgres
/// (constraint email_tecsup en profiles).
library;

final _tecsupEmail = RegExp(r'^[a-zA-Z0-9._%+-]+@tecsup\.edu\.pe$');

String? validateTecsupEmail(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Ingresa tu correo institucional';
  }
  if (!_tecsupEmail.hasMatch(value.trim())) {
    return 'Debe ser un correo @tecsup.edu.pe';
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) return 'Ingresa una contrasena';
  if (value.length < 8) return 'Minimo 8 caracteres';
  return null;
}

String? validateRequired(String? value, {String fieldName = 'Este campo'}) {
  if (value == null || value.trim().isEmpty) return '$fieldName es obligatorio';
  return null;
}
