import 'package:flutter/foundation.dart';

class Student {
  Student({
    required this.id,
    required this.name,
    required this.className,
    required this.parentCode,
    this.status = 'Active',
    this.fees = 'Pending',
  });

  final String id;
  final String name;
  final String className;
  String parentCode;
  String status;
  String fees;
}

class Teacher {
  Teacher({
    required this.name,
    required this.role,
    required this.email,
    this.status = 'Present',
  });

  final String name;
  final String role;
  final String email;
  String status;
}

class SubjectAssignment {
  SubjectAssignment({
    required this.className,
    required this.subject,
    required this.studentCount,
  });

  final String className;
  final String subject;
  final int studentCount;
}

class SubjectResult {
  SubjectResult({
    required this.studentId,
    required this.studentName,
    required this.className,
    required this.subject,
    required this.ca1,
    required this.ca2,
    required this.exam,
    required this.postedBy,
    required this.postedAt,
  });

  final String studentId;
  final String studentName;
  final String className;
  final String subject;
  int ca1;
  int ca2;
  int exam;
  String postedBy;
  DateTime postedAt;

  int get total => ca1 + ca2 + exam;
  String get grade {
    final score = total;
    if (score >= 70) return 'A';
    if (score >= 60) return 'B';
    if (score >= 50) return 'C';
    if (score >= 45) return 'D';
    return 'F';
  }
}

class PortalRepository extends ChangeNotifier {
  PortalRepository._internal();

  static final PortalRepository instance = PortalRepository._internal();

  final List<Student> students = [
    Student(
      id: 'LAVA-9842',
      name: 'Adebayo Samuel',
      className: 'Primary 4A',
      parentCode: 'PAR-9842',
      status: 'Present',
      fees: 'Paid',
    ),
    Student(
      id: 'LAVA-9843',
      name: 'Chinedu Okeke',
      className: 'Primary 4A',
      parentCode: 'PAR-9843',
      status: 'Present',
      fees: 'Pending',
    ),
    Student(
      id: 'LAVA-9844',
      name: 'Fatima Bello',
      className: 'Primary 5B',
      parentCode: 'PAR-9844',
      status: 'Present',
      fees: 'Paid',
    ),
    Student(
      id: 'LAVA-9845',
      name: 'Grace Danjuma',
      className: 'JSS 1 Green',
      parentCode: 'PAR-9845',
      status: 'Present',
      fees: 'Partial',
    ),
  ];

  final List<Teacher> teachers = [
    Teacher(
      name: 'Mr. John Doe',
      role: 'Class Teacher (Primary 4A)',
      email: 'john@school.com',
      status: 'Present',
    ),
    Teacher(
      name: 'Mrs. Sarah Smith',
      role: 'Subject Teacher (Mathematics)',
      email: 'sarah@school.com',
      status: 'Present',
    ),
    Teacher(
      name: 'Mr. Emmanuel Vance',
      role: 'HOD Science Department',
      email: 'emmanuel@school.com',
      status: 'On Leave',
    ),
  ];

  final List<SubjectAssignment> classAssignments = [
    SubjectAssignment(className: 'Primary 4A', subject: 'Mathematics', studentCount: 32),
    SubjectAssignment(className: 'Primary 5B', subject: 'Mathematics', studentCount: 28),
    SubjectAssignment(className: 'JSS 1A', subject: 'Mathematics', studentCount: 35),
    SubjectAssignment(className: 'JSS 2C', subject: 'Mathematics', studentCount: 30),
  ];

  final List<SubjectResult> results = [
    SubjectResult(
      studentId: 'LAVA-9842',
      studentName: 'Adebayo Samuel',
      className: 'Primary 4A',
      subject: 'Mathematics',
      ca1: 18,
      ca2: 17,
      exam: 50,
      postedBy: 'Mrs. Sarah Smith',
      postedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    SubjectResult(
      studentId: 'LAVA-9843',
      studentName: 'Chinedu Okeke',
      className: 'Primary 4A',
      subject: 'Mathematics',
      ca1: 19,
      ca2: 20,
      exam: 53,
      postedBy: 'Mrs. Sarah Smith',
      postedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  Student? getStudentById(String studentId) {
    for (final student in students) {
      if (student.id == studentId) return student;
    }
    return null;
  }

  Student? getStudentByParentCode(String parentCode) {
    for (final student in students) {
      if (student.parentCode == parentCode) return student;
    }
    return null;
  }

  List<Student> getStudentsForClass(String className) {
    return students.where((student) => student.className == className).toList();
  }

  List<SubjectResult> getResultsForStudent(String studentId) {
    return results.where((result) => result.studentId == studentId).toList();
  }

  List<SubjectResult> getResultsForParent(String parentCode) {
    final student = getStudentByParentCode(parentCode);
    if (student == null) return [];
    return getResultsForStudent(student.id);
  }

  SubjectResult? getLatestResultForStudent(String studentId) {
    final resultsForStudent = getResultsForStudent(studentId);
    if (resultsForStudent.isEmpty) return null;
    resultsForStudent.sort((a, b) => a.postedAt.compareTo(b.postedAt));
    return resultsForStudent.last;
  }

  SubjectResult? getLatestResultForParent(String parentCode) {
    final student = getStudentByParentCode(parentCode);
    if (student == null) return null;
    return getLatestResultForStudent(student.id);
  }

  List<SubjectResult> getResultsForClass(String className, String subject) {
    return results.where((result) => result.className == className && result.subject == subject).toList();
  }

  bool hasResultsForClass(String className, String subject) {
    return getResultsForClass(className, subject).isNotEmpty;
  }

  void addStudent(String name, String className) {
    final index = students.length + 9842;
    students.add(Student(
      id: 'LAVA-$index',
      name: name,
      className: className,
      parentCode: 'PAR-$index',
      status: 'Active',
      fees: 'Pending',
    ));
    notifyListeners();
  }

  void addTeacher(String name, String role, String email) {
    teachers.add(Teacher(name: name, role: role, email: email, status: 'Present'));
    notifyListeners();
  }

  void postSubjectResults(
    String studentId,
    String className,
    String subject,
    int ca1,
    int ca2,
    int exam,
    String postedBy,
  ) {
    final student = getStudentById(studentId);
    if (student == null) return;

    final existing = results.indexWhere((result) =>
        result.studentId == studentId && result.className == className && result.subject == subject);

    if (existing >= 0) {
      final previous = results[existing];
      previous.ca1 = ca1;
      previous.ca2 = ca2;
      previous.exam = exam;
      previous.postedBy = postedBy;
      previous.postedAt = DateTime.now();
    } else {
      results.add(SubjectResult(
        studentId: studentId,
        studentName: student.name,
        className: className,
        subject: subject,
        ca1: ca1,
        ca2: ca2,
        exam: exam,
        postedBy: postedBy,
        postedAt: DateTime.now(),
      ));
    }

    notifyListeners();
  }

  void updateAttendance(String studentId, String status) {
    final student = getStudentById(studentId);
    if (student == null) return;
    student.status = status;
    notifyListeners();
  }
}
