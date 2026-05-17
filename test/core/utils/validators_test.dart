import 'package:flutter_test/flutter_test.dart';
import 'package:fixy/core/utils/validators.dart';

void main() {
  group('validateTecsupEmail', () {
    test('acepta correo @tecsup.edu.pe valido', () {
      expect(validateTecsupEmail('estudiante@tecsup.edu.pe'), isNull);
      expect(validateTecsupEmail('a.b.c@tecsup.edu.pe'), isNull);
      expect(validateTecsupEmail('123_456@tecsup.edu.pe'), isNull);
    });

    test('rechaza correos de otros dominios', () {
      expect(
        validateTecsupEmail('alguien@gmail.com'),
        equals('Debe ser un correo @tecsup.edu.pe'),
      );
      expect(
        validateTecsupEmail('test@hotmail.com'),
        equals('Debe ser un correo @tecsup.edu.pe'),
      );
      expect(
        validateTecsupEmail('test@tecsup.com'),
        equals('Debe ser un correo @tecsup.edu.pe'),
      );
    });

    test('rechaza vacios y nulos', () {
      expect(
        validateTecsupEmail(null),
        equals('Ingresa tu correo institucional'),
      );
      expect(
        validateTecsupEmail(''),
        equals('Ingresa tu correo institucional'),
      );
      expect(
        validateTecsupEmail('   '),
        equals('Ingresa tu correo institucional'),
      );
    });

    test('rechaza correos malformados', () {
      expect(validateTecsupEmail('no-es-email'), isNotNull);
      expect(validateTecsupEmail('@tecsup.edu.pe'), isNotNull);
      expect(validateTecsupEmail('test@'), isNotNull);
    });

    test('trim funciona', () {
      expect(validateTecsupEmail('  test@tecsup.edu.pe  '), isNull);
    });
  });

  group('validatePassword', () {
    test('acepta contrasena de 8+ caracteres', () {
      expect(validatePassword('12345678'), isNull);
      expect(validatePassword('passwordlarga'), isNull);
    });

    test('rechaza menos de 8 caracteres', () {
      expect(validatePassword('1234567'), equals('Minimo 8 caracteres'));
      expect(validatePassword('abc'), equals('Minimo 8 caracteres'));
    });

    test('rechaza vacio o null', () {
      expect(validatePassword(''), equals('Ingresa una contrasena'));
      expect(validatePassword(null), equals('Ingresa una contrasena'));
    });
  });

  group('validateRequired', () {
    test('acepta texto con contenido', () {
      expect(validateRequired('hola'), isNull);
      expect(validateRequired('a'), isNull);
    });

    test('rechaza vacios o solo espacios', () {
      expect(validateRequired(''), equals('Este campo es obligatorio'));
      expect(validateRequired(null), equals('Este campo es obligatorio'));
      expect(validateRequired('   '), equals('Este campo es obligatorio'));
    });

    test('respeta fieldName custom', () {
      expect(
        validateRequired('', fieldName: 'Nombre'),
        equals('Nombre es obligatorio'),
      );
    });
  });
}
