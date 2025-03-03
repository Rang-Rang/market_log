import 'package:admin_app/core/constant.dart';
import 'package:admin_app/core/notifier.dart';
import 'package:admin_app/presentation/views/home_page.dart';
import 'package:admin_app/presentation/views/settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isDark = prefs.getBool('isDarkMode') ?? false;
  final fontSize = prefs.getDouble('fontSize') ?? 16; 
  runApp(MainApp(isDark: isDark, fontSize: fontSize));
}

class MainApp extends StatefulWidget {
  final bool isDark;
  final double fontSize;

  const MainApp({super.key, required this.isDark, required this.fontSize});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
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
  }

  void updateFontSize(double newSize) {
    setState(() {
      fontSize = newSize;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins',
        textTheme: TextTheme(
          bodyMedium: TextStyle(fontSize: fontSize),
          titleLarge: TextStyle(fontSize: fontSize + 4),
          titleMedium: TextStyle(fontSize: fontSize + 2),
          bodySmall: TextStyle(fontSize: fontSize - 2),
          labelMedium: TextStyle(fontSize: fontSize - 2),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: ColorKey.seedColor,
          brightness: isDarkMode ? Brightness.dark : Brightness.light,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Market log'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: ValueListenableBuilder(
                valueListenable: isListViews,
                builder: (context, value, child) {
                  return IconButton(
                    onPressed: () {
                      isListViews.value = !isListViews.value;
                    },
                    icon: listViews,
                  );
                },
              ),
            ),
          ],
        ),
        body: HomePage(),
        drawer: Drawer(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Builder(
                    builder: (context) => ListTile(
                      title: Text(
                        'Home',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      onTap: () {
                        Scaffold.of(context).closeDrawer();
                      },
                    ),
                  ),
                  Builder(
                    builder: (context) => ListTile(
                      title: Text(
                        'Settings',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingsPage(
                              isDark: isDarkMode,
                              onThemeChanged: toggleTheme,
                              fontSize: fontSize,
                              onFontSizeChanged: updateFontSize,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<bool> getThemePref() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isDarkMode') ?? false;
}
