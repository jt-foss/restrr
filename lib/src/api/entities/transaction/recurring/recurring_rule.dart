import 'package:restrr/src/api/entities/transaction/recurring/cron_pattern.dart';

class RecurringRule {
  final CronPattern cronPattern;
  final String? special;

  const RecurringRule({
    required this.cronPattern,
    required this.special,
  });

  static RecurringRule fromJson(Map<String, dynamic> json) {
    return RecurringRule(
      cronPattern: CronPattern.fromJson(json['cron_pattern']),
      special: json['special'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cron_pattern': cronPattern.toJson(),
      'special': special,
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
