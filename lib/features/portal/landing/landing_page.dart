import 'package:flutter/material.dart';
import 'package:lavasaas/app/theme/app_theme.dart';
import 'package:lavasaas/features/portal/auth/login_page.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  void _openLogin(BuildContext context, [PortalRole role = PortalRole.admin]) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => LoginPage(initialRole: role)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7ED),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- TOP NAVIGATION BAR ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
              color: Colors.white,
              child: MaxWidthContainer(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Logo & Name
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF5F1F), Color(0xFFFFB627)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.local_fire_department, color: Colors.white, size: 18),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Greenfield Secondary School',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF3A2A1A),
                          ),
                        ),
                      ],
                    ),
                    // Navigation Links & Login Button
                    Row(
                      children: [
                        if (MediaQuery.of(context).size.width > 700) ...[
                          const Text('Home', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF3A2A1A))),
                          const SizedBox(width: 20),
                          const Text('About', style: TextStyle(fontSize: 13, color: Color(0xFF8A7660))),
                          const SizedBox(width: 20),
                          const Text('Academics', style: TextStyle(fontSize: 13, color: Color(0xFF8A7660))),
                          const SizedBox(width: 20),
                          const Text('Admissions', style: TextStyle(fontSize: 13, color: Color(0xFF8A7660))),
                          const SizedBox(width: 20),
                          const Text('Gallery', style: TextStyle(fontSize: 13, color: Color(0xFF8A7660))),
                          const SizedBox(width: 24),
                        ],
                        ValueListenableBuilder<ThemeMode>(
                          valueListenable: LavaTheme.themeMode,
                          builder: (context, mode, child) {
                            return IconButton(
                              icon: Icon(mode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode, color: const Color(0xFF3A2A1A)),
                              tooltip: mode == ThemeMode.dark ? 'Switch to light mode' : 'Switch to dark mode',
                              onPressed: LavaTheme.toggleTheme,
                            );
                          },
                        ),
                        GradientButton(
                          text: 'Portal login',
                          onPressed: () => _openLogin(context),
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFF0E0C8)),

            // --- HERO SECTION ---
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFFEBD6), Color(0xFFFFF7ED)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
              child: MaxWidthContainer(
                child: Column(
                  children: [
                    const Text(
                      'EST. 1998 · IDIMU, LAGOS',
                      style: TextStyle(
                        fontSize: 12,
                        letterSpacing: 1.0,
                        color: Color(0xFFFF5F1F),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3A2A1A),
                          height: 1.2,
                        ),
                        children: [
                          const TextSpan(text: 'Shaping character, '),
                          WidgetSpan(
                            child: ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [Color(0xFFFF5F1F), Color(0xFFFFB627)],
                              ).createShader(bounds),
                              child: const Text(
                                'building excellence',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
// ✅ CORRECT
ConstrainedBox(
  constraints: const BoxConstraints(maxWidth: 440),
  child: const Text(
    'A full academic community for the mind, body, and character of every child.',
    textAlign: TextAlign.center,
    style: TextStyle(fontSize: 14, color: Color(0xFF5C4A38)),
  ),
),
                    const SizedBox(height: 22),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GradientButton(
                          text: 'Apply for admission',
                          onPressed: () {},
                          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF3A2A1A),
                            side: const BorderSide(color: Color(0xFFF0E0C8)),
                            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Explore academics', style: TextStyle(fontSize: 14)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // --- STATS BAR ---
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
              child: MaxWidthContainer(
                child: Row(
                  children: [
                    _StatItem(number: '642', label: 'Students', showBorder: false),
                    _StatItem(number: '58', label: 'Teaching staff'),
                    _StatItem(number: '27', label: 'Years running'),
                    _StatItem(number: '96%', label: 'WAEC pass rate'),
                  ],
                ),
              ),
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFF0E0C8)),

            // --- ACADEMIC LIFE SECTION ---
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
              child: MaxWidthContainer(
                child: Column(
                  children: [
                    const Text(
                      'ACADEMIC LIFE',
                      style: TextStyle(
                        fontSize: 12,
                        letterSpacing: 0.8,
                        color: Color(0xFFFF5F1F),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'More than a classroom',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF3A2A1A)),
                    ),
                    const SizedBox(height: 24),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isDesktop = constraints.maxWidth > 700;
                        return GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: isDesktop ? 4 : 2,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                          childAspectRatio: isDesktop ? 1.4 : 1.2,
                          children: const [
                            _AcademicCard(title: 'Sciences', icon: Icons.science_outlined),
                            _AcademicCard(title: 'Arts & culture', icon: Icons.palette_outlined),
                            _AcademicCard(title: 'Sports', icon: Icons.sports_soccer_outlined),
                            _AcademicCard(title: 'Clubs & societies', icon: Icons.groups_outlined),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // --- ADMISSIONS SECTION BANNER ---
            Container(
              color: const Color(0xFF3A2A1A),
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 28),
              child: MaxWidthContainer(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isDesktop = constraints.maxWidth > 650;
                    return Flex(
                      direction: isDesktop ? Axis.horizontal : Axis.vertical,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: isDesktop ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'ADMISSIONS',
                              style: TextStyle(
                                fontSize: 12,
                                letterSpacing: 0.8,
                                color: Color(0xFFFFB627),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              '2026/2027 session now open',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Entrance exams run monthly — apply online in under 10 minutes.',
                              style: TextStyle(fontSize: 13, color: Color(0xFFD9C9B4)),
                            ),
                          ],
                        ),
                        if (!isDesktop) const SizedBox(height: 16),
                        GradientButton(
                          text: 'Start application',
                          onPressed: () {},
                          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),

            // --- LATEST NEWS SECTION ---
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
              child: MaxWidthContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'LATEST NEWS',
                      style: TextStyle(
                        fontSize: 12,
                        letterSpacing: 0.8,
                        color: Color(0xFFFF5F1F),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isDesktop = constraints.maxWidth > 700;
                        return GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: isDesktop ? 3 : 1,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                          childAspectRatio: isDesktop ? 1.5 : 2.2,
                          children: const [
                            _NewsCard(
                              title: '63 students score 300+ in UTME',
                              timeAgo: '2 days ago',
                              icon: Icons.workspace_premium_outlined,
                            ),
                            _NewsCard(
                              title: 'Graduation ceremony · Class of 2026',
                              timeAgo: '1 week ago',
                              icon: Icons.school_outlined,
                            ),
                            _NewsCard(
                              title: 'Inter-house sports competition',
                              timeAgo: '2 weeks ago',
                              icon: Icons.emoji_events_outlined,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // --- FOOTER ---
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 28),
              child: MaxWidthContainer(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isDesktop = constraints.maxWidth > 600;
                    return Flex(
                      direction: isDesktop ? Axis.horizontal : Axis.vertical,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          '© 2026 Greenfield Secondary School · Powered by LavaSaaS',
                          style: TextStyle(fontSize: 12, color: Color(0xFF8A7660)),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '107 Liasu Rd, Idimu, Lagos · info@greenfield.edu.ng',
                          style: TextStyle(fontSize: 12, color: Color(0xFF8A7660)),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- HELPER COMPONENTS ---

class MaxWidthContainer extends StatelessWidget {
  final Widget child;
  const MaxWidthContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: child,
      ),
    );
  }
}

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final EdgeInsetsGeometry padding;

  const GradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF5F1F), Color(0xFFFFB627)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: padding,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String number;
  final String label;
  final bool showBorder;

  const _StatItem({
    required this.number,
    required this.label,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: showBorder
              ? const Border(left: BorderSide(color: Color(0xFFF0E0C8), width: 0.5))
              : null,
        ),
        child: Column(
          children: [
            Text(
              number,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFFF5F1F)),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Color(0xFF8A7660)),
            ),
          ],
        ),
      ),
    );
  }
}

class _AcademicCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const _AcademicCard({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFFFF5F1F), size: 22),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF3A2A1A)),
          ),
        ],
      ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  final String title;
  final String timeAgo;
  final IconData icon;

  const _NewsCard({
    required this.title,
    required this.timeAgo,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 80,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFD9A8), Color(0xFFFFB627)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Icon(icon, size: 28, color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF3A2A1A)),
                ),
                const SizedBox(height: 4),
                Text(
                  timeAgo,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF8A7660)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}