import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../data/portal_repository.dart';
import '../portal_shell.dart';

class SubjectTeacherDashboard extends StatefulWidget {
  const SubjectTeacherDashboard({super.key});

  @override
  State<SubjectTeacherDashboard> createState() => _SubjectTeacherDashboardState();
}

class _SubjectTeacherDashboardState extends State<SubjectTeacherDashboard> {
  final PortalRepository _repo = PortalRepository.instance;
  int _currentNavIndex = 0;

  List<SubjectAssignment> get _assignedClasses => _repo.classAssignments;
  List<SubjectResult> get _submittedResults => _repo.results;

  int get _submittedResultsCount => _submittedResults.length;

  int get _pendingClassCount {
    return _assignedClasses.where((item) => !_repo.hasResultsForClass(item.className, item.subject)).length;
  }

  List<SubjectResult> get _recentResults {
    final results = List<SubjectResult>.from(_submittedResults);
    results.sort((a, b) => b.postedAt.compareTo(a.postedAt));
    return results;
  }

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

  void _openScoreEntryModal(String className, String subject) {
    showDialog(
      context: context,
      builder: (context) => ScoreEntryModal(
        className: className,
        subject: subject,
        repository: _repo,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PortalShell(
      roleTitle: 'Subject Teacher - Mathematics',
      selectedIndex: _currentNavIndex,
      onDestinationSelected: (index) => setState(() => _currentNavIndex = index),
      navItems: const [
        NavigationDestination(icon: Icon(Icons.class_outlined), label: 'My Classes'),
        NavigationDestination(icon: Icon(Icons.history_outlined), label: 'Submission Log'),
      ],
      body: _buildCurrentTab(),
    );
  }

  Widget _buildCurrentTab() {
    if (_currentNavIndex == 1) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: _submittedResults.isEmpty
            ? const Center(
                child: Text(
                  'No scores have been submitted yet. Select a class to add student results.',
                  style: TextStyle(color: LavaTheme.textSecondary),
                  textAlign: TextAlign.center,
                ),
              )
            : ListView.separated(
                itemCount: _recentResults.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final result = _recentResults[index];
                  return ListTile(
                    title: Text('${result.studentName} • ${result.subject}', style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text('${result.className} | Posted by ${result.postedBy}'),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('${result.total} pts', style: const TextStyle(fontWeight: FontWeight.bold, color: LavaTheme.orangeStart)),
                        const SizedBox(height: 4),
                        Text('${result.grade}', style: const TextStyle(color: LavaTheme.textSecondary)),
                      ],
                    ),
                  );
                },
              ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Assigned Classes',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: LavaTheme.textPrimary),
        ),
        const SizedBox(height: 4),
        Text(
          'Select a class card to input or update Continuous Assessment (CA) and Exam scores. $_pendingClassCount class${_pendingClassCount == 1 ? '' : 'es'} still needs results.',
          style: const TextStyle(color: LavaTheme.textSecondary),
        ),
        const SizedBox(height: 24),

        Row(
          children: [
            Expanded(
              child: _buildSummaryCard('Submission Log', '$_submittedResultsCount entries', Icons.history_outlined, Colors.indigo),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildSummaryCard('Pending Uploads', '$_pendingClassCount subjects', Icons.pending_actions, Colors.orange),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Grid of Assigned Classes
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 320,
              mainAxisExtent: 180,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: _assignedClasses.length,
            itemBuilder: (context, index) {
              final item = _assignedClasses[index];
              final bool isSubmitted = _repo.hasResultsForClass(item.className, item.subject);
              final String statusLabel = isSubmitted ? 'Submitted' : 'Pending Submission';
              final String studentCount = '${item.studentCount} Students';

              return Card(
                elevation: 2,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => _openScoreEntryModal(item.className, item.subject),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: LavaTheme.orangeStart.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                item.subject,
                                style: const TextStyle(
                                  color: LavaTheme.orangeStart,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Icon(
                              isSubmitted ? Icons.check_circle : Icons.pending_actions,
                              color: isSubmitted ? Colors.green : Colors.orange,
                              size: 20,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.className,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: LavaTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              studentCount,
                              style: const TextStyle(
                                color: LavaTheme.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              statusLabel,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isSubmitted ? Colors.green : Colors.orange,
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios, size: 14, color: LavaTheme.textSecondary),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.12),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: LavaTheme.textPrimary)),
                const SizedBox(height: 6),
                Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: LavaTheme.textSecondary)),
              ],
            ),
          ],
        ),
      ),
    );
  }}

