import 'package:flutter/material.dart';

import '../../core/api_client.dart';
import '../../core/open_link.dart';
import '../../core/widgets/state_views.dart';
import 'university.dart';
import 'university_service.dart';

class UniversitiesPage extends StatefulWidget {
  UniversitiesPage({super.key, UniversityService? service})
      : service = service ?? UniversityService(ApiClient());

  final UniversityService service;

  @override
  State<UniversitiesPage> createState() => _UniversitiesPageState();
}

class _UniversitiesPageState extends State<UniversitiesPage> {
  final TextEditingController _controller = TextEditingController();
  Future<List<University>>? _future;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _search() {
    final country = _controller.text.trim();
    if (country.isEmpty) {
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() {
      _future = widget.service.byCountry(country);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Universidades por país')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) => _search(),
                    decoration: const InputDecoration(
                      labelText: 'País (en inglés)',
                      hintText: 'Dominican Republic',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _search,
                  icon: const Icon(Icons.search),
                  tooltip: 'Buscar',
                ),
              ],
            ),
          ),
          Expanded(child: _buildResults()),
        ],
      ),
    );
  }

  Widget _buildResults() {
    final future = _future;
    if (future == null) {
      return const EmptyView(
        message: 'Escribe el nombre de un país en inglés para ver sus universidades.',
      );
    }
    return FutureBuilder<List<University>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const LoadingView();
        }
        if (snapshot.hasError) {
          return ErrorView(
            message: errorMessage(snapshot.error),
            onRetry: _search,
          );
        }
        final universities = snapshot.data ?? const <University>[];
        if (universities.isEmpty) {
          return const EmptyView(
            message: 'No se encontraron universidades para ese país.',
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          itemCount: universities.length,
          itemBuilder: (context, index) {
            return _UniversityCard(university: universities[index]);
          },
        );
      },
    );
  }
}

class _UniversityCard extends StatelessWidget {
  const _UniversityCard({required this.university});

  final University university;

  @override
  Widget build(BuildContext context) {
    final domains = university.domains.isEmpty
        ? 'no disponible'
        : university.domains.join(', ');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              university.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text('Dominio: $domains'),
            if (university.webPages.isNotEmpty)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => openUri(
                    context,
                    Uri.tryParse(university.webPages.first),
                  ),
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Visitar sitio web'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
