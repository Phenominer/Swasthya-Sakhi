import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student/models/course_model.dart';

class CourseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'courses';

  // Get all courses
  Stream<List<Course>> getCourses() {
    return _firestore
        .collection(_collection)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Course.fromJson(doc.data()))
            .toList());
  }

  // Get courses for a specific faculty
  Stream<List<Course>> getFacultyCourses(String facultyId) {
    return _firestore
        .collection(_collection)
        .where('facultyId', isEqualTo: facultyId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Course.fromJson(doc.data()))
            .toList());
  }

  // Get courses for a specific student
  Stream<List<Course>> getStudentCourses(List<String> courseIds) {
    if (courseIds.isEmpty) {
      return Stream.value([]);
    }
    
    return _firestore
        .collection(_collection)
        .where(FieldPath.documentId, whereIn: courseIds)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Course.fromJson(doc.data()))
            .toList());
  }

  // Get a single course by ID
  Future<Course?> getCourse(String courseId) async {
    try {
      final doc = await _firestore.collection(_collection).doc(courseId).get();
      if (doc.exists) {
        return Course.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      throw 'Failed to get course: $e';
    }
  }

  // Create a new course
  Future<void> createCourse(Course course) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(course.id)
          .set(course.toJson());
    } catch (e) {
      throw 'Failed to create course: $e';
    }
  }

  // Update a course
  Future<void> updateCourse(Course course) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(course.id)
          .update(course.toJson());
    } catch (e) {
      throw 'Failed to update course: $e';
    }
  }

  // Delete a course
  Future<void> deleteCourse(String courseId) async {
    try {
      await _firestore.collection(_collection).doc(courseId).delete();
    } catch (e) {
      throw 'Failed to delete course: $e';
    }
  }

  // Enroll a student in a course
  Future<void> enrollStudent(String courseId, String studentId) async {
    try {
      await _firestore.collection(_collection).doc(courseId).update({
        'studentIds': FieldValue.arrayUnion([studentId]),
      });
    } catch (e) {
      throw 'Failed to enroll student: $e';
    }
  }

  // Remove a student from a course
  Future<void> unenrollStudent(String courseId, String studentId) async {
    try {
      await _firestore.collection(_collection).doc(courseId).update({
        'studentIds': FieldValue.arrayRemove([studentId]),
      });
    } catch (e) {
      throw 'Failed to unenroll student: $e';
    }
  }
}
