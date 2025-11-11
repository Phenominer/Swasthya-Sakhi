import 'package:intl/intl.dart';

class AttendanceRecord {
  final String id;
  final String studentId;
  final String courseId;
  final DateTime date;
  final bool isPresent;
  final String markedBy; // Faculty ID who marked the attendance
  final DateTime markedAt;

  AttendanceRecord({
    required this.id,
    required this.studentId,
    required this.courseId,
    required this.date,
    required this.isPresent,
    required this.markedBy,
    required this.markedAt,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'courseId': courseId,
      'date': date.toIso8601String(),
      'isPresent': isPresent,
      'markedBy': markedBy,
      'markedAt': markedAt.toIso8601String(),
    };
  }

  // Create from JSON
  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['id'] ?? '',
      studentId: json['studentId'] ?? '',
      courseId: json['courseId'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      isPresent: json['isPresent'] ?? false,
      markedBy: json['markedBy'] ?? '',
      markedAt: DateTime.parse(json['markedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  // Format date for display
  String get formattedDate {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  // Format time for display
  String get formattedTime {
    return DateFormat('hh:mm a').format(markedAt);
  }
}
