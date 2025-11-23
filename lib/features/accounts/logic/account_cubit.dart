import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gulfon_expense_manager/features/accounts/data/account_repository.dart';
import 'package:gulfon_expense_manager/features/accounts/data/models/account_model.dart';

abstract class AccountState extends Equatable {
  const AccountState();
  @override
  List<Object?> get props => [];
}

class AccountInitial extends AccountState {}

class AccountLoading extends AccountState {}

class AccountLoaded extends AccountState {
  final List<AccountModel> accounts;
  const AccountLoaded(this.accounts);
  @override
  List<Object?> get props => [accounts];
}

class AccountError extends AccountState {
  final String message;
  const AccountError(this.message);
  @override
  List<Object?> get props => [message];
}

class AccountCubit extends Cubit<AccountState> {
  final AccountRepository _repository;

  AccountCubit(this._repository) : super(AccountInitial());

  Future<void> loadAccounts(String userId) async {
    emit(AccountLoading());
    try {
      final accounts = await _repository.getAccounts(userId);
      emit(AccountLoaded(accounts));
    } catch (e) {
      emit(AccountError(e.toString()));
    }
  }

  Future<void> addAccount(AccountModel account, String userId) async {
    try {
      await _repository.createAccount(account, userId);
      loadAccounts(userId);
    } catch (e) {
      emit(AccountError(e.toString()));
    }
  }
}
