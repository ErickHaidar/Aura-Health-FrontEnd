import 'package:flutter/material.dart';
import '../theme.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Pengaturan',
          style: TextStyle(
            color: AppTheme.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SwitchListTile(
            title: const Text(
              'Dark Mode',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('Ganti tema aplikasi menjadi gelap'),
            value: Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark,
            activeThumbColor: AppTheme.primaryColor,
            onChanged: (val) {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme(val);
            },
            secondary: const Icon(Icons.dark_mode_outlined),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text(
              'Notifikasi',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('Aktifkan pengingat minum obat'),
            value: _notificationsEnabled,
            activeThumbColor: AppTheme.primaryColor,
            onChanged: (val) {
              setState(() {
                _notificationsEnabled = val;
              });
            },
            secondary: const Icon(Icons.notifications_active_outlined),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text(
              'Bahasa',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: const Text(
              'Indonesia',
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text(
              'Tentang Aplikasi',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
