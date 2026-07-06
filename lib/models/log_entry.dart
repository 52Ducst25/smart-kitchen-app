enum LogLevel { danger, info }

/// Một dòng nhật ký từ node `kitchen/logs`.
class LogEntry {
  const LogEntry({required this.msg, this.level = LogLevel.info, this.time = ''});

  final String msg;
  final LogLevel level;
  final String time;

  bool get isDanger => level == LogLevel.danger;

  factory LogEntry.fromMap(Map<dynamic, dynamic>? map) {
    if (map == null) return const LogEntry(msg: '');
    return LogEntry(
      msg: map['msg']?.toString() ?? '',
      level: map['level']?.toString() == 'danger'
          ? LogLevel.danger
          : LogLevel.info,
      time: (map['time'] ?? map['ts'] ?? '').toString(),
    );
  }

  Map<String, Object> toMap() => {
        'msg': msg,
        'level': level.name,
        'time': time,
      };
}
