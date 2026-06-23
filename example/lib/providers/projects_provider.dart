import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Project {
  final String id;
  final String title;
  final String shortDesc;
  final String tech;
  final String description;
  final List<String> features;
  final IconData icon;
  final String category;

  const Project({
    required this.id,
    required this.title,
    required this.shortDesc,
    required this.tech,
    required this.description,
    required this.features,
    required this.icon,
    required this.category,
  });
}

class ProjectsState {
  final List<Project> all;
  final String searchQuery;
  final String? categoryFilter;

  const ProjectsState({
    required this.all,
    this.searchQuery = '',
    this.categoryFilter,
  });

  List<Project> get filtered {
    var result = all;
    if (categoryFilter != null) {
      result = result.where((p) => p.category == categoryFilter).toList();
    }
    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      result = result
          .where((p) =>
              p.title.toLowerCase().contains(q) ||
              p.shortDesc.toLowerCase().contains(q) ||
              p.tech.toLowerCase().contains(q))
          .toList();
    }
    return result;
  }

  List<String> get categories => all.map((p) => p.category).toSet().toList()..sort();

  ProjectsState copyWith({String? searchQuery, String? Function()? categoryFilter}) {
    return ProjectsState(
      all: all,
      searchQuery: searchQuery ?? this.searchQuery,
      categoryFilter: categoryFilter != null ? categoryFilter() : this.categoryFilter,
    );
  }
}

class ProjectsNotifier extends Notifier<ProjectsState> {
  @override
  ProjectsState build() => const ProjectsState(all: _allProjects);

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setCategoryFilter(String? category) {
    state = state.copyWith(categoryFilter: () => category);
  }

  static const _allProjects = [
    Project(
      id: '1',
      title: 'E-Commerce Platform',
      shortDesc: 'A full-featured online store built with Flutter web.',
      tech: 'Flutter, Stripe, Firebase, Riverpod',
      category: 'E-Commerce',
      icon: Icons.shopping_cart,
      description:
          'This project demonstrates a complete e-commerce solution with product management, shopping cart, secure checkout via Stripe, order tracking, and an admin dashboard. Built entirely with Flutter web and SFWF for optimal SEO and performance.',
      features: [
        'Product catalog with search & filters',
        'Shopping cart & wishlist',
        'Secure Stripe checkout',
        'Admin dashboard with analytics',
        'Order management & tracking',
        'Inventory management system',
        'Customer reviews & ratings',
        'Multi-currency support',
        'Email notification system',
        'Discount & coupon engine',
      ],
    ),
    Project(
      id: '2',
      title: 'Real-Time Dashboard',
      shortDesc: 'Analytics dashboard with live data visualization.',
      tech: 'Flutter, WebSockets, Charts',
      category: 'Analytics',
      icon: Icons.dashboard,
      description:
          'A high-performance real-time dashboard capable of handling millions of data points. Features interactive charts, data tables, export functionality, and customizable widgets for enterprise monitoring.',
      features: [
        'Live WebSocket data streaming',
        'Interactive charts & graphs',
        'Data export (CSV, PDF, Excel)',
        'Customizable dashboard widgets',
        'Real-time notifications & alerts',
        'Dark & light theme support',
        'Role-based access control',
        'Historical data analysis',
        'Auto-refresh configurable intervals',
        'Responsive design for all screens',
      ],
    ),
    Project(
      id: '3',
      title: 'Social Media App',
      shortDesc: 'Social platform with real-time messaging.',
      tech: 'Flutter, GraphQL, Firebase',
      category: 'Social',
      icon: Icons.people,
      description:
          'A fully responsive social media application with news feed, stories, direct messaging, push notifications, and content moderation. Built for scale with GraphQL backend.',
      features: [
        'Algorithmic news feed',
        'Stories & media sharing',
        'Real-time direct messaging',
        'Push notifications',
        'Content moderation tools',
        'Profile management & customization',
        'Friend & follow system',
        'Image & video upload',
        'Live streaming support',
        'End-to-end encryption',
      ],
    ),
    Project(
      id: '4',
      title: 'AI Content Generator',
      shortDesc: 'Leverage AI to generate SEO-optimized content.',
      tech: 'Flutter, OpenAI, Riverpod',
      category: 'AI',
      icon: Icons.auto_awesome,
      description:
          'An intelligent content generation platform that uses OpenAI to create blog posts, social media content, marketing copy, and product descriptions with built-in SEO optimization.',
      features: [
        'AI-powered content generation',
        'SEO analysis & suggestions',
        'Multiple content templates',
        'Batch content generation',
        'Content calendar planning',
        'Team collaboration',
        'Version history & rollback',
        'Plagiarism checker integration',
        'Multi-language support',
        'Analytics & performance tracking',
      ],
    ),
    Project(
      id: '5',
      title: 'Portfolio CMS',
      shortDesc: 'Headless CMS for developer portfolios.',
      tech: 'Flutter, Supabase, Riverpod',
      category: 'CMS',
      icon: Icons.web,
      description:
          'A headless CMS designed for developers to create and manage their professional portfolio. Features a drag-and-drop builder, live preview, and automatic deployment.',
      features: [
        'Drag-and-drop page builder',
        'Live preview & editing',
        'Custom theme engine',
        'Blog & project management',
        'SEO optimization tools',
        'Analytics dashboard',
        'Custom domain support',
        'Automatic deployment',
        'Media library & optimization',
        'Export & backup',
      ],
    ),
    Project(
      id: '6',
      title: 'Task Management Tool',
      shortDesc: 'Kanban project management with collaboration.',
      tech: 'Flutter, WebRTC, Hive',
      category: 'Productivity',
      icon: Icons.checklist,
      description:
          'A comprehensive Kanban-style project management tool with real-time collaboration, file sharing, team management, and productivity analytics for modern teams.',
      features: [
        'Kanban board with drag & drop',
        'Real-time team collaboration',
        'File sharing & document management',
        'Time tracking & reporting',
        'Sprint planning & management',
        'Gantt chart view',
        'Team chat & video calls (WebRTC)',
        'Automated workflows',
        'Integration with GitHub & Slack',
        'Offline support with Hive',
      ],
    ),
  ];
}

final projectsProvider = NotifierProvider<ProjectsNotifier, ProjectsState>(ProjectsNotifier.new);

final projectByIdProvider = Provider.family<Project?, String>((ref, id) {
  final state = ref.watch(projectsProvider);
  try {
    return state.all.firstWhere((p) => p.id == id);
  } catch (_) {
    return null;
  }
});
