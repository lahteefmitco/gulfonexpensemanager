import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gulfon_expense_manager/features/auth/logic/auth_cubit.dart';
import 'package:gulfon_expense_manager/features/dashboard/ui/dashboard_summary.dart';
import 'package:gulfon_expense_manager/features/dashboard/ui/settings_screen.dart';
import 'package:gulfon_expense_manager/features/reports/ui/reports_screen.dart';
import 'package:gulfon_expense_manager/features/transactions/ui/transaction_list_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardSummary(),
    const TransactionListScreen(),
    const ReportsScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          // Web / Tablet View (Left Navigation Drawer)
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (int index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  labelType: NavigationRailLabelType.all,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.dashboard),
                      label: Text('Dashboard'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.list),
                      label: Text('Transactions'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.bar_chart),
                      label: Text('Reports'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.settings),
                      label: Text('Settings'),
                    ),
                  ],
                  trailing: IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () {
                      context.read<AuthCubit>().logout();
                      Navigator.pushReplacementNamed(context, '/');
                    },
                  ),
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(
                  child: _pages[_selectedIndex],
                ),
              ],
            ),
          );
        } else {
          // Mobile View (Bottom Navigation Bar)
          return Scaffold(
            appBar: AppBar(
              title: const Text('Expense Manager'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    context.read<AuthCubit>().logout();
                    Navigator.pushReplacementNamed(context, '/');
                  },
                ),
              ],
            ),
            body: _pages[_selectedIndex],
            bottomNavigationBar: NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.dashboard),
                  label: 'Dashboard',
                ),
                NavigationDestination(
                  icon: Icon(Icons.list),
                  label: 'Transactions',
                ),
                NavigationDestination(
                  icon: Icon(Icons.bar_chart),
                  label: 'Reports',
                ),
                NavigationDestination(
                  icon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
