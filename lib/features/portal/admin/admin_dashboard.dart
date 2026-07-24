import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../data/portal_repository.dart';
import '../portal_shell.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final PortalRepository _repo = PortalRepository.instance;
  int _currentNavIndex = 0;

  List<Student> get _students => _repo.students;
  List<Teacher> get _staff => _repo.teachers;

  void _showAddStudentModal() {
    final nameController = TextEditingController();
    final classController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.person_add_alt_1, color: LavaTheme.orangeStart),
            SizedBox(width: 10),
            Text('Enroll New Student', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Student Full Name',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: classController,
              decoration: const InputDecoration(
                labelText: 'Assigned Class (e.g. Primary 4A)',
                prefixIcon: Icon(Icons.class_),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: LavaTheme.orangeStart,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            icon: const Icon(Icons.check, color: Colors.white, size: 18),
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                setState(() {
                  _repo.addStudent(
                    nameController.text,
                    classController.text.isEmpty ? 'Primary 1' : classController.text,
                  );
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Student registered! Parent Access Code generated.')),
                );
              }
            },
            label: const Text('Register Student', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAddTeacherModal() {
    final nameController = TextEditingController();
    final roleController = TextEditingController();
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.person_add_alt_1, color: LavaTheme.orangeStart),
            SizedBox(width: 10),
            Text('Add New Teacher', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Teacher Full Name',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: roleController,
              decoration: const InputDecoration(
                labelText: 'Role (e.g. Subject Teacher)',
                prefixIcon: Icon(Icons.badge),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email Address',
                prefixIcon: Icon(Icons.email),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: LavaTheme.orangeStart,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            icon: const Icon(Icons.check, color: Colors.white, size: 18),
            onPressed: () {
              if (nameController.text.isNotEmpty && roleController.text.isNotEmpty && emailController.text.isNotEmpty) {
                setState(() {
                  _repo.addTeacher(nameController.text, roleController.text, emailController.text);
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Teacher added successfully.')),
                );
              }
            },
            label: const Text('Add Teacher', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PortalShell(
      roleTitle: 'Executive Admin Command',
      selectedIndex: _currentNavIndex,
      onDestinationSelected: (index) => setState(() => _currentNavIndex = index),
      navItems: const [
        NavigationDestination(icon: Icon(Icons.admin_panel_settings_outlined), label: 'Control Center'),
        NavigationDestination(icon: Icon(Icons.school_outlined), label: 'Students Directory'),
        NavigationDestination(icon: Icon(Icons.badge_outlined), label: 'Staff Roster'),
      ],
      body: _buildCurrentTab(),
    );
  }

  Widget _buildCurrentTab() {
    switch (_currentNavIndex) {
      case 0:
        return _buildControlCenterTab();
      case 1:
        return _buildStudentsTab();
      case 2:
        return _buildStaffTab();
      default:
        return _buildControlCenterTab();
    }
  }

  // --- TAB 1: EXECUTIVE CONTROL CENTER ---
  Widget _buildControlCenterTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Executive Command Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A1A1A), LavaTheme.orangeStart],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: LavaTheme.orangeStart.withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.security_outlined, size: 36, color: Colors.white),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Principal Command Dashboard',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Session: 2025/2026 Academic Year  •  Third Term Active',
                        style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 14),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _showAddStudentModal,
                  icon: const Icon(Icons.add, color: Color(0xFF1A1A1A)),
                  label: const Text('Quick Enroll', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A))),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Key System Performance Counters
          Row(
            children: [
              Expanded(child: _buildMetricCard('Total Student Body', '${_students.length}', Icons.groups, LavaTheme.orangeStart, '+4 new this term')),
              const SizedBox(width: 16),
              Expanded(child: _buildMetricCard('Teaching & Non-Teaching', '${_staff.length}', Icons.badge, Colors.indigo, '2 on active leave')),
              const SizedBox(width: 16),
              Expanded(child: _buildMetricCard('Fee Collection Rate', '82.4%', Icons.account_balance_wallet_outlined, Colors.green.shade700, '₦4.2M Collected')),
            ],
          ),
          const SizedBox(height: 28),

          // Action Shortcuts & Whole-School Status
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Power Actions Panel
              Expanded(
                flex: 2,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Executive Command Actions',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: LavaTheme.textPrimary),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            _buildActionButton(Icons.campaign_outlined, 'School Broadcast', Colors.orange),
                            _buildActionButton(Icons.assignment_ind_outlined, 'Assign Subject Teachers', Colors.blue),
                            _buildActionButton(Icons.assessment_outlined, 'Lock Term Broadsheets', Colors.purple),
                            _buildActionButton(Icons.receipt_long_outlined, 'Generate Fee Invoices', Colors.green),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),

              // Quick Staff Presence Summary
              Expanded(
                flex: 1,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Staff Status Today',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: LavaTheme.textPrimary),
                        ),
                        const SizedBox(height: 12),
                        ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          leading: const CircleAvatar(backgroundColor: Colors.green, radius: 6),
                          title: const Text('Present & Teaching', style: TextStyle(fontWeight: FontWeight.w600)),
                          trailing: const Text('24 Staff', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          leading: const CircleAvatar(backgroundColor: Colors.orange, radius: 6),
                          title: const Text('On Permitted Leave', style: TextStyle(fontWeight: FontWeight.w600)),
                          trailing: const Text('2 Staff', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Triggered action: $label')),
        );
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 12),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color, String badgeText) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: color.withOpacity(0.12),
                  child: Icon(icon, color: color),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(badgeText, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
                )
              ],
            ),
            const SizedBox(height: 16),
            Text(value, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: LavaTheme.textPrimary)),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(color: LavaTheme.textSecondary, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  // --- TAB 2: STUDENTS DIRECTORY ---
  Widget _buildStudentsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Master Student Registry',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: LavaTheme.textPrimary),
            ),
            ElevatedButton.icon(
              onPressed: () => _showAddStudentModal(),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Add Student', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: LavaTheme.orangeStart,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: _showAddTeacherModal,
              icon: const Icon(Icons.person_add, color: Colors.white),
              label: const Text('Add Teacher', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Card(
            child: ListView.separated(
              itemCount: _students.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final student = _students[index];
                  final bool feePaid = student.fees == 'Paid';

                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: LavaTheme.orangeStart.withOpacity(0.1),
                      child: Text(student.name[0], style: const TextStyle(color: LavaTheme.orangeStart, fontWeight: FontWeight.bold)),
                  ),
                  title: Text(student.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('ID: ${student.id} | Class: ${student.className} | Parent Code: ${student.parentCode}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Chip(
                        label: Text(student.fees, style: TextStyle(color: feePaid ? Colors.green : Colors.orange, fontSize: 11, fontWeight: FontWeight.bold)),
                        backgroundColor: feePaid ? Colors.green.shade50 : Colors.orange.shade50,
                        side: BorderSide.none,
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {},
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  // --- TAB 3: STAFF ROSTER ---
  Widget _buildStaffTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'School Staff & Faculty Directory',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: LavaTheme.textPrimary),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Card(
            child: ListView.separated(
              itemCount: _staff.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final member = _staff[index];
                final bool isPresent = member.status == 'Present';

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  leading: CircleAvatar(
                    backgroundColor: Colors.indigo.shade50,
                    child: Icon(Icons.person, color: Colors.indigo.shade700),
                  ),
                  title: Text(member.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${member.role} • ${member.email}'),
                  trailing: Chip(
                    label: Text(member.status, style: TextStyle(color: isPresent ? Colors.green : Colors.grey, fontSize: 11, fontWeight: FontWeight.bold)),
                    backgroundColor: isPresent ? Colors.green.shade50 : Colors.grey.shade200,
                    side: BorderSide.none,
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