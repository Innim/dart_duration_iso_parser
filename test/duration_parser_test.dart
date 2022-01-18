import 'package:duration_iso_parser/duration_iso_parser.dart';
import 'package:test/test.dart';

void main() {
  group('DurationParser', () {
    [
      _Data('P1Y', const Duration(days: 365)),
      _Data('P1M', const Duration(days: 30)),
      _Data('P03W', const Duration(days: 21)),
      _Data('PT1M', const Duration(minutes: 1)),
      _Data('PT15M', const Duration(minutes: 15)),
      _Data('PT10H', const Duration(hours: 10)),
      _Data('P2D', const Duration(days: 2)),
      _Data('P2DT3H4M', const Duration(days: 2, hours: 3, minutes: 4)),
      _Data('P23DT22H', const Duration(days: 23, hours: 22)),
      _Data('P4Y', const Duration(days: 1460)),
      _Data('PT0S', Duration.zero),
      _Data('P0D', Duration.zero),
      _Data(
        'P3Y6M4DT12H30M5S',
        const Duration(
          days: 3 * 365 + 6 * 30 + 4,
          hours: 12,
          minutes: 30,
          seconds: 5,
        ),
      ),
      // TODO: The smallest value used may also have a decimal fraction,
      // as in "P0.5Y" to indicate half a year.
      // This decimal fraction may be specified with either a comma or a full stop,
      // as in "P0,5Y" or "P0.5Y". The standard does not prohibit date and
      // time values in a duration representation from exceeding their
      // "carry over points" except as noted below.
      // Thus, "PT36H" could be used as well as "P1DT12H" for representing
      // the same duration. But keep in mind that "PT36H" is not the same as
      // "P1DT12H" when switching from or to Daylight saving time.
      // "P0.5Y"     -- parses as "???"
      // "P0,5Y"     -- parses as "???"
      // "PT20.345S" -- parses as "20.345 seconds"
      // "P-6H3M"    -- parses as "-6 hours and +3 minutes"
      // "-P6H3M"    -- parses as "-6 hours and -3 minutes"
      // "-P-6H+3M"  -- parses as "+6 hours and -3 minutes"
    ].forEach((data) {
      test('should parse ${data.input}', () {
        final str = data.input;
        const parser = DurationParser();

        final res = parser.parse(str);

        expect(res, data.expected);
      });
    });

    [
      'P',
      'T10H',
      '23DT22H',
      'P10H',
      'P23D1Y',
    ].forEach((str) {
      test('should throw exception when trying to parse $str', () {
        const parser = DurationParser();

        expect(() => parser.parse(str), throwsA(isArgumentError));
      });
    });
  });
}

class _Data {
  final String input;
  final Duration expected;

  _Data(this.input, this.expected);
}
