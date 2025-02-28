import 'package:flutter_test/flutter_test.dart';
import 'package:gpa_calculator/main.dart'; // Importing the main app file

void main() {
  // Test case for checking UI elements in the GPA Calculator app
  testWidgets('GPA Calculator UI Test', (WidgetTester tester) async {
    await tester.pumpWidget(
        GPACalculatorApp()); // Load the app into the test environment
    expect(find.text('GPA Calculator'),
        findsOneWidget); // Check if 'GPA Calculator' text appears in the UI
  });
}
