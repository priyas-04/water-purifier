import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../providers/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _emailUpdates = true;
  bool _locationAccess = true;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('App Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Display & Appearance', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: SwitchListTile(
              secondary: const Icon(Icons.dark_mode_outlined, color: AppConstants.primaryBlue),
              title: const Text('Dark Mode', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              subtitle: const Text('Toggle between sleek dark and crisp light themes', style: TextStyle(fontSize: 12)),
              value: themeProvider.isDarkMode,
              onChanged: (_) => themeProvider.toggleTheme(),
            ),
          ),
          const SizedBox(height: 24),

          const Text('Notification Preferences', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.notifications_active_outlined, color: AppConstants.primaryBlue),
                  title: const Text('Push Alerts', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  subtitle: const Text('Order tracking and service scheduling notifications', style: TextStyle(fontSize: 12)),
                  value: _pushNotifications,
                  onChanged: (val) => setState(() => _pushNotifications = val),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.email_outlined, color: AppConstants.primaryBlue),
                  title: const Text('Email Receipts & Invoices', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  subtitle: const Text('Receive GST tax invoices for warranty records', style: TextStyle(fontSize: 12)),
                  value: _emailUpdates,
                  onChanged: (val) => setState(() => _emailUpdates = val),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.location_on_outlined, color: AppConstants.primaryBlue),
                  title: const Text('Location Geocoding', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  subtitle: const Text('Use OpenStreetMap for technician dispatch location', style: TextStyle(fontSize: 12)),
                  value: _locationAccess,
                  onChanged: (val) => setState(() => _locationAccess = val),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          const Text('About & Legal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: const Column(
              children: [
                ListTile(
                  title: Text('Application Version', style: TextStyle(fontSize: 14)),
                  trailing: Text('1.0.0 (Build 2026.10)', style: TextStyle(color: Colors.grey, fontSize: 13)),
                ),
                Divider(height: 1),
                ListTile(
                  title: Text('Terms of Service', style: TextStyle(fontSize: 14)),
                  trailing: Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                ),
                Divider(height: 1),
                ListTile(
                  title: Text('Privacy Policy', style: TextStyle(fontSize: 14)),
                  trailing: Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
