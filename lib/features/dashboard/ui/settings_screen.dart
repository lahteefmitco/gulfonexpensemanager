import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.account_balance_wallet),
          title: const Text('Manage Accounts'),
          onTap: () {
            Navigator.pushNamed(context, '/accounts');
          },
        ),
        ListTile(
          leading: const Icon(Icons.category),
          title: const Text('Manage Categories'),
          onTap: () {
            Navigator.pushNamed(context, '/categories');
          },
        ),
      ],
    );
  }
}
