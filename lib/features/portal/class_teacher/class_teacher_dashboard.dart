import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../data/portal_repository.dart';
import '../portal_shell.dart';

class ClassTeacherDashboard extends StatefulWidget {
  const ClassTeacherDashboard({super.key});

  @override
  State<ClassTeacherDashboard> createState() => _ClassTeacherDashboardState();
}

class _ClassTeacherDashboardState extends State<ClassTeacherDashboard> {
  final PortalRepository _repo = PortalRepository.instance;
  final String _className = 'Primary 4A';
  int _currentNavIndex = 0;
  final List<String> _subjects = ['Mathematics', 'English', 'Basic Science', 'Social Studies'];

  List<Student> get _classStudents => _repo.getStudentsForClass(_className);
  List<SubjectResult> get _classResults => _repo.results.where((result) => result.className == _className).toList();

  @override
  void initState() {
    super.initState();
    _repo.addListener(_refresh);
  }

  @override
  void dispose() {
    _repo.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (!mounted) return;
    setState(() {});
  }

  void _markAllPresent() {
    for (final student in _classStudents) {
      _repo.updateAttendance(student.id, 'Present');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PortalShell(
      roleTitle: 'Class Teacher - Primary 4A',
      selectedIndex: _currentNavIndex,
      onDestinationSelected: (index) => setState(() => _currentNavIndex = index),
      navItems: const [
        NavigationDestination(icon: Icon(Icons.how_to_reg_outlined), label: 'Register'),
        NavigationDestination(icon: Icon(Icons.assessment_outlined), label: 'Broad Sheet'),
        NavigationDestination(icon: Icon(Icons.description_outlined), label: 'Report Cards'),
      ],
      body: _buildCurrentTab(),
    );
  }

  Widget _buildCurrentTab() {
    switch (_currentNavIndex) {
      case 0:
        return _buildRegisterTab();
      case 1:
        return _buildBroadSheetTab();
      case 2:
        return _buildReportCardsTab();
      default:
        return _buildRegisterTab();
    }
  }

  // --- TAB 1: EFFICIENT REGISTER ---
  Widget _buildRegisterTab() {
    int presentCount = _classStudents.where((student) => student.status == 'Present').length;
    int absentCount = _classStudents.length - presentCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Quick Stats & Action Bar
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Daily Attendance Register',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: LavaTheme.textPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  'Class: $_className | Total: ${_classStudents.length} | Present: $presentCount | Absent: $absentCount',
                  style: const TextStyle(color: LavaTheme.textSecondary, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: _markAllPresent,
                  icon: const Icon(Icons.done_all, color: LavaTheme.orangeStart),
                  label: const Text('Mark All Present', style: TextStyle(color: LavaTheme.orangeStart)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: LavaTheme.orangeStart),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Attendance submitted successfully!')),
                    );
                  },
                  icon: const Icon(Icons.cloud_upload_outlined, color: Colors.white),
                  label: const Text('Submit Register', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: LavaTheme.orangeStart,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            )
          ],
        ),
        const SizedBox(height: 20),
        
        // Fast Toggle List
        Expanded(
          child: Card(
            child: ListView.separated(
              itemCount: _classStudents.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final student = _classStudents[index];
                final bool isPresent = student.status == 'Present';

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isPresent ? Colors.green.shade50 : Colors.red.shade50,
                    child: Icon(
                      isPresent ? Icons.check : Icons.close,
                      color: isPresent ? Colors.green : Colors.red,
                    ),
                  ),
                  title: Text(student.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('ID: ${student.id}'),
                  trailing: SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'Present', label: Text('Present')),
                      ButtonSegment(value: 'Absent', label: Text('Absent')),
                      ButtonSegment(value: 'Late', label: Text('Late')),
                    ],
                    selected: {student.status},
                    onSelectionChanged: (Set<String> newSelection) {
                      _repo.updateAttendance(student.id, newSelection.first);
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  // --- TAB 2: BROAD SHEET WITH AUTO-SYNC STATUS ---
  Widget _buildBroadSheetTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Class Broad Sheet',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: LavaTheme.textPrimary),
        ),
        const SizedBox(height: 12),

        // Live Subject Submission Tracker Pills
        Wrap(
          spacing: 12,
          children: _subjects
              .map((subject) => _buildSubjectStatusChip(subject, _repo.hasResultsForClass(_className, subject)))
              .toList(),
        ),
        const SizedBox(height: 20),

        // Auto-Calculated Broad Table
        Expanded(
          child: Card(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Student ID')),
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Maths')),
                    DataColumn(label: Text('Total')),
                    DataColumn(label: Text('Average')),
                    DataColumn(label: Text('Status')),
                  ],
                  rows: _classStudents.map((student) {
                    final mathResult = _classResults.firstWhere(
                      (result) => result.studentId == student.id && result.subject == 'Mathematics',
                      orElse: () => SubjectResult(
                        studentId: student.id,
                        studentName: student.name,
                        className: _className,
                        subject: 'Mathematics',
                        ca1: 0,
                        ca2: 0,
                        exam: 0,
                        postedBy: '',
                        postedAt: DateTime.now(),
                      ),
                    );
                    final total = _repo.getResultsForStudent(student.id).fold<int>(0, (sum, result) => sum + result.total);
                    final average = _repo.getResultsForStudent(student.id).isEmpty ? 0 : total / _repo.getResultsForStudent(student.id).length;
                    final passed = average >= 50;

                    return DataRow(cells: [
                      DataCell(Text(student.id)),
                      DataCell(Text(student.name, style: const TextStyle(fontWeight: FontWeight.bold))),
                      DataCell(Text('${mathResult.total}')),
                      DataCell(Text('$total', style: const TextStyle(fontWeight: FontWeight.bold))),
                      DataCell(Text('${average.toStringAsFixed(1)}%')),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: passed ? Colors.green.shade50 : Colors.red.shade50,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            passed ? 'PASS' : 'FAIL',
                            style: TextStyle(
                              color: passed ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectStatusChip(String subject, bool isSubmitted) {
    return Chip(
      avatar: Icon(
        isSubmitted ? Icons.check_circle : Icons.pending,
        color: isSubmitted ? Colors.green : Colors.orange,
        size: 18,
      ),
      label: Text(
        '$subject: ${isSubmitted ? "Submitted" : "Pending"}',
        style: TextStyle(fontSize: 12, color: isSubmitted ? Colors.black87 : LavaTheme.textSecondary),
      ),
      backgroundColor: isSubmitted ? Colors.green.shade50 : Colors.orange.shade50,
      side: BorderSide.none,
    );
  }

  // --- TAB 3: REPORT CARDS ---
  Widget _buildReportCardsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Automated Report Cards',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: LavaTheme.textPrimary),
            ),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.picture_as_pdf_outlined, color: Colors.white),
              label: const Text('Export All PDFs', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: LavaTheme.orangeStart,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Expanded(
          child: Card(
            child: ListView.separated(
              itemCount: _classStudents.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final student = _classStudents[index];
                final resultCount = _repo.getResultsForStudent(student.id).length;
                return ListTile(
                  leading: const Icon(Icons.description, color: LavaTheme.orangeStart),
                  title: Text(student.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    resultCount > 0
                        ? 'Remarks: $resultCount subject results available.'
                        : 'Remarks: No results published yet.',
                  ),
                  trailing: TextButton(
                    onPressed: () {},
                    child: const Text('Preview Report Card'),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}