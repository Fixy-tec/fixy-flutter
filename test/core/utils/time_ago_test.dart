import 'package:flutter_test/flutter_test.dart';
import 'package:fixy/core/utils/time_ago.dart';

void main() {
  group('timeAgo', () {
    test('hace un momento para diferencias < 1 min', () {
      final t = DateTime.now().subtract(const Duration(seconds: 30));
      expect(timeAgo(t), equals('hace un momento'));
    });

    test('minutos', () {
      final t = DateTime.now().subtract(const Duration(minutes: 5));
      expect(timeAgo(t), equals('hace 5 min'));
    });

    test('1 hora vs N horas', () {
      final t1 = DateTime.now().subtract(const Duration(hours: 1));
      expect(timeAgo(t1), equals('hace 1 hora'));

      final tN = DateTime.now().subtract(const Duration(hours: 5));
      expect(timeAgo(tN), equals('hace 5 horas'));
    });

    test('ayer (1 dia)', () {
      final t = DateTime.now().subtract(const Duration(days: 1));
      expect(timeAgo(t), equals('ayer'));
    });

    test('N dias (2-6)', () {
      final t = DateTime.now().subtract(const Duration(days: 3));
      expect(timeAgo(t), equals('hace 3 dias'));
    });

    test('1 semana vs N semanas', () {
      final t1 = DateTime.now().subtract(const Duration(days: 7));
      expect(timeAgo(t1), equals('hace 1 semana'));

      final t2 = DateTime.now().subtract(const Duration(days: 14));
      expect(timeAgo(t2), equals('hace 2 semanas'));
    });

    test('1 mes vs N meses', () {
      final t1 = DateTime.now().subtract(const Duration(days: 35));
      expect(timeAgo(t1), equals('hace 1 mes'));

      final t3 = DateTime.now().subtract(const Duration(days: 95));
      expect(timeAgo(t3), equals('hace 3 meses'));
    });

    test('1 anio vs N anios', () {
      final t1 = DateTime.now().subtract(const Duration(days: 400));
      expect(timeAgo(t1), equals('hace 1 ano'));

      final t2 = DateTime.now().subtract(const Duration(days: 800));
      expect(timeAgo(t2), equals('hace 2 anos'));
    });
  });
}
