import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../data/portal_repository.dart';
import '../portal_shell.dart';

class StudentDashboard extends StatefulWidget {
  final String studentId;

  const StudentDashboard({
    super.key,
    this.studentId = 'LAVA-9842',
  });

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  final PortalRepository _repo = PortalRepository.instance;
  int _currentNavIndex = 0;

  String get _studentId => widget.studentId;
  Student? get _student => _repo.getStudentById(_studentId);
  List<SubjectResult> get _studentResults =>
      _repo.getResultsForStudent(_studentId);
  SubjectResult? get _latestResult =>
      _repo.getLatestResultForStudent(_studentId);
  String? _selectedSubject;

  bool _sortNewestFirst = true;

  List<String> get _subjectFilterOptions {
    final subjects =
        _studentResults.map((result) => result.subject).toSet().toList();
    subjects.sort();
    return subjects;
  }

  List<SubjectResult> get _filteredResults {
    if (_selectedSubject == null || _selectedSubject == 'All') {
      return _studentResults;
    }
    return _studentResults
        .where((result) => result.subject == _selectedSubject)
        .toList();
  }

  List<SubjectResult> get _displayResults {
    final results = List<SubjectResult>.from(_filteredResults);
    results.sort((a, b) {
      if (_sortNewestFirst) {
        return b.postedAt.compareTo(a.postedAt);
      }
      return a.subject.compareTo(b.subject);
    });
    return results;
  }

  String get _bestSubject {
    if (_studentResults.isEmpty) return 'N/A';
    final best = _studentResults.reduce((a, b) => a.total >= b.total ? a : b);
    return '${best.subject} (${best.total}%)';
  }

  String get _averageScore {
    if (_studentResults.isEmpty) return 'N/A';
    final total =
        _studentResults.map((result) => result.total).reduce((a, b) => a + b);
    return '${(total / _studentResults.length).toStringAsFixed(1)}%';
  }

  int get _resultCount => _studentResults.length;

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

  final List<Map<String, dynamic>> _assignments = [
    {
      'subject': 'Mathematics',
      'title': 'Exercise 4B: Quadratic Equations',
      'dueDate': 'Tomorrow, 5:00 PM',
      'status': 'Pending',
    },
    {
      'subject': 'English Language',
      'title': 'Essay on "My Summer Holiday"',
      'dueDate': '28th July',
      'status': 'Submitted',
    },
    {
      'subject': 'Basic Science',
      'title': 'Living and Non-Living Things Worksheet',
      'dueDate': '30th July',
      'status': 'Pending',
    },
  ];

  final List<Map<String, String>> _todayClasses = [
    {'time': '08:00 AM', 'subject': 'Mathematics', 'room': 'Room 4A'},
    {'time': '09:30 AM', 'subject': 'English Language', 'room': 'Room 4A'},
    {'time': '11:30 AM', 'subject': 'Basic Science', 'room': 'Lab 2'},
    {'time': '01:00 PM', 'subject': 'Social Studies', 'room': 'Room 4A'},
  ];

  @override
  Widget build(BuildContext context) {
    return PortalShell(
      roleTitle: 'Student Portal',
      selectedIndex: _currentNavIndex,
      onDestinationSelected: (index) =>
          setState(() => _currentNavIndex = index),
      navItems: const [
        NavigationDestination(
            icon: Icon(Icons.dashboard_outlined), label: 'Dashboard'),
        NavigationDestination(
            icon: Icon(Icons.assignment_outlined), label: 'Assignments'),
        NavigationDestination(
            icon: Icon(Icons.schedule_outlined), label: 'Timetable'),
      ],
      body: _buildCurrentTab(),
    );
  }

  Widget _buildCurrentTab() {
    switch (_currentNavIndex) {
      case 0:
        return _buildOverviewTab();
      case 1:
        return _buildAssignmentsTab();
      case 2:
        return _buildTimetableTab();
      default:
        return _buildOverviewTab();
    }
  }

  // --- TAB 1: OVERVIEW ---
  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting Card
          Card(
            color: LavaTheme.cardWhite,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: LavaTheme.creamBackground,
                    child: Icon(Icons.school,
                        size: 32, color: LavaTheme.orangeStart),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back, ${_student?.name ?? 'Student'}!',
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: LavaTheme.textPrimary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Class: ${_student?.className ?? 'Unknown'} | Student ID: ${_student?.id ?? _studentId}',
                          style: const TextStyle(
                              color: LavaTheme.textSecondary, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          if (_latestResult != null)
            Card(
              color: LavaTheme.cardWhite,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Latest Update',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: LavaTheme.textPrimary)),
                          const SizedBox(height: 6),
                          Text(
                            '${_latestResult!.subject} result posted: ${_latestResult!.total}% • ${_latestResult!.grade}',
                            style:
                                const TextStyle(color: LavaTheme.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      _latestResult!.postedBy,
                      style: const TextStyle(
                          fontSize: 12, color: LavaTheme.textSecondary),
                    ),
                  ],
                ),
              ),
            ),

