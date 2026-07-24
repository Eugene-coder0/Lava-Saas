import 'package:flutter/material.dart';
import 'package:lavasaas/features/portal/admin/admin_dashboard.dart';
import 'package:lavasaas/features/portal/class_teacher/class_teacher_dashboard.dart';
import 'package:lavasaas/features/portal/subject_teacher/subject_teacher_dashboard.dart';
import 'package:lavasaas/features/portal/parent/parent_dashboard.dart';
import 'package:lavasaas/features/portal/student/student_dashboard.dart';

enum PortalRole { admin, classTeacher, subjectTeacher, parent, student }

class LoginPage extends StatefulWidget {
  final PortalRole initialRole;

  const LoginPage({super.key, this.initialRole = PortalRole.admin});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late PortalRole _selectedRole;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.initialRole;
    _setDemoCredentials(_selectedRole);
  }

  void _setDemoCredentials(PortalRole role) {
    switch (role) {
      case PortalRole.admin:
        _emailController.text = 'admin@lavasaas.com';
        _passwordController.text = 'admin123';
        break;
      case PortalRole.classTeacher:
        _emailController.text = 'classteacher@lavasaas.com';
        _passwordController.text = 'teacher123';
        break;
      case PortalRole.subjectTeacher:
        _emailController.text = 'subjectteacher@lavasaas.com';
        _passwordController.text = 'teacher123';
        break;
      case PortalRole.parent:
        _emailController.text = 'parent@lavasaas.com';
        _passwordController.text = 'parent123';
        break;
      case PortalRole.student:
        _emailController.text = 'student@lavasaas.com';
        _passwordController.text = 'student123';
        break;
    }
  }

  String get _demoAccessHint {
    switch (_selectedRole) {
      case PortalRole.admin:
        return 'Demo Mode: Sign in as admin to manage students, staff, and shared portal data.';
      case PortalRole.classTeacher:
        return 'Demo Mode: Sign in as class teacher to view attendance and class broad sheet data.';
      case PortalRole.subjectTeacher:
        return 'Demo Mode: Sign in as subject teacher to enter scores that parents and students can see.';
      case PortalRole.parent:
        return 'Demo Mode: Sign in as parent to view child results for parent code PAR-9842.';
      case PortalRole.student:
        return 'Demo Mode: Sign in as student to view results for student ID LAVA-9842.';
    }
  }

  void _handleLogin() {
    setState(() => _isLoading = true);

    // Frontend simulation delay
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() => _isLoading = false);

      Widget destination;
      switch (_selectedRole) {
        case PortalRole.admin:
          destination = const AdminDashboard();
          break;
        case PortalRole.classTeacher:
          destination = const ClassTeacherDashboard();
          break;
        case PortalRole.subjectTeacher:
          destination = const SubjectTeacherDashboard();
          break;
        case PortalRole.parent:
          destination = const ParentDashboard(parentCode: 'PAR-9842');
          break;
        case PortalRole.student:
          destination = const StudentDashboard(studentId: 'LAVA-9842');
          break;
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => destination),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 768;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Portal Login',
          style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Brand / Logo
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF6B35),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.school, color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Lava SaaS Portal',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Role Selection Dropdown
                    const Text(
                      'Select Portal Account',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFCBD5E1)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<PortalRole>(
                          value: _selectedRole,
                          isExpanded: true,
                          onChanged: (role) {
                            if (role != null) {
                              setState(() {
                                _selectedRole = role;
                                _setDemoCredentials(role);
                              });
                            }
                          },
                          items: const [
                            DropdownMenuItem(
                              value: PortalRole.admin,
                              child: Text('Administrator Portal'),
                            ),
                            DropdownMenuItem(
                              value: PortalRole.classTeacher,
                              child: Text('Class Teacher Portal'),
                            ),
                            DropdownMenuItem(
                              value: PortalRole.subjectTeacher,
                              child: Text('Subject Teacher Portal'),
                            ),
                            DropdownMenuItem(
                              value: PortalRole.parent,
                              child: Text('Parent / Guardian Portal'),
                            ),
                            DropdownMenuItem(
                              value: PortalRole.student,
                              child: Text('Student Portal'),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Email Field
                    const Text(
                      'Email Address / ID',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Enter your email',
                        filled: true,
                        fillColor: const Color(0xFFF1F5F9),
                        prefixIcon: const Icon(Icons.email_outlined, size: 20),
                        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Password Field
                    const Text(
                      'Password',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: 'Enter password',
                        filled: true,
                        fillColor: const Color(0xFFF1F5F9),
                        prefixIcon: const Icon(Icons.lock_outline, size: 20),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                            size: 20,
                          ),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6B35),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : const Text(
                                'Sign In to Dashboard',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Frontend Demo Hint Box
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFBFDBFE)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline, size: 18, color: Color(0xFF2563EB)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _demoAccessHint,
                              style: const TextStyle(fontSize: 12, color: Color(0xFF1E40AF)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}