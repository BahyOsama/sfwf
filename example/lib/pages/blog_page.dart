import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sfwf/sfwf.dart';
import '../providers/providers.dart';
import '../widgets/layout.dart';

class BlogPage extends ConsumerWidget {
  const BlogPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(blogProvider);
    final isDesktop = DeviceDetector.isDesktop;
    final theme = Theme.of(context);

    SeoController.of(context).updatePage(const SeoData(
      title: 'Blog - SFWF Showcase',
      description:
          'Tutorials and guides about Flutter web development, SEO, PWA, performance optimization, and the Smart Flutter Web Framework.',
      keywords: 'Flutter blog, web development tutorials, Flutter SEO, PWA Flutter',
      ogType: 'blog',
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
            Text('Latest Articles',
                style: TextStyle(
                  fontSize: isDesktop ? 36 : 28,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 8),
            Text(
              'Tutorials, guides, and insights about Flutter web development',
              style: TextStyle(
                fontSize: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            _BlogSearchFilterBar(
              searchQuery: state.searchQuery,
              categories: state.categories,
              selectedCategory: state.categoryFilter,
              onSearchChanged: (q) => ref.read(blogProvider.notifier).setSearchQuery(q),
              onCategoryChanged: (c) => ref.read(blogProvider.notifier).setCategoryFilter(c),
            ),
            const SizedBox(height: 32),
            if (state.filtered.isEmpty)
              _EmptyBlogState(query: state.searchQuery)
            else
              ...state.filtered.map((post) => _BlogCard(post)),
          ],
        ),
      ),
    );
  }
}

class _BlogSearchFilterBar extends StatelessWidget {
  final String searchQuery;
  final List<String> categories;
  final String? selectedCategory;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String?> onCategoryChanged;

  const _BlogSearchFilterBar({
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
            hintText: 'Search articles...',
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
                _BlogFilterChip('All', null, selectedCategory, onCategoryChanged),
                ...categories.map((c) => Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: _BlogFilterChip(c, c, selectedCategory, onCategoryChanged),
                    )),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _BlogFilterChip extends StatelessWidget {
  final String label;
  final String? value;
  final String? selectedCategory;
  final ValueChanged<String?> onChanged;

  const _BlogFilterChip(this.label, this.value, this.selectedCategory, this.onChanged);

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

class _BlogCard extends StatelessWidget {
  final BlogPost post;
  const _BlogCard(this.post);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.pushNamed(context, '/blog/${post.slug}'),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(post.icon, color: theme.colorScheme.primary),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Chip(
                          label: Text(post.category,
                              style: const TextStyle(fontSize: 11)),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        ),
                        const SizedBox(width: 8),
                        Text(post.readTime,
                            style: TextStyle(
                              fontSize: 13,
                              color: theme.colorScheme.onSurfaceVariant,
                            )),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(post.title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(post.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyBlogState extends StatelessWidget {
  final String query;
  const _EmptyBlogState({required this.query});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 64),
        child: Column(
          children: [
            Icon(Icons.article, size: 80, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(height: 16),
            Text('No articles found',
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
