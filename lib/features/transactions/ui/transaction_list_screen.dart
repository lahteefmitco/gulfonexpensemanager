import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gulfon_expense_manager/features/auth/logic/auth_cubit.dart';
import 'package:gulfon_expense_manager/features/auth/logic/auth_state.dart';
import 'package:gulfon_expense_manager/features/transactions/logic/transaction_cubit.dart';
import 'package:intl/intl.dart';

class TransactionListScreen extends StatefulWidget {
  const TransactionListScreen({super.key});

  @override
  State<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_transaction');
        },
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<TransactionCubit, TransactionState>(
        builder: (context, state) {
          if (state is TransactionLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TransactionLoaded) {
            if (state.transactions.isEmpty) {
              return const Center(child: Text('No transactions found.'));
            }
            return ListView.builder(
              itemCount: state.transactions.length,
              itemBuilder: (context, index) {
                final transaction = state.transactions[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: transaction.type == 'Income'
                        ? Colors.green
                        : Colors.red,
                    child: Icon(
                      transaction.type == 'Income'
                          ? Icons.arrow_downward
                          : Icons.arrow_upward,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(transaction.note ?? 'Transaction'),
                  subtitle:
                      Text(DateFormat('MMM dd, yyyy').format(transaction.date)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${transaction.type == 'Income' ? '+' : '-'}\$${transaction.amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: transaction.type == 'Income'
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') {
                            Navigator.pushNamed(
                              context,
                              '/add_transaction',
                              arguments: transaction,
                            );
                          } else if (value == 'delete') {
                            final authState = context.read<AuthCubit>().state;
                            if (authState is AuthAuthenticated) {
                              context
                                  .read<TransactionCubit>()
                                  .deleteTransaction(
                                    transaction.id,
                                    authState.user.$id,
                                  );
                            }
                          }
                        },
                        itemBuilder: (BuildContext context) {
                          return [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Text('Edit'),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ];
                        },
                      ),
                    ],
                  ),
                );
              },
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
