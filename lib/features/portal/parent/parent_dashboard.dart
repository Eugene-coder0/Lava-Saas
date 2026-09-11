import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../data/portal_repository.dart';
import '../portal_shell.dart';

class ParentDashboard extends StatefulWidget {
  final String parentCode;

  const ParentDashboard({
    super.key,
    this.parentCode = 'PAR-9842',
  });

  @override
  State<ParentDashboard> createState() => _ParentDashboardState();
}

class _ParentDashboardState extends State<ParentDashboard> {
  final PortalRepository _repo = PortalRepository.instance;
  int _currentNavIndex = 0;

  String get _parentCode => widget.parentCode;
  Student? get _student => _repo.getStudentByParentCode(_parentCode);
  List<SubjectResult> get _studentResults =>
      _repo.getResultsForParent(_parentCode);
  SubjectResult? get _latestResult =>
      _repo.getLatestResultForParent(_parentCode);
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

  String get _termLabel => 'Term 1';

  String get _overallAverage {
    if (_studentResults.isEmpty) return 'N/A';
    final total = _studentResults.map((r) => r.total).reduce((a, b) => a + b);
    return '${(total / _studentResults.length).toStringAsFixed(1)}%';
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

  @override
  Widget build(BuildContext context) {
    return PortalShell(
      roleTitle: 'Parent Portal',
      selectedIndex: _currentNavIndex,
      onDestinationSelected: (index) =>
          setState(() => _currentNavIndex = index),
      navItems: const [
        NavigationDestination(
            icon: Icon(Icons.space_dashboard_outlined), label: 'Overview'),
        NavigationDestination(
            icon: Icon(Icons.assessment_outlined), label: 'Results'),
        NavigationDestination(
            icon: Icon(Icons.picture_as_pdf_outlined), label: 'Report Card'),
      ],
      body: _buildCurrentTab(),
    );
  }

  Widget _buildCurrentTab() {
    switch (_currentNavIndex) {
      case 0:
        return _buildOverviewTab();
      case 1:
        return _buildSubjectBreakdownTab();
      case 2:
        return _buildReportCardTab();
      default:
        return _buildOverviewTab();
    }
  }

  // --- TAB 1: OVERVIEW & QUICK STATS ---
  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Student Profile Summary Card
          Card(
            color: LavaTheme.cardWhite,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: LavaTheme.creamBackground,
                    child: Icon(Icons.face_outlined,
                        size: 32, color: LavaTheme.orangeStart),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _student?.name ?? 'Adebayo Samuel',
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: LavaTheme.textPrimary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Class: ${_student?.className ?? 'Primary 4A'}  |  Student Access Code: ${_student?.id ?? 'LAVA-9842'}',
                          style: const TextStyle(
                              color: LavaTheme.textSecondary, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _termLabel,
                      style: TextStyle(
                          color: Colors.green.shade800,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                  )
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
                          const Text('Latest Result Posted',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: LavaTheme.textPrimary)),
                          const SizedBox(height: 6),
                          Text(
                            '${_latestResult!.studentName} – ${_latestResult!.subject}: ${_latestResult!.total}% (${_latestResult!.grade})',
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

          // Key Academic Metrics
          Row(
            children: [
              Expanded(
                  child: _buildStatCard('Overall Average', _overallAverage,
                      Icons.pie_chart_outline, LavaTheme.orangeStart)),
              const SizedBox(width: 16),
              Expanded(
                  child: _buildStatCard('Class Position', '3rd out of 32',
                      Icons.emoji_events_outlined, Colors.amber.shade800)),
              const SizedBox(width: 16),
              Expanded(
                  child: _buildStatCard('Attendance Rate', '96%',
                      Icons.calendar_today_outlined, Colors.green.shade700)),
            ],
          ),
          const SizedBox(height: 28),

          if (_subjectFilterOptions.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Filter Results',
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

          if (_subjectFilterOptions.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Sort by',
                        style: TextStyle(color: LavaTheme.textSecondary)),
                    DropdownButton<bool>(
                      value: _sortNewestFirst,
                      items: const [
                        DropdownMenuItem(value: true, child: Text('Newest')),
                        DropdownMenuItem(value: false, child: Text('Subject')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _sortNewestFirst = value);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                  child: _buildStatCard(
                      'Result Count',
                      '${_filteredResults.length}',
                      Icons.list_alt,
                      LavaTheme.orangeStart)),
              const SizedBox(width: 16),
              Expanded(
                  child: _buildStatCard(
                      'Sort Order',
                      _sortNewestFirst ? 'Newest' : 'Subject',
                      Icons.sort,
                      Colors.indigo)),
            ],
          ),
          const SizedBox(height: 16),

          const Text(
            'Current Term Performance Summary',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: LavaTheme.textPrimary),
          ),
          const SizedBox(height: 12),

          // Subject Performance Quick Summary
          Card(
            child: _studentResults.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                        'No academic results posted yet for this student.',
                        style: TextStyle(color: LavaTheme.textSecondary)),
                  )
                : _displayResults.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                            'No results match your selected subject filter.',
                            style: TextStyle(color: LavaTheme.textSecondary)),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _displayResults.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final sub = _displayResults[index];
                          return ListTile(
                            title: Text(sub.subject,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600)),
                            subtitle: Text(
                                'CA1: ${sub.ca1}  |  CA2: ${sub.ca2}  |  Exam: ${sub.exam}'),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: LavaTheme.orangeStart
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${sub.total}% (${sub.grade})',
                                style: const TextStyle(
                                    color: LavaTheme.orangeStart,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                        },
                      ),
          )
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

  // --- TAB 2: SUBJECT BREAKDOWN ---
  Widget _buildSubjectBreakdownTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Full Subject Breakdown',
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: LavaTheme.textPrimary),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Card(
            child: _studentResults.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      'No subject results are available yet. Please check back after scores have been posted.',
                      style: TextStyle(color: LavaTheme.textSecondary),
                    ),
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        horizontalMargin: 20,
                        columnSpacing: 36,
                        columns: const [
                          DataColumn(label: Text('Subject')),
                          DataColumn(label: Text('1st CA (20)')),
                          DataColumn(label: Text('2nd CA (20)')),
                          DataColumn(label: Text('Exam (60)')),
                          DataColumn(label: Text('Total (100)')),
                          DataColumn(label: Text('Grade')),
                        ],
                        rows: _displayResults.map((sub) {
                          return DataRow(cells: [
                            DataCell(Text(sub.subject,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold))),
                            DataCell(Text('${sub.ca1}')),
                            DataCell(Text('${sub.ca2}')),
                            DataCell(Text('${sub.exam}')),
                            DataCell(Text('${sub.total}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: LavaTheme.orangeStart))),
                            DataCell(Text(sub.grade,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold))),
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

  // --- TAB 3: DOWNLOADABLE REPORT CARD ---
  Widget _buildReportCardTab() {
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.picture_as_pdf_outlined,
                  size: 64, color: LavaTheme.orangeStart),
              const SizedBox(height: 16),
              const Text(
                'Official Term Report Sheet',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Download the complete signed PDF result slip for ${_student?.name ?? 'your student'}.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: LavaTheme.textSecondary),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Downloading PDF report card...')),
                  );
                },
                icon: const Icon(Icons.download, color: Colors.white),
                label: const Text('Download PDF',
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: LavaTheme.orangeStart,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
