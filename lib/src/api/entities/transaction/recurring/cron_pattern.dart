class CronPattern {
  final String? second;
  final String? minute;
  final String? hour;
  final String? dayOfMonth;
  final String? month;
  final String? dayOfWeek;

  const CronPattern({
    required this.second,
    required this.minute,
    required this.hour,
    required this.dayOfMonth,
    required this.month,
    required this.dayOfWeek,
  });

  static CronPattern fromJson(Map<String, dynamic> json) {
    return CronPattern(
      second: json['second'],
      minute: json['minute'],
      hour: json['hour'],
      dayOfMonth: json['day_of_month'],
      month: json['month'],
      dayOfWeek: json['day_of_week'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (second != null) 'second': second,
      if (minute != null) 'minute': minute,
      if (hour != null) 'hour': hour,
      if (dayOfMonth != null) 'day_of_month': dayOfMonth,
      if (month != null) 'month': month,
      if (dayOfWeek != null) 'day_of_week': dayOfWeek,
    };
  }

  CronPattern copyWith({
    String? second,
    String? minute,
    String? hour,
    String? dayOfMonth,
    String? month,
    String? dayOfWeek,
  }) {
    return CronPattern(
      second: second ?? this.second,
      minute: minute ?? this.minute,
      hour: hour ?? this.hour,
      dayOfMonth: dayOfMonth ?? this.dayOfMonth,
      month: month ?? this.month,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
    );
  }
}
