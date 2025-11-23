import 'package:appwrite/appwrite.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gulfon_expense_manager/config/environment.dart';
import 'package:gulfon_expense_manager/core/router/app_router.dart';
import 'package:gulfon_expense_manager/features/accounts/data/account_repository.dart';
import 'package:gulfon_expense_manager/features/accounts/logic/account_cubit.dart';
import 'package:gulfon_expense_manager/features/auth/data/auth_repository.dart';
import 'package:gulfon_expense_manager/features/auth/logic/auth_cubit.dart';
import 'package:gulfon_expense_manager/features/categories/data/category_repository.dart';
import 'package:gulfon_expense_manager/features/categories/logic/category_cubit.dart';
import 'package:gulfon_expense_manager/features/transactions/data/transaction_repository.dart';
import 'package:gulfon_expense_manager/features/transactions/logic/transaction_cubit.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';

class AppwriteApp extends StatelessWidget {
  const AppwriteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => AuthRepository()),
        RepositoryProvider(
            create: (context) => AccountRepository(Client()
              ..setEndpoint(Environment.appwritePublicEndpoint)
              ..setProject(Environment.appwriteProjectId))),
        RepositoryProvider(
            create: (context) => CategoryRepository(Client()
              ..setEndpoint(Environment.appwritePublicEndpoint)
              ..setProject(Environment.appwriteProjectId))),
        RepositoryProvider(
            create: (context) => TransactionRepository(Client()
              ..setEndpoint(Environment.appwritePublicEndpoint)
              ..setProject(Environment.appwriteProjectId))),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) =>
                  AuthCubit(context.read<AuthRepository>())..checkAuthStatus()),
          BlocProvider(
              create: (context) =>
                  AccountCubit(context.read<AccountRepository>())),
          BlocProvider(
              create: (context) =>
                  CategoryCubit(context.read<CategoryRepository>())),
          BlocProvider(
              create: (context) =>
                  TransactionCubit(context.read<TransactionRepository>())),
        ],
        child: Sizer(
          builder: (context, orientation, deviceType) {
            return MaterialApp(
              title: 'Gulfon Expense Manager',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                useMaterial3: true,
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                inputDecorationTheme: const InputDecorationTheme(
                  border: OutlineInputBorder(),
                ),
              ),
              onGenerateRoute: AppRouter.generateRoute,
              initialRoute: '/',
            );
          },
        ),
      ),
    );
  }
}
