import 'dart:async';
import 'package:test/test.dart';
import 'package:google_maps_webservice/src/utils.dart';

Future<void> main() async {
  group('Google Maps Utils', () {
    group('dayTimeToDateTime', () {
      test('basic', () {
        final sundayAt1130 = dayTimeToDateTime(0, '2330');

        expect(sundayAt1130.weekday, equals(DateTime.sunday));
        expect(sundayAt1130.hour, equals(23));
        expect(sundayAt1130.minute, equals(30));

        final mondayAt1130 = dayTimeToDateTime(1, '2330');

        expect(mondayAt1130.weekday, equals(DateTime.monday));
        expect(mondayAt1130.hour, equals(23));
        expect(mondayAt1130.minute, equals(30));

        final saturdayAt1130 = dayTimeToDateTime(6, '2330');

        expect(saturdayAt1130.weekday, equals(DateTime.saturday));
        expect(saturdayAt1130.hour, equals(23));
        expect(saturdayAt1130.minute, equals(30));
      });

      test('throws for an invalid time argument', () {
        expect(() => dayTimeToDateTime(0, '230'), throwsArgumentError);
      });
    });
  });
}
