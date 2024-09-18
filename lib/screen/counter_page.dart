import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/bloc/counter_cubit.dart';
// Update this to your actual path

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController markController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance System'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // A card to display the attendance count and time
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
              color: Colors.deepPurpleAccent.shade100,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: BlocBuilder<CounterCubit, Map<String, dynamic>>(
                  builder: (context, state) => Center(
                    child: Column(
                      children: [
                        Text(
                          'Attendance Count: ${state['count']}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Attendance Time: ${state['attendanceTime']}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Input for marks with a label
            TextField(
              controller: markController,
              decoration: InputDecoration(
                labelText: 'Enter Marks',
                labelStyle: TextStyle(
                  color: Colors.deepPurple.shade700,
                  fontSize: 18,
                ),
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.school),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            // Grade Result Actions
            Expanded(
              child: Column(
                children: [
                  BlocBuilder<CounterCubit, Map<String, dynamic>>(
                    builder: (context, state) => GestureDetector(
                      child: Icon(Icons.fingerprint, size: 100, color: state['iconColor']),
                      onTap: () => context.read<CounterCubit>().present(), // Call the method to give attendance
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    child: const Icon(Icons.remove_circle, size: 50, color: Colors.red),
                    onTap: () => context.read<CounterCubit>().absent(), // Call the method to take attendance away
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    child: const Icon(Icons.grade_sharp, size: 50, color: Colors.orange),
                    onTap: () {
                      final marks = int.tryParse(markController.text) ?? 0;
                      final grade = context.read<CounterCubit>().calculateGradeLetter(marks);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Grade: $grade'),
                        backgroundColor: Colors.orangeAccent,
                      ));
                    },
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    child: const Icon(Icons.calculate, size: 50, color: Colors.blue),
                    onTap: () {
                      final marks = int.tryParse(markController.text) ?? 0;
                      final gradePoint = context.read<CounterCubit>().gradePoint(marks);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Grade Point: $gradePoint'),
                        backgroundColor: Colors.blueAccent,
                      ));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
