import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student/models/attendance_model.dart';
import 'package:uuid/uuid.dart';

class AttendanceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'attendance';

  // Mark attendance for a student
  Future<void> markAttendance({
    required String studentId,
    required String courseId,
    required bool isPresent,
    required String markedBy,
  }) async {
    try {
      final attendanceId = const Uuid().v4();
      final attendance = AttendanceRecord(
        id: attendanceId,
        studentId: studentId,
        courseId: courseId,
        date: DateTime.now(),
        isPresent: isPresent,
        markedBy: markedBy,
        markedAt: DateTime.now(),
      );

      await _firestore
          .collection(_collection)
          .doc(attendanceId)
          .set(attendance.toJson());
    } catch (e) {
      throw 'Failed to mark attendance: $e';
    }
  }

  // Get attendance for a student in a course
  Stream<List<AttendanceRecord>> getStudentAttendance({
    required String studentId,
    required String courseId,
  }) {
    return _firestore
        .collection(_collection)
        .where('studentId', isEqualTo: studentId)
        .where('courseId', isEqualTo: courseId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AttendanceRecord.fromJson(doc.data()))
            .toList());
  }

  // Get attendance for a course on a specific date
  Future<List<AttendanceRecord>> getCourseAttendanceForDate({
    required String courseId,
    required DateTime date,
  }) async {
    try {
      // Get the start and end of the day
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final snapshot = await _firestore
          .collection(_collection)
          .where('courseId', isEqualTo: courseId)
          .where('date', isGreaterThanOrEqualTo: startOfDay)
          .where('date', isLessThan: endOfDay)
          .get();

      return snapshot.docs
          .map((doc) => AttendanceRecord.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw 'Failed to get course attendance: $e';
    }
  }

  // Get attendance summary for a student in a course
  Future<Map<String, dynamic>> getAttendanceSummary({
    required String studentId,
    required String courseId,
  }) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('studentId', isEqualTo: studentId)
          .where('courseId', isEqualTo: courseId)
          .get();

      final records = snapshot.docs
          .map((doc) => AttendanceRecord.fromJson(doc.data()))
          .toList();

      final totalClasses = records.length;
      final presentCount =
          records.where((record) => record.isPresent).length;
      final attendancePercentage = totalClasses > 0
          ? (presentCount / totalClasses * 100).round()
          : 0;

      return {
        'totalClasses': totalClasses,
        'present': presentCount,
        'absent': totalClasses - presentCount,
        'percentage': attendancePercentage,
      };
    } catch (e) {
      throw 'Failed to get attendance summary: $e';
    }
  }
}
