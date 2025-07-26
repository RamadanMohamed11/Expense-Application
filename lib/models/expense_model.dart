// ignore_for_file: constant_identifier_names

import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

part 'expense_model.g.dart'; // ✅ needed for code generation

@HiveType(typeId: 1) // ✅ unique for each class
enum ExpenseCategory {
  @HiveField(0)
  Food,
  @HiveField(1)
  Travel,
  @HiveField(2)
  Leisure,
  @HiveField(3)
  Bills,
  @HiveField(4)
  Health,
  @HiveField(5)
  Other,
}

@HiveType(typeId: 0)
class ExpenseModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final ExpenseCategory category;
  @HiveField(5)
  ExpenseModel({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = Uuid().v4();
}
