import 'package:flutter/material.dart';

import '../../core/api_client.dart';
import '../../core/open_link.dart';
import '../../core/widgets/state_views.dart';
import 'wp_post.dart';
import 'wp_service.dart';

const String _logoUrl =
    'https://egehid.gob.do/wp-content/uploads/2025/12/logo-scaled.jpg';
const String _fallbackLogoUrl =
    'https://egehid.gob.do/wp-content/uploads/2025/07/cropped-Logo-EGEHID-270x270.png';

class WordPressPage extends StatefulWidget {
  WordPressPage({super.key, WpService? service})
      : service = service ?? WpService(ApiClient());

  final WpService service;

  @override
  State<WordPressPage> createState() => _WordPressPageState();
}

class _WordPressPageState extends State<WordPressPage> {
  late Future<List<WpPost>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.service.latestPosts();
  }

  void _reload() {
    setState(() {
      _future = widget.service.latestPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Noticias EGEHID')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Center(child: _SiteLogo()),
          const SizedBox(height: 24),
          Text(
            'Últimas noticias',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          FutureBuilder<List<WpPost>>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const LoadingView();
              }
              if (snapshot.hasError) {
                return ErrorView(
                  message: errorMessage(snapshot.error),
                  onRetry: _reload,
                );
              }
              final posts = snapshot.data ?? const <WpPost>[];
              if (posts.isEmpty) {
                return const EmptyView(
                  message: 'No hay noticias disponibles.',
                );
              }
              return Column(
                children: [for (final post in posts) _PostCard(post: post)],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SiteLogo extends StatelessWidget {
  const _SiteLogo();

  @override
  Widget build(BuildContext context) {
    return Image.network(
      _logoUrl,
      height: 100,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Image.network(
          _fallbackLogoUrl,
          height: 100,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.public, size: 64);
          },
        );
      },
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({required this.post});

  final WpPost post;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(post.excerpt, maxLines: 5, overflow: TextOverflow.ellipsis),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => openUri(context, Uri.tryParse(post.link)),
                icon: const Icon(Icons.open_in_new),
                label: const Text('Visitar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
