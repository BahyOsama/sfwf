import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sfwf/sfwf.dart';
import '../providers/providers.dart';
import '../widgets/layout.dart';

class ProjectsPage extends ConsumerWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(projectsProvider);
    final isDesktop = DeviceDetector.isDesktop;
    final theme = Theme.of(context);

    SeoController.of(context).updatePage(const SeoData(
      title: 'Projects - SFWF Showcase',
      description:
          'Explore amazing Flutter web projects built with Smart Flutter Web Framework. E-commerce, dashboards, AI apps, and more.',
      keywords: 'Flutter projects, web apps, portfolio, Flutter showcase',
      ogType: 'website',
    ));

    return AppLayout(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 80 : 24,
          vertical: 48,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Our Projects',
                style: TextStyle(
                  fontSize: isDesktop ? 36 : 28,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 8),
            Text(
              'Real-world Flutter web applications built with SFWF',
              style: TextStyle(
                fontSize: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            _SearchFilterBar(
              searchQuery: state.searchQuery,
              categories: state.categories,
              selectedCategory: state.categoryFilter,
              onSearchChanged: (q) => ref.read(projectsProvider.notifier).setSearchQuery(q),
              onCategoryChanged: (c) => ref.read(projectsProvider.notifier).setCategoryFilter(c),
            ),
            const SizedBox(height: 32),
            if (state.filtered.isEmpty)
              _EmptyState(query: state.searchQuery)
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isDesktop ? 3 : 1,
                  childAspectRatio: isDesktop ? 1.0 : 1.2,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                ),
                itemCount: state.filtered.length,
                itemBuilder: (ctx, i) => _ProjectCard(state.filtered[i]),
              ),
          ],
        ),
      ),
    );
  }
}

class _SearchFilterBar extends StatelessWidget {
  final String searchQuery;
  final List<String> categories;
  final String? selectedCategory;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String?> onCategoryChanged;

  const _SearchFilterBar({
    required this.searchQuery,
    required this.categories,
    this.selectedCategory,
    required this.onSearchChanged,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = DeviceDetector.isDesktop;
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: 'Search projects...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          onChanged: onSearchChanged,
        ),
        if (isDesktop) ...[
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChip('All', null, selectedCategory, onCategoryChanged),
                ...categories.map((c) => Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: _FilterChip(c, c, selectedCategory, onCategoryChanged),
                    )),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final String? value;
  final String? selectedCategory;
  final ValueChanged<String?> onChanged;

  const _FilterChip(this.label, this.value, this.selectedCategory, this.onChanged);

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedCategory == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onChanged(isSelected ? null : value),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final Project project;
  const _ProjectCard(this.project);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, '/projects/${project.id}'),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(project.icon, size: 32, color: theme.colorScheme.primary),
                  const Spacer(),
                  Icon(Icons.arrow_forward,
                      size: 20, color: theme.colorScheme.onSurfaceVariant),
                ],
              ),
              const SizedBox(height: 16),
              Text(project.title,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 8),
              Expanded(
                child: Text(project.shortDesc,
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis),
              ),
              const SizedBox(height: 12),
              Chip(
                label: Text(project.category, style: const TextStyle(fontSize: 11)),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String query;
  const _EmptyState({required this.query});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 64),
        child: Column(
          children: [
            Icon(Icons.search_off, size: 80, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(height: 16),
            Text('No projects found',
                style: TextStyle(fontSize: 20, color: theme.colorScheme.onSurfaceVariant)),
            const SizedBox(height: 8),
            Text('No results for "$query"',
                style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}
