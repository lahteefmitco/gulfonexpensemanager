import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gulfon_expense_manager/features/auth/logic/auth_cubit.dart';
import 'package:gulfon_expense_manager/features/auth/logic/auth_state.dart';
import 'package:gulfon_expense_manager/features/transactions/data/models/transaction_model.dart';
import 'package:gulfon_expense_manager/features/transactions/logic/transaction_cubit.dart';
import 'package:sizer/sizer.dart';

class AddEditTransactionScreen extends StatefulWidget {
  final TransactionModel? transaction;
  const AddEditTransactionScreen({super.key, this.transaction});

  @override
  State<AddEditTransactionScreen> createState() =>
      _AddEditTransactionScreenState();
}

class _AddEditTransactionScreenState extends State<AddEditTransactionScreen> {
  late TextEditingController _amountController;
  late TextEditingController _noteController;
  late String _type;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
        text: widget.transaction?.amount.toString() ?? '');
    _noteController =
        TextEditingController(text: widget.transaction?.note ?? '');
    _type = widget.transaction?.type ?? 'Expense';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.transaction == null
              ? 'Add Transaction'
              : 'Edit Transaction')),
      body: Padding(
        padding: EdgeInsets.all(5.w),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                initialValue: _type,
                items: ['Income', 'Expense', 'Transfer']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _type = value!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Type'),
              ),
              SizedBox(height: 2.h),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 2.h),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(labelText: 'Note'),
              ),
              SizedBox(height: 4.h),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final authState = context.read<AuthCubit>().state;
                    if (authState is AuthAuthenticated) {
                      final transaction = TransactionModel(
                        id: widget.transaction?.id ?? '',
                        amount: double.parse(_amountController.text),
                        type: _type,
                        categoryId: widget.transaction?.categoryId ?? 'default',
                        accountId: widget.transaction?.accountId ?? 'default',
                        date: widget.transaction?.date ?? DateTime.now(),
                        note: _noteController.text,
                      );

                      if (widget.transaction == null) {
                        context.read<TransactionCubit>().addTransaction(
                              transaction,
                              authState.user.$id,
                            );
                      } else {
                        context.read<TransactionCubit>().updateTransaction(
                              transaction,
                              authState.user.$id,
                            );
                      }
                      Navigator.pop(context);
                    }
                  }
                },
                child: Text(widget.transaction == null
                    ? 'Save Transaction'
                    : 'Update Transaction'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
