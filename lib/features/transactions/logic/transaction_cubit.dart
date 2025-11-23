import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gulfon_expense_manager/features/transactions/data/models/transaction_model.dart';
import 'package:gulfon_expense_manager/features/transactions/data/transaction_repository.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();
  @override
  List<Object?> get props => [];
}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionLoaded extends TransactionState {
  final List<TransactionModel> transactions;
  const TransactionLoaded(this.transactions);
  @override
  List<Object?> get props => [transactions];
}

class TransactionError extends TransactionState {
  final String message;
  const TransactionError(this.message);
  @override
  List<Object?> get props => [message];
}

class TransactionCubit extends Cubit<TransactionState> {
  final TransactionRepository _repository;

  TransactionCubit(this._repository) : super(TransactionInitial());

  Future<void> loadTransactions(String userId) async {
    emit(TransactionLoading());
    try {
      final transactions = await _repository.getTransactions(userId);
      emit(TransactionLoaded(transactions));
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  Future<void> addTransaction(
      TransactionModel transaction, String userId) async {
    try {
      await _repository.createTransaction(transaction, userId);
      loadTransactions(userId);
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  Future<void> updateTransaction(
      TransactionModel transaction, String userId) async {
    try {
      await _repository.updateTransaction(transaction, userId);
      loadTransactions(userId);
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  Future<void> deleteTransaction(String transactionId, String userId) async {
    try {
      await _repository.deleteTransaction(transactionId);
      loadTransactions(userId);
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }
}
