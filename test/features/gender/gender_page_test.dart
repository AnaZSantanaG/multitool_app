import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:multitool_app/core/api_client.dart';
import 'package:multitool_app/features/gender/gender_page.dart';
import 'package:multitool_app/features/gender/gender_service.dart';

Widget buildPage(String body) {
  final client = MockClient((request) async => http.Response(body, 200));
  return MaterialApp(
    home: GenderPage(service: GenderService(ApiClient(client: client))),
  );
}

Future<void> predict(WidgetTester tester, String name) async {
  await tester.enterText(find.byType(TextField), name);
  await tester.tap(find.text('Predecir'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('male prediction shows blue', (tester) async {
    await tester.pumpWidget(
      buildPage('{"name":"carlos","gender":"male","probability":0.98,"count":1000}'),
    );

    await predict(tester, 'carlos');

    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
    expect(scaffold.backgroundColor, Colors.blue.shade100);
    expect(find.text('Masculino'), findsOneWidget);
  });

  testWidgets('female prediction shows pink', (tester) async {
    await tester.pumpWidget(
      buildPage('{"name":"irma","gender":"female","probability":0.99,"count":500}'),
    );

    await predict(tester, 'irma');

    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
    expect(scaffold.backgroundColor, Colors.pink.shade100);
    expect(find.text('Femenino'), findsOneWidget);
  });

  testWidgets('null gender shows a neutral state', (tester) async {
    await tester.pumpWidget(
      buildPage('{"name":"zzzq","gender":null,"probability":0,"count":0}'),
    );

    await predict(tester, 'zzzq');

    final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
    expect(scaffold.backgroundColor, isNull);
    expect(find.text('Sin predicción para este nombre.'), findsOneWidget);
  });

  testWidgets('empty name does not call the service', (tester) async {
    var calls = 0;
    final client = MockClient((request) async {
      calls++;
      return http.Response('{}', 200);
    });
    await tester.pumpWidget(
      MaterialApp(
        home: GenderPage(service: GenderService(ApiClient(client: client))),
      ),
    );

    await tester.tap(find.text('Predecir'));
    await tester.pumpAndSettle();

    expect(calls, 0);
  });
}
