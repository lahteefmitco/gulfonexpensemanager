import 'package:gulfon_expense_manager/app.dart';
import 'package:gulfon_expense_manager/utils/app_initializer.dart';
import 'package:flutter/material.dart';

void main() async {
  await AppInitializer.initialize();
  runApp(AppwriteApp());
}
