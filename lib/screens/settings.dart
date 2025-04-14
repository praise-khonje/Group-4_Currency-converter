import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _language = 'English';

  void _changeLanguage(String newLang) {
    setState(() {
      _language = newLang;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Settings Page Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(), // Only light theme used
      home: SettingsPage(
        currentLanguage: _language,
        onLanguageChanged: _changeLanguage,
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  final String currentLanguage;
  final Function(String) onLanguageChanged;

  const SettingsPage({
    super.key,
    required this.currentLanguage,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> languages = [
      'English',
      'Spanish',
      'French',
      'German',
      'Chichewa',
      'Swahili',
      'Arabic',
      'Chinese',
      'Portuguese',
      'Hindi',
      'Zulu',
      'Afrikaans',
      'Italian',
      'Japanese',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            subtitle: Text(currentLanguage),
            onTap: () => _showLanguageDialog(context, languages),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About App'),
            subtitle: const Text('Version 1.0.0\nDeveloped by group 4:\n 1.Praise khonje\n 2.joshau chilapondwa\n 3.aaliyah mbowani\n 4. augustine njala\n 5. paul narcisse'),
            isThreeLine: true,
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, List<String> languages) {
    showDialog(
      context: context,
      builder: (context) {
        String selected = currentLanguage;
        return AlertDialog(
          title: const Text('Select Language'),
          content: StatefulBuilder(
            builder: (context, setState) => SizedBox(
              width: double.maxFinite,
              child: ListView(
                shrinkWrap: true,
                children: languages.map((lang) {
                  return RadioListTile(
                    title: Text(lang),
                    value: lang,
                    groupValue: selected,
                    onChanged: (value) {
                      setState(() {
                        selected = value!;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                onLanguageChanged(selected);
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
