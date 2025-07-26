import 'package:expenses/models/expense_model.dart';
import 'package:expenses/widgets/expense_item_widget.dart';
import 'package:flutter/material.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList({super.key, required this.expenses});

  final List<ExpenseModel> expenses;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(childCount: expenses.length, (
        BuildContext context,
        int index,
      ) {
        return ExpenseItemWidget(expense: expenses[index]);
      }),
    );
  }
}
