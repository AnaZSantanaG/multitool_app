import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multitool_app/features/home/home_page.dart';

void main() {
  testWidgets('shows the toolbox image and the title', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: HomePage(entries: const [])),
    );
    await tester.pump();

    expect(find.byType(Image), findsOneWidget);
    expect(find.text('Caja de herramientas'), findsOneWidget);
    expect(find.byType(ListTile), findsNothing);
  });

  testWidgets('lists the entries and navigates on tap', (tester) async {
    final entries = [
      ToolEntry(
        title: 'Herramienta de prueba',
        icon: Icons.build,
        builder: (_) => const Scaffold(body: Text('Pantalla destino')),
      ),
    ];

    await tester.pumpWidget(MaterialApp(home: HomePage(entries: entries)));
    await tester.pump();

    expect(find.text('Herramienta de prueba'), findsOneWidget);

    await tester.tap(find.text('Herramienta de prueba'));
    await tester.pumpAndSettle();

    expect(find.text('Pantalla destino'), findsOneWidget);
  });
}
