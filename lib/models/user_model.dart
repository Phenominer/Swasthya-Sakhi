class UserModel {
  final String id;
  final String email;
  final String name;
  final String role; // 'student', 'faculty', or 'admin'
  final String? studentId; // Only for students
  final String? department; // For students and faculty
  final List<String>? courses; // For students and faculty

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.studentId,
    this.department,
    this.courses,
  });

  // Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role,
      'studentId': studentId,
      'department': department,
      'courses': courses,
    };
  }

  // Create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? 'student', // Default to student if not specified
      studentId: json['studentId'],
      department: json['department'],
      courses: json['courses'] != null ? List<String>.from(json['courses']) : null,
    );
  }
}