          if (_latestResult != null) const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                  child: _buildStatCard('Result Count', '$_resultCount',
                      Icons.list_alt, LavaTheme.orangeStart)),
              const SizedBox(width: 16),
              Expanded(
                  child: _buildStatCard('Best Subject', _bestSubject,
                      Icons.star, Colors.amber.shade700)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                  child: _buildStatCard('Average Score', _averageScore,
                      Icons.bar_chart, Colors.green.shade700)),
            ],
          ),
          const SizedBox(height: 24),

          if (_subjectFilterOptions.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Filter by subject',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: LavaTheme.textPrimary)),
                    DropdownButton<String>(
                      value: _selectedSubject ?? 'All',
                      items: ['All', ..._subjectFilterOptions]
                          .map((subject) => DropdownMenuItem(
                              value: subject, child: Text(subject)))
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _selectedSubject = value),
                    ),
                  ],
                ),
              ),
            ),

          if (_subjectFilterOptions.isNotEmpty) const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Latest Results',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: LavaTheme.textPrimary)),
                      Row(
                        children: [
                          const Text('Sort: ',
                              style: TextStyle(color: LavaTheme.textSecondary)),
                          DropdownButton<bool>(
                            value: _sortNewestFirst,
                            items: const [
                              DropdownMenuItem(
                                  value: true, child: Text('Newest')),
                              DropdownMenuItem(
                                  value: false, child: Text('Subject')),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _sortNewestFirst = value);
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_displayResults.isEmpty)
                    const Text('No results match the selected filter.',
                        style: TextStyle(color: LavaTheme.textSecondary))
                  else
                    Column(
                      children: _displayResults.map((result) {
                        return ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          title: Text(result.subject,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Text(
                              'Total: ${result.total} • Grade: ${result.grade}'),
                          trailing: Text(result.postedBy,
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: LavaTheme.textSecondary)),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Today's Timetable Preview
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Today\'s Schedule',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: LavaTheme.textPrimary),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _todayClasses.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final item = _todayClasses[index];
                          return ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: LavaTheme.orangeStart
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                item['time']!,
                                style: const TextStyle(
                                    color: LavaTheme.orangeStart,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11),
                              ),
                            ),
                            title: Text(item['subject']!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600)),
                            subtitle: Text(item['room']!),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),

              // Pending Assignments Preview
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Upcoming Homework',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: LavaTheme.textPrimary),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _assignments.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final ass = _assignments[index];
                          final bool isSubmitted = ass['status'] == 'Submitted';

                          return ListTile(
                            title: Text(ass['title']!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 14)),
                            subtitle: Text(
                                '${ass['subject']} • Due: ${ass['dueDate']}'),
                            trailing: Chip(
                              label: Text(
                                ass['status']!,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isSubmitted
                                      ? Colors.green
                                      : Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              backgroundColor: isSubmitted
                                  ? Colors.green.shade50
                                  : Colors.orange.shade50,
                              side: BorderSide.none,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.12),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: LavaTheme.textSecondary, fontSize: 13)),
                const SizedBox(height: 4),
                Text(value,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: LavaTheme.textPrimary)),
              ],
            )
          ],
        ),
      ),
    );
  }

  // --- TAB 2: ASSIGNMENTS ---
  Widget _buildAssignmentsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Assignments & Homework Tasks',
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: LavaTheme.textPrimary),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Card(
            child: ListView.separated(
              itemCount: _assignments.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final ass = _assignments[index];
                final bool isSubmitted = ass['status'] == 'Submitted';

                return ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor:
                        LavaTheme.orangeStart.withValues(alpha: 0.1),
                    child: const Icon(Icons.assignment,
                        color: LavaTheme.orangeStart),
                  ),
                  title: Text(ass['title']!,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                      'Subject: ${ass['subject']} | Due: ${ass['dueDate']}'),
                  trailing: OutlinedButton(
                    onPressed: isSubmitted ? null : () {},
                    child: Text(isSubmitted ? 'Submitted' : 'Upload Solution'),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  // --- TAB 3: FULL TIMETABLE ---
  Widget _buildTimetableTab() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Weekly Class Timetable',
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: LavaTheme.textPrimary),
        ),
        SizedBox(height: 16),
        Expanded(
          child: Card(
            child: Center(
              child: Text(
                'Full Weekly Schedule Grid View',
                style: TextStyle(color: LavaTheme.textSecondary),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
