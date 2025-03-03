import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  final bool isDark;
  final double fontSize;
  final VoidCallback onThemeChanged;
  final ValueChanged<double> onFontSizeChanged;

  const SettingsPage({
    super.key,
    required this.isDark,
    required this.fontSize,
    required this.onThemeChanged,
    required this.onFontSizeChanged,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool isDarkMode;
  late double fontSize;

  @override
  void initState() {
    super.initState();
    isDarkMode = widget.isDark;
    fontSize = widget.fontSize;
  }

  void toggleTheme() async {
    setState(() {
      isDarkMode = !isDarkMode;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);

    widget.onThemeChanged();
  }

  void updateFontSize(double newSize) async {
    setState(() {
      fontSize = newSize;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSize', fontSize);
    widget.onFontSizeChanged(fontSize);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              leading: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
              title: Text(
                isDarkMode ? "Dark mode" : "Light mode",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              onTap: toggleTheme,
            ),
          ),

          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Font Size: ${fontSize.toInt()}",
                  style: TextStyle(fontSize: fontSize)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Slider(
              value: fontSize,
              min: 16,
              max: 24,
              divisions: 8,
              label: fontSize.toInt().toString(),
              onChanged: updateFontSize,
            ),
          ),
        ],
      ),
    );
  }
}
