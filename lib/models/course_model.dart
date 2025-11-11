class Course {
  final String id;
  final String code;
  final String name;
  final String description;
  final String department;
  final String facultyId; // ID of the faculty member teaching the course
  final List<String> studentIds; // List of enrolled student IDs
  final String schedule; // e.g., "Mon, Wed, Fri 10:00 AM - 11:00 AM"
  final int creditHours;

  Course({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    required this.department,
    required this.facultyId,
    required this.studentIds,
    required this.schedule,
    required this.creditHours,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'description': description,
      'department': department,
      'facultyId': facultyId,
      'studentIds': studentIds,
      'schedule': schedule,
      'creditHours': creditHours,
    };
  }

  // Create from JSON
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] ?? '',
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      department: json['department'] ?? '',
      facultyId: json['facultyId'] ?? '',
      studentIds: json['studentIds'] != null ? List<String>.from(json['studentIds']) : [],
      schedule: json['schedule'] ?? 'Not scheduled',
      creditHours: json['creditHours'] ?? 3,
    );
  }

  // Get course title with code (e.g., "CSC101 - Introduction to Computer Science")
  String get titleWithCode => '$code - $name';
}
