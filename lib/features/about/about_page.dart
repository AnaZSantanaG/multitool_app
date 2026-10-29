import 'package:flutter/material.dart';

import '../../core/open_link.dart';

class AboutInfo {
  const AboutInfo({
    required this.name,
    required this.title,
    required this.email,
    required this.phone,
    required this.linkedin,
    required this.github,
  });

  final String name;
  final String title;
  final String email;
  final String phone;
  final String linkedin;
  final String github;
}

const AboutInfo aboutInfo = AboutInfo(
  name: 'Ana Z. Santana G.',
  title: 'Estudiante de desarrollo de software',
  email: '20242153@itla.edu.do',
  phone: '8099729342',
  linkedin: 'https://www.linkedin.com/in/ana-santana-60815a3aa',
  github: 'https://github.com/AnaZSantanaG',
);

class AboutPage extends StatelessWidget {
  const AboutPage({super.key, this.info = aboutInfo});

  final AboutInfo info;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Acerca de')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Center(
            child: CircleAvatar(
              radius: 72,
              backgroundImage: AssetImage('assets/me.jpeg'),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            info.name,
            textAlign: TextAlign.center,
            style: textTheme.headlineSmall,
          ),
          Text(
            info.title,
            textAlign: TextAlign.center,
            style: textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          const Text(
            'Disponible para oportunidades de trabajo.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.email_outlined),
                  title: Text(info.email),
                  onTap: () => openUri(
                    context,
                    Uri(scheme: 'mailto', path: info.email),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.phone_outlined),
                  title: Text(info.phone),
                  onTap: () => openUri(
                    context,
                    Uri(scheme: 'tel', path: info.phone),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.work_outline),
                  title: const Text('LinkedIn'),
                  subtitle: Text(info.linkedin),
                  onTap: () => openUri(context, Uri.tryParse(info.linkedin)),
                ),
                ListTile(
                  leading: const Icon(Icons.code),
                  title: const Text('GitHub'),
                  subtitle: Text(info.github),
                  onTap: () => openUri(context, Uri.tryParse(info.github)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
