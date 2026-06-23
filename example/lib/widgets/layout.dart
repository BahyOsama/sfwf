import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sfwf/sfwf.dart';
import '../providers/providers.dart';

class AppLayout extends ConsumerWidget {
  final Widget child;

  const AppLayout({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDesktop = DeviceDetector.isDesktop;
    final theme = Theme.of(context);
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;
    final currentIdx = _currentIndexFor(context);

    return Scaffold(
      body: Row(
        children: [
          if (isDesktop)
            Theme(
              data: theme.copyWith(
                navigationRailTheme: NavigationRailThemeData(
                  selectedIconTheme: IconThemeData(
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                  unselectedIconTheme: IconThemeData(
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                ),
              ),
              child: NavigationRail(
                selectedIndex: currentIdx,
                onDestinationSelected: (i) => _navigateTo(context, i),
                labelType: NavigationRailLabelType.all,
                leading: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Icon(Icons.flutter_dash,
                      size: 40, color: theme.colorScheme.primary),
                ),
                trailing: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: IconButton(
                    icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                    onPressed: () => ref.read(themeModeProvider.notifier).toggle(),
                    tooltip: 'Toggle theme',
                  ),
                ),
                selectedLabelTextStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: theme.colorScheme.primary,
                ),
                unselectedLabelTextStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                indicatorColor: theme.colorScheme.primaryContainer,
                minWidth: 100,
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.home_outlined),
                    selectedIcon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.folder_outlined),
                    selectedIcon: Icon(Icons.folder),
                    label: Text('Projects'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.article_outlined),
                    selectedIcon: Icon(Icons.article),
                    label: Text('Blog'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.mail_outlined),
                    selectedIcon: Icon(Icons.mail),
                    label: Text('Contact'),
                  ),
                ],
              ),
            ),
          Expanded(
            child: Scaffold(
              appBar: isDesktop
                  ? null
                  : AppBar(
                      title: Text(
                        _titleForIndex(currentIdx),
                      ),
                      leading: Builder(
                        builder: (ctx) => IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: () => Scaffold.of(ctx).openDrawer(),
                        ),
                      ),
                      actions: [
                        IconButton(
                          icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                          onPressed: () => ref.read(themeModeProvider.notifier).toggle(),
                          tooltip: 'Toggle theme',
                        ),
                      ],
                    ),
              drawer: isDesktop
                  ? null
                  : Drawer(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          DrawerHeader(
                            decoration:
                                BoxDecoration(color: theme.colorScheme.primary),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(Icons.flutter_dash,
                                    size: 48,
                                    color: theme.colorScheme.onPrimary),
                                const SizedBox(height: 8),
                                Text('SFWF Showcase',
                                    style: TextStyle(
                                        color: theme.colorScheme.onPrimary,
                                        fontSize: 20)),
                              ],
                            ),
                          ),
                          _drawerItem(
                              Icons.home, 'Home', '/', context, currentIdx),
                          _drawerItem(Icons.folder, 'Projects', '/projects',
                              context, currentIdx),
                          _drawerItem(Icons.article, 'Blog', '/blog', context,
                              currentIdx),
                          _drawerItem(Icons.mail, 'Contact', '/contact',
                              context, currentIdx),
                        ],
                      ),
                    ),
              body: child,
            ),
          ),
        ],
      ),
    );
  }

  int _currentIndexFor(BuildContext context) {
    final routeName = ModalRoute.of(context)?.settings.name ?? '/';
    if (routeName.startsWith('/projects')) return 1;
    if (routeName.startsWith('/blog')) return 2;
    if (routeName.startsWith('/contact')) return 3;
    return 0;
  }

  String _titleForIndex(int index) {
    switch (index) {
      case 0:
        return 'Home';
      case 1:
        return 'Projects';
      case 2:
        return 'Blog';
      case 3:
        return 'Contact';
      default:
        return 'SFWF';
    }
  }

  void _navigateTo(BuildContext context, int index) {
    final routes = ['/', '/projects', '/blog', '/contact'];
    Navigator.pushNamed(context, routes[index]);
  }
}

Widget _drawerItem(
    IconData icon, String label, String route, BuildContext context, int currentIndex) {
  final isSelected = currentIndex == _indexForRoute(route);
  final theme = Theme.of(context);
  return ListTile(
    leading: Icon(icon, color: isSelected ? theme.colorScheme.primary : null),
    title: Text(label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
          color: isSelected ? theme.colorScheme.primary : null,
        )),
    selected: isSelected,
    selectedTileColor: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    onTap: () {
      Navigator.pop(context);
      Navigator.pushNamed(context, route);
    },
  );
}

int _indexForRoute(String route) {
  switch (route) {
    case '/':
      return 0;
    case '/projects':
      return 1;
    case '/blog':
      return 2;
    case '/contact':
      return 3;
    default:
      return 0;
  }
}
