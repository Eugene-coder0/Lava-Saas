import 'package:flutter/material.dart';
import '../../app/theme/app_theme.dart';

class PortalShell extends StatelessWidget {
  final String roleTitle; // e.g. "Class Teacher", "Subject Teacher", "Admin"
  final List<NavigationDestination> navItems;
  final Widget body;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const PortalShell({
    super.key,
    required this.roleTitle,
    required this.navItems,
    required this.body,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 24,
        title: Row(
          children: [
            // Brand Logo Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                gradient: LavaTheme.primaryGradient,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'LavaSaaS',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // User Role Tag
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: LavaTheme.orangeStart.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                roleTitle,
                style: const TextStyle(
                  color: LavaTheme.orangeStart,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        actions: [
          ValueListenableBuilder<ThemeMode>(
            valueListenable: LavaTheme.themeMode,
            builder: (context, mode, child) {
              return IconButton(
                icon: Icon(mode == ThemeMode.dark
                    ? Icons.dark_mode
                    : Icons.light_mode),
                tooltip: mode == ThemeMode.dark
                    ? 'Switch to light mode'
                    : 'Switch to dark mode',
                onPressed: LavaTheme.toggleTheme,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          const CircleAvatar(
            backgroundColor: LavaTheme.creamBackground,
            child: Icon(Icons.person, color: LavaTheme.textPrimary),
          ),
          const SizedBox(width: 24),
        ],
      ),
      body: Row(
        children: [
          // Sidebar Navigation
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            labelType: NavigationRailLabelType.selected,
            indicatorColor: LavaTheme.orangeStart.withValues(alpha: 0.15),
            selectedIconTheme:
                const IconThemeData(color: LavaTheme.orangeStart),
            unselectedIconTheme:
                const IconThemeData(color: LavaTheme.textSecondary),
            selectedLabelTextStyle: const TextStyle(
              color: LavaTheme.orangeStart,
              fontWeight: FontWeight.bold,
            ),
            destinations: navItems.map((item) {
              return NavigationRailDestination(
                icon: item.icon,
                selectedIcon: item.selectedIcon ?? item.icon,
                label: Text(item.label),
              );
            }).toList(),
          ),
          const VerticalDivider(
              thickness: 1, width: 1, color: Color(0xFFEFECE6)),
          // Main Portal View Body
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: body,
            ),
          ),
        ],
      ),
    );
  }
}
