# duration_iso_parser


[![pub package](https://img.shields.io/pub/v/duration_iso_parser)](https://pub.dartlang.org/packages/duration_iso_parser)
[![Analyze & Test](https://github.com/Innim/dart_duration_iso_parser/actions/workflows/dart.yml/badge.svg?branch=main)](https://github.com/Innim/dart_duration_iso_parser/actions/workflows/dart.yml)
[![innim lint](https://img.shields.io/badge/style-innim_lint-40c4ff.svg)](https://pub.dev/packages/innim_lint)

Package for parsing [ISO 8601](https://en.wikipedia.org/wiki/ISO_8601) durations string 
to the [`Duration`](https://api.dart.dev/stable/2.15.1/dart-core/Duration-class.html) object.

For now it's not support negative values and decimal fraction.

## Features

Parse string of duration in ISO 8601 format and get `Duration` object.

For year used 365 days and for month - 30 days.

## Getting started

Add `duration_iso_parser` as a [dependency in your pubspec.yaml file](https://flutter.dev/platform-plugins/).

## Usage


```dart
const parser = DurationParser();

final duration = parser.parse('P2W');
print(duration); // 336:00:00.000000
```
