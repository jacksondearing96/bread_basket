import 'package:bread_basket/models/cardioSession.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Cardio Session Tests', () {
    late CardioSession session;
    const Duration testDuration = Duration(minutes: 1);
    const double testDistanceInMetres = 100;

    setUp(() {
      session = CardioSession(
          duration: testDuration, distanceInMetres: testDistanceInMetres);
    });

    test('Initialisation', () {
      CardioSession initialisedSesssion = CardioSession();
      expect(initialisedSesssion.duration, Duration());
      expect(initialisedSesssion.distanceInMetres, 0);
      expect(initialisedSesssion.timestamp, TypeMatcher<int>());
      expect(initialisedSesssion.id, TypeMatcher<String>());
    });

    test('Get duration string', () {
      expect(session.getDurationString(), '00:01:00');
    });

    test('Volume', () {
      expect(session.volume(), 100);
    });

    test('ToJson', () {
      Map<String, Object?> json = session.toJson();
      expect(json['durationInSeconds'], 60);
      expect(json['distanceInMetres'], 100);
      expect(json['timestamp'], TypeMatcher<int>());
      expect(json['id'], TypeMatcher<String>());
      expect(json.keys.length, 4);
    });

    test('FromJson', () {
      Map<String, Object?> json = session.toJson();
      CardioSession fromJson = CardioSession.fromJson(json);
      expect(fromJson.equals(session), isTrue);
    });
  });
}
