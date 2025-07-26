import 'dart:developer';

import 'package:expenses/constants.dart';
import 'package:expenses/cubits/add_expense_cubit/expense_cubit.dart';
import 'package:expenses/models/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenseItemWidget extends StatelessWidget {
  const ExpenseItemWidget({super.key, required this.expense});
  final ExpenseModel expense;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: (direction) {
        // delete the expense
        BlocProvider.of<ExpenseCubit>(context).deleteExpense(expense.id);
      },
      key: Key(expense.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            const Icon(Icons.delete, color: Colors.white, size: 30.0),
            Text(
              'Delete',
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
          ],
        ),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Delete',
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
            const Icon(Icons.edit, color: Colors.white, size: 30.0),
          ],
        ),
      ),
      child: Card(
        color: Colors.grey[400],
        margin: const EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ListTile(
          leading: Icon(expenseCategoryIcon[expense.category], size: 40.0),
          title: Text(
            expense.title,
            style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
          ),
          subtitle: Row(
            children: [
              Text('\$${expense.amount}', style: TextStyle(fontSize: 15.0)),
              Spacer(),
              Text(
                '${expense.date.day}/${expense.date.month}/${expense.date.year}',
                style: TextStyle(fontSize: 15.0),
              ),
            ],
          ),
          trailing: Text(
            expense.category.toString().split('.').last,
            style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
