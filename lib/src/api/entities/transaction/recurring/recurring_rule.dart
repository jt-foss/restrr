import 'package:restrr/src/api/entities/transaction/recurring/cron_pattern.dart';

class RecurringRule {
  static const RecurringRule yearly = RecurringRule(special: '@yearly');
  static const RecurringRule annually = RecurringRule(special: '@annually');
  static const RecurringRule monthly = RecurringRule(special: '@monthly');
  static const RecurringRule weekly = RecurringRule(special: '@weekly');
  static const RecurringRule daily = RecurringRule(special: '@daily');

  final CronPattern? cronPattern;
  final String? special;

  const RecurringRule({this.cronPattern, this.special});

  static RecurringRule fromJson(Map<String, dynamic>? json) {
    if (json == null) throw ArgumentError.notNull('json');
    return RecurringRule(
      cronPattern: CronPattern.fromJson(json['cron_pattern']),
      special: json['special'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (cronPattern != null) 'cron_pattern': cronPattern!.toJson(),
      if (special != null) 'special': special,
    };
  }

  RecurringRule copyWith({
    CronPattern? cronPattern,
    String? special,
  }) {
    return RecurringRule(
      cronPattern: cronPattern ?? this.cronPattern,
      special: special ?? this.special,
    );
  }
}
