import 'package:expenses/models/expense_model.dart';

abstract class ExpenseCubitState {}

class ExpenseCubitInitialState extends ExpenseCubitState {}

class ExpenseCubitLoadingState extends ExpenseCubitState {}

class ExpenseCubitLoadedState extends ExpenseCubitState {
  List<ExpenseModel> expenses;
  Map<ExpenseCategory, double> categoryTotals;
  double maxAmount;

  ExpenseCubitLoadedState({
    required this.expenses,
    required this.categoryTotals,
    required this.maxAmount,
  });
}

class ExpenseCubitErrorState extends ExpenseCubitState {
  final String error;

  ExpenseCubitErrorState(this.error);
}
