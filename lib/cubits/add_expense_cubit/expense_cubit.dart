import 'package:expenses/constants.dart';
import 'package:expenses/cubits/add_expense_cubit/expense_cubit_state.dart';
import 'package:expenses/models/expense_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class ExpenseCubit extends Cubit<ExpenseCubitState> {
  late Map<ExpenseCategory, double> categoryTotals;
  late List<ExpenseModel> expenses;

  ExpenseCubit() : super(ExpenseCubitInitialState()) {
    categoryTotals = {
      ExpenseCategory.Food: 0.0,
      ExpenseCategory.Travel: 0.0,
      ExpenseCategory.Leisure: 0.0,
      ExpenseCategory.Bills: 0.0,
      ExpenseCategory.Health: 0.0,
      ExpenseCategory.Other: 0.0,
    };
    _loadExpenses(); // Load asynchronously
  }

  Future<void> _loadExpenses() async {
    emit(ExpenseCubitLoadingState());
    try {
      final box = Hive.box<ExpenseModel>(kExpensesBoxName);
      expenses = box.values.toList();
      _calculateCategoryTotals();
      emit(
        ExpenseCubitLoadedState(
          expenses: expenses,
          categoryTotals: categoryTotals,
          maxAmount: maxAmount,
        ),
      );
    } catch (e) {
      emit(ExpenseCubitErrorState(e.toString()));
    }
  }

  void _calculateCategoryTotals() {
    for (var expense in expenses) {
      categoryTotals[expense.category] =
          (categoryTotals[expense.category] ?? 0.0) + expense.amount;
    }
  }

  Future<void> addExpense(
    String title,
    double amount,
    DateTime date,
    ExpenseCategory category,
  ) async {
    emit(ExpenseCubitLoadingState());
    try {
      expenses.add(
        ExpenseModel(
          title: title,
          amount: amount,
          date: date,
          category: category,
        ),
      );
      Box<ExpenseModel> expensesBox = Hive.box<ExpenseModel>(kExpensesBoxName);
      await expensesBox.add(expenses.last);
      categoryTotals[category] = categoryTotals[category]! + amount;
      emit(
        ExpenseCubitLoadedState(
          expenses: expenses,
          categoryTotals: categoryTotals,
          maxAmount: maxAmount,
        ),
      );
    } catch (e) {
      emit(ExpenseCubitErrorState(e.toString()));
    }
  }

  void deleteExpense(String id) {
    emit(ExpenseCubitLoadingState());
    try {
      Box<ExpenseModel> expensesBox = Hive.box<ExpenseModel>(kExpensesBoxName);
      int index = expenses.indexWhere((expense) => expense.id == id);
      expensesBox.deleteAt(index);
      categoryTotals[expenses[index].category] =
          categoryTotals[expenses[index].category]! - expenses[index].amount;
      expenses.removeWhere((expense) => expense.id == id);
      emit(
        ExpenseCubitLoadedState(
          expenses: expenses,
          categoryTotals: categoryTotals,
          maxAmount: maxAmount,
        ),
      );
    } catch (e) {
      emit(ExpenseCubitErrorState(e.toString()));
    }
  }

  List<ExpenseModel> getExpenses() {
    try {
      emit(ExpenseCubitLoadingState());
      Box<ExpenseModel> expensesBox = Hive.box<ExpenseModel>(kExpensesBoxName);
      emit(
        ExpenseCubitLoadedState(
          expenses: expensesBox.values.toList(),
          categoryTotals: categoryTotals,
          maxAmount: maxAmount,
        ),
      );
      return expensesBox.values.toList();
    } catch (e) {
      emit(ExpenseCubitErrorState(e.toString()));
      return [];
    }
  }

  double get maxAmount {
    double max = 0.0;
    for (var total in categoryTotals.values) {
      if (total > max) {
        max = total;
      }
    }
    return max;
  }
}
