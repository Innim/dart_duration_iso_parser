// ignore_for_file: avoid_print
import 'package:duration_iso_parser/duration_iso_parser.dart';

void main() {
  const parser = DurationParser();

  print(parser.parse('P2W')); // 336:00:00.000000
  print(parser.parse('P1Y2M4D')); // 10296:00:00.000000
  print(parser.parse('P2DT11H')); // 59:00:00.000000
  print(parser.parse('P1WT10S')); // 168:00:10.000000
  print(parser.parse('PT5M')); // 0:05:00.000000
}
