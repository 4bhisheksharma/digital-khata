import 'package:flutter/material.dart';
import '../utils/nepali_strings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(NepaliStrings.settings), elevation: 0),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSettingGroup(
            context,
            title: NepaliStrings.businessSettings,
            children: [
              ListTile(
                leading: const Icon(Icons.business),
                title: Text(NepaliStrings.businessName),
                subtitle: const Text('Digital खाता'),
                onTap: () {
                  // TODO: Implement business name change
                },
              ),
              ListTile(
                leading: const Icon(Icons.location_on),
                title: Text(NepaliStrings.businessAddress),
                subtitle: const Text('काठमाडौं, नेपाल'),
                onTap: () {
                  // TODO: Implement address change
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSettingGroup(
            context,
            title: NepaliStrings.appSettings,
            children: [
              SwitchListTile(
                secondary: const Icon(Icons.notifications),
                title: Text(NepaliStrings.notifications),
                value: true, // TODO: Implement notification settings
                onChanged: (value) {
                  // TODO: Implement notification toggle
                },
              ),
              ListTile(
                leading: const Icon(Icons.backup),
                title: Text(NepaliStrings.backupData),
                subtitle: Text(NepaliStrings.lastBackup),
                onTap: () {
                  // TODO: Implement backup
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSettingGroup(
            context,
            title: NepaliStrings.about,
            children: [
              ListTile(
                leading: const Icon(Icons.info),
                title: Text(NepaliStrings.version),
                subtitle: const Text('1.0.0'),
              ),
              ListTile(
                leading: const Icon(Icons.privacy_tip),
                title: Text(NepaliStrings.privacy),
                onTap: () {
                  // TODO: Show privacy policy
                },
              ),
              ListTile(
                leading: const Icon(Icons.help),
                title: Text(NepaliStrings.help),
                onTap: () {
                  // TODO: Show help/documentation
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingGroup(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Card(child: Column(children: children)),
      ],
    );
  }
}
