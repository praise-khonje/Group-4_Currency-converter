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
      theme: ThemeData.light(),
      home: SettingsPage(
        currentLanguage: _language,
        onLanguageChanged: _changeLanguage,
      ),
    );
  }
}

const List<String> languages = [
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

class SettingsPage extends StatelessWidget {
  final String currentLanguage;
  final ValueChanged<String> onLanguageChanged;

  const SettingsPage({
    super.key,
    required this.currentLanguage,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
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
            onTap: () => showDialog(
              context: context,
              builder: (context) => LanguageSelectorDialog(
                currentLanguage: currentLanguage,
                onSelected: onLanguageChanged,
              ),
            ),
          ),
          const Divider(),
          const AboutAppTile(),
        ],
      ),
    );
  }
}

class LanguageSelectorDialog extends StatefulWidget {
  final String currentLanguage;
  final ValueChanged<String> onSelected;

  const LanguageSelectorDialog({
    super.key,
    required this.currentLanguage,
    required this.onSelected,
  });

  @override
  State<LanguageSelectorDialog> createState() => _LanguageSelectorDialogState();
}

class _LanguageSelectorDialogState extends State<LanguageSelectorDialog> {
  late String selected;

  @override
  void initState() {
    super.initState();
    selected = widget.currentLanguage;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Language'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView(
          shrinkWrap: true,
          children: languages.map((lang) {
            return RadioListTile<String>(
              title: Text(lang),
              value: lang,
              groupValue: selected,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selected = value;
                  });
                }
              },
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.onSelected(selected);
            Navigator.pop(context);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}

class AboutAppTile extends StatelessWidget {
  const AboutAppTile({super.key});

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      leading: Icon(Icons.info_outline),
      title: Text('About App'),
      subtitle: Text(
        'Version 1.0.0\n'
            'Developed by group 4:\n'
            ' 1. Praise Khonje\n'
            ' 2. Joshua Chilapondwa\n'
            ' 3. Aaliyah Mbowani\n'
            ' 4. Augustine Njala\n'
            ' 5. Paul Narcisse',
      ),
      isThreeLine: true,
    );
  }
}
