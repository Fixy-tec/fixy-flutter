import 'package:flutter_test/flutter_test.dart';
import 'package:fixy/core/constants/reputation.dart';

void main() {
  group('medalFromPoints', () {
    test('Hierro para 0-299 pts', () {
      expect(medalFromPoints(0), equals(Medal.hierro));
      expect(medalFromPoints(150), equals(Medal.hierro));
      expect(medalFromPoints(299), equals(Medal.hierro));
    });

    test('Bronce para 300-799 pts', () {
      expect(medalFromPoints(300), equals(Medal.bronce));
      expect(medalFromPoints(500), equals(Medal.bronce));
      expect(medalFromPoints(799), equals(Medal.bronce));
    });

    test('Plata para 800-1799 pts', () {
      expect(medalFromPoints(800), equals(Medal.plata));
      expect(medalFromPoints(1200), equals(Medal.plata));
      expect(medalFromPoints(1799), equals(Medal.plata));
    });

    test('Oro para 1800-3499 pts', () {
      expect(medalFromPoints(1800), equals(Medal.oro));
      expect(medalFromPoints(2500), equals(Medal.oro));
      expect(medalFromPoints(3499), equals(Medal.oro));
    });

    test('Diamante para 3500-5999 pts', () {
      expect(medalFromPoints(3500), equals(Medal.diamante));
      expect(medalFromPoints(5000), equals(Medal.diamante));
      expect(medalFromPoints(5999), equals(Medal.diamante));
    });

    test('Maestro para 6000-9999 pts', () {
      expect(medalFromPoints(6000), equals(Medal.maestro));
      expect(medalFromPoints(8500), equals(Medal.maestro));
      expect(medalFromPoints(9999), equals(Medal.maestro));
    });

    test('Challenger para 10000+ pts', () {
      expect(medalFromPoints(10000), equals(Medal.challenger));
      expect(medalFromPoints(50000), equals(Medal.challenger));
      expect(medalFromPoints(1000000), equals(Medal.challenger));
    });

    test('Hierro para valores negativos (clamp logico)', () {
      // Aunque points nunca debe ser negativo, el calculo greatest(0,...)
      // en SQL lo previene; aqui aceptamos hierro como fallback seguro.
      expect(medalFromPoints(-100), equals(Medal.hierro));
    });
  });

  group('basePointsByLevel', () {
    test('valores exactos por nivel', () {
      expect(basePointsByLevel[1], equals(50));
      expect(basePointsByLevel[2], equals(100));
      expect(basePointsByLevel[3], equals(180));
      expect(basePointsByLevel[4], equals(280));
      expect(basePointsByLevel[5], equals(400));
    });

    test('niveles invalidos retornan null', () {
      expect(basePointsByLevel[0], isNull);
      expect(basePointsByLevel[6], isNull);
      expect(basePointsByLevel[-1], isNull);
    });
  });

  group('medalLadder', () {
    test('contiene las 7 medallas en orden ascendente', () {
      expect(medalLadder.length, equals(7));
      expect(medalLadder.first.medal, equals(Medal.hierro));
      expect(medalLadder.last.medal, equals(Medal.challenger));
    });

    test('los rangos no se solapan y son contiguos', () {
      for (var i = 0; i < medalLadder.length - 1; i++) {
        final current = medalLadder[i];
        final next = medalLadder[i + 1];
        expect(
          current.maxPoints! + 1,
          equals(next.minPoints),
          reason:
              '${current.medal.name} debe terminar 1 pt antes de ${next.medal.name}',
        );
      }
    });

    test('challenger no tiene maxPoints (infinito)', () {
      expect(medalLadder.last.maxPoints, isNull);
    });
  });
}
