import 'package:flutter/material.dart';

// Main function to start the app
void main() {
  runApp(const GPACalculatorApp());
}

// Main App Widget
class GPACalculatorApp extends StatelessWidget {
  const GPACalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPA Calculator',
      theme: ThemeData(primarySwatch: Colors.blue), // Setting theme color
      home: const InputScreen(), // First screen user interacts with
    );
  }
}

// Stateful widget for the input screen
class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  InputScreenState createState() => InputScreenState();
}

class InputScreenState extends State<InputScreen> {
  // Controllers for input fields
  List<TextEditingController> courseControllers = [];
  List<TextEditingController> creditControllers = [];
  List<String> selectedGrades = [];

  // List of grade options
  final List<String> gradeOptions = [
    'A+',
    'A',
    'A-',
    'B+',
    'B',
    'B-',
    'C+',
    'C',
    'C-',
    'D+',
    'D',
    'E'
  ];

  @override
  void initState() {
    super.initState();
    addNewSubject(); // Start with one subject by default
  }

  // Function to add a new subject input field
  void addNewSubject() {
    setState(() {
      courseControllers.add(TextEditingController());
      creditControllers.add(TextEditingController());
      selectedGrades.add(gradeOptions[0]); // Default grade is 'A+'
    });
  }

  // Function to remove a subject input field
  void removeSubject(int index) {
    setState(() {
      courseControllers.removeAt(index);
      creditControllers.removeAt(index);
      selectedGrades.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GPA Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            for (int i = 0; i < courseControllers.length; i++)
              subjectInputField(i), // Generates input fields dynamically
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: addNewSubject, // Adds a new subject field
              child: const Text('Add Subject'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the result screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ResultScreen(courseControllers,
                          creditControllers, selectedGrades)),
                );
              },
              child: const Text('Calculate GPA'),
            ),
          ],
        ),
      ),
    );
  }

  // Widget to create input fields for each subject
  Widget subjectInputField(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Subject ${index + 1}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            if (courseControllers.length > 1)
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => removeSubject(index), // Remove subject
              ),
          ],
        ),
        TextField(
          controller: courseControllers[index],
          decoration: const InputDecoration(labelText: 'Course Name'),
        ),
        TextField(
          controller: creditControllers[index],
          decoration: const InputDecoration(labelText: 'Credit'),
          keyboardType: TextInputType.number,
        ),
        DropdownButton<String>(
          value: selectedGrades[index],
          items: gradeOptions.map((String grade) {
            return DropdownMenuItem<String>(
              value: grade,
              child: Text(grade),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedGrades[index] = newValue!;
            });
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

// Result screen to display the calculated GPA
class ResultScreen extends StatelessWidget {
  final List<TextEditingController> courseControllers;
  final List<TextEditingController> creditControllers;
  final List<String> selectedGrades;

  const ResultScreen(
      this.courseControllers, this.creditControllers, this.selectedGrades,
      {super.key});

  // Grade point mapping
  static const Map<String, double> gradePoints = {
    'A+': 4.0,
    'A': 4.0,
    'A-': 3.7,
    'B+': 3.3,
    'B': 3.0,
    'B-': 2.7,
    'C+': 2.3,
    'C': 2.0,
    'C-': 1.7,
    'D+': 1.3,
    'D': 1.0,
    'E': 0.0
  };

  // Function to calculate GPA
  double calculateGPA() {
    double totalPoints = 0.0;
    double totalCredits = 0.0;

    for (int i = 0; i < courseControllers.length; i++) {
      double credits = double.tryParse(creditControllers[i].text) ?? 0.0;
      double gradePoint = gradePoints[selectedGrades[i]] ?? 0.0;
      totalPoints += credits * gradePoint;
      totalCredits += credits;
    }

    return totalCredits > 0 ? (totalPoints / totalCredits) : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    double gpa = calculateGPA(); // Get calculated GPA

    return Scaffold(
      appBar: AppBar(title: const Text('GPA Result')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Your GPA: ${gpa.toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Go back to input screen
              },
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
