import 'package:flutter/material.dart';
import 'package:sfwf/sfwf.dart';

class AppLayout extends StatelessWidget {
  final Widget child;
  final String? seoTitle;

  const AppLayout({
    super.key,
    required this.child,
    this.seoTitle,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = DeviceDetector.isDesktop;
    final theme = Theme.of(context);

    return Scaffold(
      body: Row(
        children: [
          if (isDesktop)
            NavigationRail(
              selectedIndex: _currentIndex,
              onDestinationSelected: (i) => _navigateTo(context, i),
              labelType: NavigationRailLabelType.all,
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Icon(Icons.flutter_dash,
                    size: 40, color: theme.colorScheme.primary),
              ),
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
          Expanded(
            child: Scaffold(
              appBar: isDesktop
                  ? null
                  : AppBar(
                      title: Text(
                        _titleForIndex(_currentIndex),
                      ),
                      leading: Builder(
                        builder: (ctx) => IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: () => Scaffold.of(ctx).openDrawer(),
                        ),
                      ),
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
                              Icons.home, 'Home', '/', context, _currentIndex),
                          _drawerItem(Icons.folder, 'Projects', '/projects',
                              context, _currentIndex),
                          _drawerItem(Icons.article, 'Blog', '/blog', context,
                              _currentIndex),
                          _drawerItem(Icons.mail, 'Contact', '/contact',
                              context, _currentIndex),
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

  int get _currentIndex {
    final path = _currentPath;
    if (path.startsWith('/projects')) return 1;
    if (path.startsWith('/blog')) return 2;
    if (path.startsWith('/contact')) return 3;
    return 0;
  }

  String get _currentPath {
    final uri = Uri.base;
    return uri.path;
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
    Navigator.pushNamedAndRemoveUntil(context, routes[index], (_) => false);
  }
}

Widget _drawerItem(
    IconData icon, String label, String route, BuildContext context, int currentIndex) {
  final isSelected = currentIndex == _indexForRoute(route);
  return ListTile(
    leading: Icon(icon),
    title: Text(label),
    selected: isSelected,
    onTap: () {
      Navigator.pop(context);
      Navigator.pushNamedAndRemoveUntil(context, route, (_) => false);
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
