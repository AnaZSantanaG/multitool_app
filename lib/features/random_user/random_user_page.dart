import 'package:flutter/material.dart';

import '../../core/api_client.dart';
import '../../core/widgets/state_views.dart';
import 'random_user.dart';
import 'random_user_service.dart';

class RandomUserPage extends StatefulWidget {
  RandomUserPage({super.key, RandomUserService? service})
      : service = service ?? RandomUserService(ApiClient());

  final RandomUserService service;

  @override
  State<RandomUserPage> createState() => _RandomUserPageState();
}

class _RandomUserPageState extends State<RandomUserPage> {
  late Future<RandomUser> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.service.fetch();
  }

  void _reload() {
    setState(() {
      _future = widget.service.fetch();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Persona aleatoria')),
      body: FutureBuilder<RandomUser>(
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
          final user = snapshot.requireData;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Center(
                child: ClipOval(
                  child: Image.network(
                    user.pictureUrl,
                    width: 128,
                    height: 128,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.person, size: 128);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('Nombre'),
                      subtitle: Text(user.firstName),
                    ),
                    ListTile(
                      title: const Text('Apellido'),
                      subtitle: Text(user.lastName),
                    ),
                    ListTile(
                      title: const Text('Fecha de nacimiento'),
                      subtitle: Text(user.birthDateLabel),
                    ),
                    ListTile(
                      title: const Text('Edad'),
                      subtitle: Text('${user.age} años'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _reload,
                icon: const Icon(Icons.refresh),
                label: const Text('Otra persona'),
              ),
            ],
          );
        },
      ),
    );
  }
}
