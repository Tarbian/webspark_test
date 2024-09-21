import 'package:flutter/material.dart';
import 'result_detail_screen.dart';
import 'package:webspark_test/styles/app_strings.dart';

class ResultsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> results;
  final List<dynamic> tasks;

  const ResultsScreen({super.key, required this.results, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.taskResultsTitle),
      ),
      body: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          final result = results[index];
          return ListTile(
            title: Text('Path ${index + 1}: ${result['result']['path']}'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ResultDetailScreen(
                    result: result,
                    task: tasks[index],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}