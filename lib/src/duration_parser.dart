/// Parse duration from string in ISO-8601 format.
///
/// Durations define the amount of intervening time in a time interval and
/// are represented by the format P[n]Y[n]M[n]DT[n]H[n]M[n]S or
/// P[n]W as shown on the aside.
///
/// In these representations, the [n] is replaced by the value
/// for each of the date and time elements that follow the [n].
///
/// Leading zeros are not required,
/// but the maximum number of digits for each element should be
/// agreed to by the communicating parties.
class DurationParser {
  const DurationParser();

  Duration parse(String value) {
    final len = value.length;
    if (len < 2 || value[0] != 'P') _failed(value, 0);

    const digits = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9'};

    var days = 0;
    var seconds = 0;

    var designators = _Designator.period.toList();
    final buffer = StringBuffer();
    for (var i = 1; i < len; i++) {
      // TODO: support for negative values
      // TODO: support for decimal fraction
      final char = value[i];
      if (digits.contains(char)) {
        buffer.write(char);
      } else {
        if (buffer.isEmpty) {
          if (char == 'T') {
            designators = _Designator.time.toList();
          } else {
            _failed(value, i);
          }
        } else {
          final num = int.parse(buffer.toString());

          designators = designators.skipWhile((e) => e.symbol != char).toList();
          if (designators.isEmpty) _failed(value, i);

          final designator = designators.removeAt(0);
          days += designator.days * num;
          seconds += designator.seconds * num;

          buffer.clear();
        }
      }
    }

    return Duration(
      days: days,
      seconds: seconds,
    );
  }

  void _failed(String value, int index) => throw ArgumentError.value(
      value, 'value', 'String is not in ISO-8601 format. Problem at $index');
}

/// Designators.
///
/// P is the duration designator (for period) placed
/// at the start of the duration representation.
///  - Y is the year designator that follows the value for the number of years.
///  - M is the month designator that follows the value for the number of months.
///  - W is the week designator that follows the value for the number of weeks.
///  - D is the day designator that follows the value for the number of days.
/// T is the time designator that precedes
/// the time components of the representation.
///  - H is the hour designator that follows the value for the number of hours.
///  - M is the minute designator that follows the value for the number of minutes.
///  - S is the second designator that follows the value for the number of seconds.
class _Designator {
  static const period = [
    _Designator.year(),
    _Designator.month(),
    _Designator.week(),
    _Designator.day(),
  ];

  static const time = [
    _Designator.hour(),
    _Designator.minute(),
    _Designator.second(),
  ];

  final String symbol;
  final int days;
  final int seconds;

  // TODO: is that right? Or consider current date?
  const _Designator.year() : this._('Y', days: 365);
  // TODO: is that right? Or consider current date?
  const _Designator.month() : this._('M', days: 30);
  const _Designator.week() : this._('W', days: 7);
  // TODO: is that right? Or consider current date/timezone with Daylight saving time?
  const _Designator.day() : this._('D', days: 1);

  const _Designator.hour() : this._('H', seconds: 60 * 60);
  const _Designator.minute() : this._('M', seconds: 60);
  const _Designator.second() : this._('S', seconds: 1);

  const _Designator._(this.symbol, {this.days = 0, this.seconds = 0});

  @override
  String toString() => symbol;
}
