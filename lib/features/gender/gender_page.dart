import 'package:flutter/material.dart';

import '../../core/api_client.dart';
import '../../core/widgets/state_views.dart';
import 'gender_result.dart';
import 'gender_service.dart';

class GenderPage extends StatefulWidget {
  GenderPage({super.key, GenderService? service})
      : service = service ?? GenderService(ApiClient());

  final GenderService service;

  @override
  State<GenderPage> createState() => _GenderPageState();
}

class _GenderPageState extends State<GenderPage> {
  final TextEditingController _controller = TextEditingController();
  GenderResult? _result;
  String? _error;
  bool _loading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _predict() async {
    final name = _controller.text.trim();
    if (name.isEmpty) {
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() {
      _loading = true;
      _error = null;
      _result = null;
    });
    try {
      final result = await widget.service.predict(name);
      if (!mounted) {
        return;
      }
      setState(() {
        _result = result;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _error = errorMessage(error);
        _loading = false;
      });
    }
  }

  Color? get _backgroundColor {
    final result = _result;
    if (result == null || !result.hasPrediction) {
      return null;
    }
    return result.isMale ? Colors.blue.shade100 : Colors.pink.shade100;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(title: const Text('Predecir género')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _predict(),
              decoration: const InputDecoration(
                labelText: 'Nombre',
                border: OutlineInputBorder(),
                filled: true,
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _loading ? null : _predict,
              icon: const Icon(Icons.search),
              label: const Text('Predecir'),
            ),
            const SizedBox(height: 24),
            Expanded(child: _buildResult()),
          ],
        ),
      ),
    );
  }

  Widget _buildResult() {
    if (_loading) {
      return const LoadingView();
    }
    final error = _error;
    if (error != null) {
      return ErrorView(message: error, onRetry: _predict);
    }
    final result = _result;
    if (result == null) {
      return const EmptyView(
        message: 'Escribe un nombre para predecir su género.',
      );
    }
    if (!result.hasPrediction) {
      return const EmptyView(message: 'Sin predicción para este nombre.');
    }

    final label = result.isMale
        ? 'Masculino'
        : (result.gender == 'female' ? 'Femenino' : result.gender!);
    final color = result.isMale ? Colors.blue : Colors.pink;
    final percent = (result.probability * 100).round();

    return Center(
      child: Card(
        color: color.shade300,
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                result.isMale ? Icons.male : Icons.female,
                size: 96,
                color: Colors.white,
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Probabilidad: $percent%',
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                'Basado en ${result.count} registros',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
