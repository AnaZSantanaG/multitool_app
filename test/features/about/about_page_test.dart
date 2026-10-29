import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multitool_app/features/about/about_page.dart';

void main() {
  testWidgets('shows the photo and the contact data', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: AboutPage()));
    await tester.pump();

    expect(find.byType(CircleAvatar), findsOneWidget);
    expect(find.text(aboutInfo.name), findsOneWidget);
    expect(find.text(aboutInfo.email), findsOneWidget);
    expect(find.text(aboutInfo.phone), findsOneWidget);
    expect(find.text('LinkedIn'), findsOneWidget);
    expect(find.text('GitHub'), findsOneWidget);
  });
}
