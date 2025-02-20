import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;

  void getThemeMode() async {
    // Lấy chế độ theme đã lưu
    final savedThemeMode = await AdaptiveTheme.getThemeMode();

    // Kiểm tra xem chế độ đã lưu có phải là dark mode không
    if (savedThemeMode == AdaptiveThemeMode.dark) {
      // Thiết lập isDarkMode thành true
      setState(() {
        isDarkMode = true;
      });
    } else {
      // Thiết lập isDarkMode thành false
      setState(() {
        isDarkMode = false;
      });
    }
  }

  @override
  void initState() {
    getThemeMode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          child: SwitchListTile(
            title: Text('Dark Mode'),
            value: isDarkMode,
            onChanged: (value) {
              // set the isDarkMode to the value
              setState(() {
                isDarkMode = value;
              });
              // check if the value is true
              if (value) {
                // set the theme mode to dark
                AdaptiveTheme.of(context).setDark();
              } else {
                // set the theme mode to light
                AdaptiveTheme.of(context).setLight();
              }
            },
          ),
        ),
      ),
    );
  }
}