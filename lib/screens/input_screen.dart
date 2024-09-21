import 'package:flutter/material.dart';
import 'package:webspark_test/screens/task_screen.dart';
import 'package:webspark_test/styles/app_button_styles.dart';
import 'package:webspark_test/styles/app_text_styles.dart';
import 'package:webspark_test/styles/app_strings.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<InputScreen> {
  final TextEditingController _urlController = TextEditingController();
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.mainScreenTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: AppStrings.apiUrlLabel,
                errorText: _errorMessage.isEmpty ? null : _errorMessage,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (Uri.tryParse(_urlController.text)?.hasAbsolutePath ?? false) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProcessScreen(apiUrl: _urlController.text),
                    ),
                  );
                } else {
                  setState(() {
                    _errorMessage = AppStrings.invalidUrlError;
                  });
                }
              },
              style: AppButtonStyles.elevatedButtonStyle,
              child: const Text(AppStrings.startButton, style: AppTextStyles.buttonText),
            ),
          ],
        ),
      ),
    );
  }
}
