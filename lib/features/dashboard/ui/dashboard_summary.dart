import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gulfon_expense_manager/features/auth/logic/auth_cubit.dart';
import 'package:gulfon_expense_manager/features/auth/logic/auth_state.dart';
import 'package:gulfon_expense_manager/features/transactions/logic/transaction_cubit.dart';
import 'package:sizer/sizer.dart';

class DashboardSummary extends StatefulWidget {
  const DashboardSummary({super.key});

  @override
  State<DashboardSummary> createState() => _DashboardSummaryState();
}

class _DashboardSummaryState extends State<DashboardSummary> {
  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      context.read<TransactionCubit>().loadTransactions(authState.user.$id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionCubit, TransactionState>(
      builder: (context, state) {
        double totalIncome = 0;
        double totalExpense = 0;

        if (state is TransactionLoaded) {
          for (var transaction in state.transactions) {
            if (transaction.type == 'Income') {
              totalIncome += transaction.amount;
            } else if (transaction.type == 'Expense') {
              totalExpense += transaction.amount;
            }
          }
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dashboard',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: 2.h),
              Row(
                children: [
                  Expanded(
                    child: _SummaryCard(
                      title: 'Income',
                      amount: totalIncome,
                      color: Colors.green,
                      icon: Icons.arrow_downward,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: _SummaryCard(
                      title: 'Expense',
                      amount: totalExpense,
                      color: Colors.red,
                      icon: Icons.arrow_upward,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              _SummaryCard(
                title: 'Balance',
                amount: totalIncome - totalExpense,
                color: (totalIncome - totalExpense) >= 0
                    ? Colors.blue
                    : Colors.orange,
                icon: Icons.account_balance_wallet,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final double amount;
  final Color color;
  final IconData icon;

  const _SummaryCard({
    required this.title,
    required this.amount,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30.sp),
            SizedBox(height: 1.h),
            Text(
              title,
              style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
            ),
            SizedBox(height: 0.5.h),
            Text(
              '\$${amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
