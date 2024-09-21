import 'package:flutter/material.dart';
import 'package:webspark_test/widgets/path_preview_widget.dart';
import 'package:webspark_test/styles/app_strings.dart';

class ResultDetailScreen extends StatelessWidget {
  final Map<String, dynamic> result;
  final dynamic task;

  const ResultDetailScreen({super.key, required this.result, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.pathDetailsTitle),
      ),
      body: SingleChildScrollView(
        child: PathPreviewWidget(
          grid: (task['field'] as List<dynamic>)
              .map((row) => (row as String).split('').toList())
              .toList(),
          path: (result['result']['steps'] as List<dynamic>)
              .map((step) => {'x': step['x'] as int, 'y': step['y'] as int})
              .toList(),
          start: {
            'x': task['start']['x'] as int,
            'y': task['start']['y'] as int,
          },
          end: {
            'x': task['end']['x'] as int,
            'y': task['end']['y'] as int,
          },
        ),
      ),
    );
  }
}