import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gulfon_expense_manager/features/auth/logic/auth_cubit.dart';
import 'package:gulfon_expense_manager/features/auth/logic/auth_state.dart';
import 'package:gulfon_expense_manager/features/transactions/logic/transaction_cubit.dart';
import 'package:sizer/sizer.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
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
    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: BlocBuilder<TransactionCubit, TransactionState>(
        builder: (context, state) {
          if (state is TransactionLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TransactionLoaded) {
            if (state.transactions.isEmpty) {
              return const Center(child: Text('No transactions found.'));
            }

            // Calculate totals
            double totalIncome = 0;
            double totalExpense = 0;
            Map<String, double> categoryExpenses = {};

            for (var transaction in state.transactions) {
              if (transaction.type == 'Income') {
                totalIncome += transaction.amount;
              } else if (transaction.type == 'Expense') {
                totalExpense += transaction.amount;
                categoryExpenses.update(
                  transaction
                      .categoryId, // Using ID for now, ideally map to Name
                  (value) => value + transaction.amount,
                  ifAbsent: () => transaction.amount,
                );
              }
            }

            return SingleChildScrollView(
              padding: EdgeInsets.all(5.w),
              child: Column(
                children: [
                  Text(
                    'Income vs Expense',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(
                    height: 30.h,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: (totalIncome > totalExpense
                                ? totalIncome
                                : totalExpense) *
                            1.2,
                        barTouchData: BarTouchData(enabled: false),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                const style = TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                );
                                String text;
                                switch (value.toInt()) {
                                  case 0:
                                    text = 'Income';
                                    break;
                                  case 1:
                                    text = 'Expense';
                                    break;
                                  default:
                                    text = '';
                                }
                                return SideTitleWidget(
                                  axisSide: meta.axisSide,
                                  space: 16,
                                  child: Text(text, style: style),
                                );
                              },
                            ),
                          ),
                          leftTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: [
                          BarChartGroupData(
                            x: 0,
                            barRods: [
                              BarChartRodData(
                                toY: totalIncome,
                                color: Colors.green,
                                width: 20,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ],
                          ),
                          BarChartGroupData(
                            x: 1,
                            barRods: [
                              BarChartRodData(
                                toY: totalExpense,
                                color: Colors.red,
                                width: 20,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    'Expenses by Category',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 2.h),
                  if (categoryExpenses.isNotEmpty)
                    SizedBox(
                      height: 30.h,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 0,
                          centerSpaceRadius: 40,
                          sections: categoryExpenses.entries.map((entry) {
                            final isLarge = entry.value / totalExpense > 0.1;
                            return PieChartSectionData(
                              color: Colors.primaries[categoryExpenses.keys
                                      .toList()
                                      .indexOf(entry.key) %
                                  Colors.primaries.length],
                              value: entry.value,
                              title:
                                  '${(entry.value / totalExpense * 100).toStringAsFixed(1)}%',
                              radius: isLarge ? 60 : 50,
                              titleStyle: TextStyle(
                                fontSize: isLarge ? 16 : 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    )
                  else
                    const Text('No expenses to show.'),
                ],
              ),
            );
          } else if (state is TransactionError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('Something went wrong.'));
        },
      ),
    );
  }
}
