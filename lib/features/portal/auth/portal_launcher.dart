// 1. Add the main Flutter Material import (FIXES ALL UI ERRORS)
import 'package:flutter/material.dart';

// 2. Fix your project imports using package syntax
import 'package:lavasaas/app/theme/app_theme.dart';
import 'package:lavasaas/features/portal/admin/admin_dashboard.dart';
import 'package:lavasaas/features/portal/class_teacher/class_teacher_dashboard.dart';
import 'package:lavasaas/features/portal/parent/parent_dashboard.dart';
import 'package:lavasaas/features/portal/student/student_dashboard.dart';
import 'package:lavasaas/features/portal/subject_teacher/subject_teacher_dashboard.dart';
class PortalLauncherScreen extends StatelessWidget {
  const PortalLauncherScreen({super.key});

  void _navigateToPortal(BuildContext context, Widget portalScreen) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => portalScreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LavaTheme.creamBackground,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: LavaTheme.orangeStart,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.volcano, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            const Text('Lava SaaS - Multi-Portal Router', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select a Portal Role to Experience',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: LavaTheme.textPrimary),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Choose any role below to launch and test its dedicated dashboard experience.',
                  style: TextStyle(color: LavaTheme.textSecondary, fontSize: 15),
                ),
                const SizedBox(height: 32),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: MediaQuery.of(context).size.width > 700 ? 3 : 1,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                  children: [
                    _buildRoleCard(
                      context,
                      title: 'Principal / Admin',
                      subtitle: 'Executive control center, student enrollment & staff roster',
                      icon: Icons.admin_panel_settings_outlined,
                      color: const Color(0xFF1A1A1A),
                      onTap: () => _navigateToPortal(context, const AdminDashboard()),
                    ),
                    _buildRoleCard(
                      context,
                      title: 'Class Teacher',
                      subtitle: 'Attendance register, broad sheets & term report cards',
                      icon: Icons.assignment_outlined,
                      color: LavaTheme.orangeStart,
                      onTap: () => _navigateToPortal(context, const ClassTeacherDashboard()),
                    ),
                    _buildRoleCard(
                      context,
                      title: 'Subject Teacher',
                      subtitle: 'Subject assessment entry & student score submitter',
                      icon: Icons.edit_note_outlined,
                      color: Colors.blue.shade700,
                      onTap: () => _navigateToPortal(context, const SubjectTeacherDashboard()),
                    ),
                    _buildRoleCard(
                      context,
                      title: 'Parent Portal',
                      subtitle: 'Child academic progress, grade breakdown & report cards (PAR-9842)',
                      icon: Icons.family_restroom_outlined,
                      color: Colors.green.shade700,
                      onTap: () => _navigateToPortal(context, const ParentDashboard(parentCode: 'PAR-9842')),
                    ),
                    _buildRoleCard(
                      context,
                      title: 'Student Portal',
                      subtitle: 'Daily timetable, active assignments & school schedules (LAVA-9842)',
                      icon: Icons.school_outlined,
                      color: Colors.purple.shade700,
                      onTap: () => _navigateToPortal(context, const StudentDashboard(studentId: 'LAVA-9842')),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: color.withOpacity(0.12),
                    radius: 24,
                    child: Icon(icon, color: color, size: 26),
                  ),
                  Icon(Icons.arrow_forward, color: Colors.grey.shade400, size: 20),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: LavaTheme.textPrimary)),
                  const SizedBox(height: 6),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: LavaTheme.textSecondary, height: 1.3)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}