// --- SCORE ENTRY MODAL (FIXED OVERFLOW) ---
class ScoreEntryModal extends StatefulWidget {
  final String className;
  final String subject;
  final PortalRepository repository;

  const ScoreEntryModal({
    super.key,
    required this.className,
    required this.subject,
    required this.repository,
  });

  @override
  State<ScoreEntryModal> createState() => _ScoreEntryModalState();
}

class _ScoreEntryModalState extends State<ScoreEntryModal> {
  late final List<Map<String, dynamic>> _scoreEntries;

  @override
  void initState() {
    super.initState();
    final students = widget.repository.getStudentsForClass(widget.className);
    _scoreEntries = students.map((student) {
      final existing = widget.repository.results.firstWhere(
        (result) => result.studentId == student.id && result.subject == widget.subject,
        orElse: () => SubjectResult(
          studentId: student.id,
          studentName: student.name,
          className: widget.className,
          subject: widget.subject,
          ca1: 0,
          ca2: 0,
          exam: 0,
          postedBy: '',
          postedAt: DateTime.now(),
        ),
      );

      return {
        'studentId': student.id,
        'name': student.name,
        'ca1': existing.ca1.toString(),
        'ca2': existing.ca2.toString(),
        'exam': existing.exam.toString(),
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 760, // Increased modal width to comfortably fit form controls
        height: 520,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Modal Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Score Entry: ${widget.subject}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Class: ${widget.className} | Term 1',
                      style: const TextStyle(color: LavaTheme.textSecondary, fontSize: 13),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(height: 24),

            // Scores Table Wrapped in Horizontal Scroll for Safety
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: 700,
                    child: DataTable(
                      horizontalMargin: 12,
                      columnSpacing: 16,
                      columns: const [
                        DataColumn(label: Text('Student Name')),
                        DataColumn(label: Text('1st CA (20)')),
                        DataColumn(label: Text('2nd CA (20)')),
                        DataColumn(label: Text('Exam (60)')),
                        DataColumn(label: Text('Total (100)')),
                      ],
                      rows: _scoreEntries.map((student) {
                        int ca1 = int.tryParse(student['ca1']) ?? 0;
                        int ca2 = int.tryParse(student['ca2']) ?? 0;
                        int exam = int.tryParse(student['exam']) ?? 0;
                        int total = ca1 + ca2 + exam;

                        return DataRow(cells: [
                          DataCell(Text(student['name'], style: const TextStyle(fontWeight: FontWeight.w600))),
                          DataCell(
                            SizedBox(
                              width: 50,
                              child: TextField(
                                controller: TextEditingController(text: student['ca1']),
                                keyboardType: TextInputType.number,
                                onChanged: (val) => setState(() => student['ca1'] = val),
                                decoration: const InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            SizedBox(
                              width: 50,
                              child: TextField(
                                controller: TextEditingController(text: student['ca2']),
                                keyboardType: TextInputType.number,
                                onChanged: (val) => setState(() => student['ca2'] = val),
                                decoration: const InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            SizedBox(
                              width: 50,
                              child: TextField(
                                controller: TextEditingController(text: student['exam']),
                                keyboardType: TextInputType.number,
                                onChanged: (val) => setState(() => student['exam'] = val),
                                decoration: const InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              '$total',
                              style: const TextStyle(fontWeight: FontWeight.bold, color: LavaTheme.orangeStart),
                            ),
                          ),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Modal Footer Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(color: LavaTheme.textSecondary)),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    for (final student in _scoreEntries) {
                      final studentId = student['studentId'] as String;
                      final ca1 = int.tryParse(student['ca1'] as String) ?? 0;
                      final ca2 = int.tryParse(student['ca2'] as String) ?? 0;
                      final exam = int.tryParse(student['exam'] as String) ?? 0;

                      widget.repository.postSubjectResults(
                        studentId,
                        widget.className,
                        widget.subject,
                        ca1,
                        ca2,
                        exam,
                        'Mrs. Sarah Smith',
                      );
                    }

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Scores synced to ${widget.className} Class Broad Sheet!')),
                    );
                  },
                  icon: const Icon(Icons.sync, color: Colors.white, size: 18),
                  label: const Text('Save & Sync Scores', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: LavaTheme.orangeStart,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}