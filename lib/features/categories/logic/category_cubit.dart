import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gulfon_expense_manager/features/categories/data/category_repository.dart';
import 'package:gulfon_expense_manager/features/categories/data/models/category_model.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();
  @override
  List<Object?> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<CategoryModel> categories;
  const CategoryLoaded(this.categories);
  @override
  List<Object?> get props => [categories];
}

class CategoryError extends CategoryState {
  final String message;
  const CategoryError(this.message);
  @override
  List<Object?> get props => [message];
}

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryRepository _repository;

  CategoryCubit(this._repository) : super(CategoryInitial());

  Future<void> loadCategories(String userId) async {
    emit(CategoryLoading());
    try {
      final categories = await _repository.getCategories(userId);
      emit(CategoryLoaded(categories));
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  Future<void> addCategory(CategoryModel category, String userId) async {
    try {
      await _repository.createCategory(category, userId);
      loadCategories(userId);
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }
}
