import 'package:flutter/material.dart';
import 'package:gulfon_expense_manager/features/auth/ui/login_screen.dart';
import 'package:gulfon_expense_manager/features/auth/ui/signup_screen.dart';
import 'package:gulfon_expense_manager/features/accounts/ui/accounts_screen.dart';
import 'package:gulfon_expense_manager/features/categories/ui/categories_screen.dart';
import 'package:gulfon_expense_manager/features/dashboard/ui/dashboard_screen.dart';
import 'package:gulfon_expense_manager/features/reports/ui/reports_screen.dart';
import 'package:gulfon_expense_manager/features/transactions/data/models/transaction_model.dart';
import 'package:gulfon_expense_manager/features/transactions/ui/add_edit_transaction_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/signup':
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      case '/dashboard':
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case '/add_transaction':
        final transaction = settings.arguments as TransactionModel?;
        return MaterialPageRoute(
            builder: (_) => AddEditTransactionScreen(transaction: transaction));
      case '/accounts':
        return MaterialPageRoute(builder: (_) => const AccountsScreen());
      case '/categories':
        return MaterialPageRoute(builder: (_) => const CategoriesScreen());
      case '/reports':
        return MaterialPageRoute(builder: (_) => const ReportsScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
