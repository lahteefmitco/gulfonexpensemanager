import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gulfon_expense_manager/features/auth/logic/auth_cubit.dart';
import 'package:gulfon_expense_manager/features/auth/logic/auth_state.dart';
import 'package:gulfon_expense_manager/features/categories/data/models/category_model.dart';
import 'package:gulfon_expense_manager/features/categories/logic/category_cubit.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      context.read<CategoryCubit>().loadCategories(authState.user.$id);
    }
  }

  void _showAddCategoryDialog(BuildContext context) {
    final nameController = TextEditingController();
    String type = 'Expense';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Category'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Category Name'),
              ),
              DropdownButtonFormField<String>(
                value: type,
                items: ['Income', 'Expense']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {
                  type = value!;
                },
                decoration: const InputDecoration(labelText: 'Type'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final authState = context.read<AuthCubit>().state;
                if (authState is AuthAuthenticated) {
                  final category = CategoryModel(
                    id: '',
                    name: nameController.text,
                    type: type,
                  );
                  context
                      .read<CategoryCubit>()
                      .addCategory(category, authState.user.$id);
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCategoryDialog(context),
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CategoryLoaded) {
            if (state.categories.isEmpty) {
              return const Center(child: Text('No categories found.'));
            }
            return ListView.builder(
              itemCount: state.categories.length,
              itemBuilder: (context, index) {
                final category = state.categories[index];
                return ListTile(
                  leading: Icon(
                    category.type == 'Income'
                        ? Icons.arrow_downward
                        : Icons.arrow_upward,
                    color:
                        category.type == 'Income' ? Colors.green : Colors.red,
                  ),
                  title: Text(category.name),
                  subtitle: Text(category.type),
                );
              },
            );
          } else if (state is CategoryError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('Something went wrong.'));
        },
      ),
    );
  }
}
