import 'package:flutter/material.dart';
import 'package:webspark_test/screens/result_screen.dart';
import 'package:webspark_test/services/api_service.dart';
import 'package:webspark_test/services/path_calculator.dart';
import 'package:webspark_test/styles/app_button_styles.dart';
import 'package:webspark_test/styles/app_text_styles.dart';
import 'package:webspark_test/styles/app_strings.dart';

class ProcessScreen extends StatefulWidget {
  final String apiUrl;

  const ProcessScreen({super.key, required this.apiUrl});

  @override
  _ProcessScreenState createState() => _ProcessScreenState();
}

class _ProcessScreenState extends State<ProcessScreen> {
  bool _isCalculating = false;
  bool _isSendingResults = false;
  double _progress = 0.0;
  List<dynamic> _tasks = [];
  List<Map<String, dynamic>> _results = [];
  String _errorMessage = '';
  final ApiService _apiService = ApiService();
  final PathCalculator _pathCalculator = PathCalculator();

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    setState(() {
      _isCalculating = true;
      _errorMessage = '';
    });

    try {
      final tasks = await _apiService.fetchTasks(widget.apiUrl);
      setState(() {
        _tasks = tasks;
      });
      await _calculateShortestPaths();
    } catch (e) {
      setState(() {
        _errorMessage = '${AppStrings.errorPrefix}$e';
        _isCalculating = false;
      });
    }
  }

  Future<void> _calculateShortestPaths() async {
    _results.clear();
    for (int i = 0; i < _tasks.length; i++) {
      try {
        final result = await _pathCalculator.calculateShortestPath(_tasks[i]);
        _results.add(result);
      } catch (e) {
        setState(() {
          _errorMessage += '${AppStrings.errorPrefix}in task ${i + 1}: $e\n';
        });
      }
      setState(() {
        _progress = (i + 1) / _tasks.length;
      });
    }
    setState(() {
      _isCalculating = false;
      _progress = 1.0;
    });
  }

  Future<void> _sendResults() async {
    setState(() {
      _isSendingResults = true;
    });

    try {
      await _apiService.sendResults(widget.apiUrl, _results);
      setState(() {
        _isSendingResults = false;
      });

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ResultsScreen(
            results: _results,
            tasks: _tasks,
          ),
        ),
      );
    } catch (e) {
      setState(() {
        _errorMessage = '${AppStrings.errorPrefix}$e';
        _isSendingResults = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.processScreenTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _errorMessage.isNotEmpty
            ? Center(
                child: Text(
                  _errorMessage,
                  style: AppTextStyles.errorText,
                  textAlign: TextAlign.center,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _isCalculating
                              ? AppStrings.calculatingPaths
                              : AppStrings.allCalculationsFinished,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          '${(_progress * 100).toInt()}%',
                          style: AppTextStyles.progressText,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 5),
                        CircularProgressIndicator(
                          value: _progress,
                          strokeWidth: 10,
                        ),
                      ],
                    ),
                  ),
                  if (!_isCalculating)
                    ElevatedButton(
                      onPressed: _isSendingResults ? null : _sendResults,
                      style: AppButtonStyles.elevatedButtonStyle,
                      child: _isSendingResults
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(AppStrings.sendResultsButton, style: AppTextStyles.buttonText),
                    ),
                ],
              ),
      ),
    );
  }
}
