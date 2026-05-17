import 'package:flutter_test/flutter_test.dart';
import 'package:fixy/core/update/update_info.dart';

void main() {
  group('UpdateInfo.isNewerVersion', () {
    test('detecta version mas nueva (patch)', () {
      expect(UpdateInfo.isNewerVersion('1.0.0', '1.0.1'), isTrue);
      expect(UpdateInfo.isNewerVersion('1.0.5', '1.0.10'), isTrue);
    });

    test('detecta version mas nueva (minor)', () {
      expect(UpdateInfo.isNewerVersion('1.0.0', '1.1.0'), isTrue);
      expect(UpdateInfo.isNewerVersion('1.9.9', '1.10.0'), isTrue);
    });

    test('detecta version mas nueva (major)', () {
      expect(UpdateInfo.isNewerVersion('1.9.9', '2.0.0'), isTrue);
    });

    test('retorna false si la version actual es mas reciente', () {
      expect(UpdateInfo.isNewerVersion('1.1.0', '1.0.9'), isFalse);
      expect(UpdateInfo.isNewerVersion('2.0.0', '1.9.9'), isFalse);
    });

    test('retorna false si son iguales', () {
      expect(UpdateInfo.isNewerVersion('1.0.0', '1.0.0'), isFalse);
      expect(UpdateInfo.isNewerVersion('1.1.4', '1.1.4'), isFalse);
    });

    test('maneja prefijo "v" en el tag', () {
      expect(UpdateInfo.isNewerVersion('1.0.0', 'v1.0.1'), isTrue);
      expect(UpdateInfo.isNewerVersion('v1.0.0', '1.0.1'), isTrue);
      expect(UpdateInfo.isNewerVersion('v1.0.0', 'v1.0.0'), isFalse);
    });

    test('ignora build number (+N)', () {
      expect(UpdateInfo.isNewerVersion('1.0.0+5', '1.0.0'), isFalse);
      expect(UpdateInfo.isNewerVersion('1.0.0+5', '1.0.1+1'), isTrue);
    });

    test('ignora sufijos pre-release (-beta, -rc)', () {
      expect(UpdateInfo.isNewerVersion('1.0.0-beta', '1.0.0-rc'), isFalse);
      expect(UpdateInfo.isNewerVersion('1.0.0', '1.0.1-beta'), isTrue);
    });

    test('versiones con distinta longitud', () {
      // 1.0 se considera 1.0.0
      expect(UpdateInfo.isNewerVersion('1.0', '1.0.0'), isFalse);
      expect(UpdateInfo.isNewerVersion('1.0', '1.0.1'), isTrue);
      expect(UpdateInfo.isNewerVersion('1.0.0.5', '1.0.0'), isFalse);
    });
  });
}
