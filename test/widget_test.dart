import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gpa_calculator/main.dart';

void main() {
  testWidgets('GPA Calculator UI Test', (WidgetTester tester) async {
    await tester.pumpWidget(GPACalculatorApp());
    expect(find.text('GPA Calculator'), findsOneWidget);
  });
}
