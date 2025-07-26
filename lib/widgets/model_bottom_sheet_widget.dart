import 'package:expenses/cubits/add_expense_cubit/expense_cubit.dart';
import 'package:expenses/models/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ModelBottomSheetWidget extends StatefulWidget {
  const ModelBottomSheetWidget({super.key});

  @override
  State<ModelBottomSheetWidget> createState() => _ModelBottomSheetWidgetState();
}

class _ModelBottomSheetWidgetState extends State<ModelBottomSheetWidget> {
  late TextEditingController titleController;
  late TextEditingController amountController;
  DateTime? currentDate;
  late ExpenseCategory currentCategory = ExpenseCategory.Other;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    amountController = TextEditingController();
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogTheme: DialogThemeData(backgroundColor: Colors.white),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != currentDate) {
      setState(() {
        currentDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Add New Expense',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                TextField(
                  controller: titleController,
                  maxLength: 50,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: TextStyle(fontSize: 16.0),
                  ),
                ),
                SizedBox(height: 20.0),
                TextField(
                  controller: amountController,
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    labelStyle: TextStyle(fontSize: 16.0),
                    suffixIcon: Icon(Icons.attach_money),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20.0),
                Row(
                  children: [
                    // Text(
                    //   "Date: ${DateFormat('yyyy-MM-dd').format(currentDate)}",
                    // ),
                    Text('Date: ', style: TextStyle(fontSize: 16.0)),
                    Text(
                      currentDate == null
                          ? 'No date selected'
                          : '${currentDate!.toLocal()}'.split(' ')[0],
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.calendar_month),
                      onPressed: () => _selectDate(context),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                Row(
                  children: [
                    Text("Category:", style: TextStyle(fontSize: 16.0)),
                    Spacer(),
                    DropdownButton<ExpenseCategory>(
                      value: currentCategory,
                      icon: Icon(Icons.arrow_drop_down),
                      items:
                          ExpenseCategory.values.map((category) {
                            return DropdownMenuItem(
                              value: category,
                              child: Text(category.toString().split('.').last),
                            );
                          }).toList(),
                      onChanged: (value) {
                        currentCategory = value!;
                        setState(() {});
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () async {
                    if (titleController.text.trim().isEmpty ||
                        amountController.text.trim().isEmpty ||
                        currentDate == null) {
                      showDialog(
                        context: context,
                        builder:
                            (ctx) => AlertDialog(
                              title: Text(
                                'Error',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: Text(
                                'Please fill in all the fields.',
                                style: TextStyle(fontSize: 18.0),
                              ),
                              actions: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                  ),
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                  child: Text(
                                    'OK',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      );
                    } else {
                      final newExpense = ExpenseModel(
                        title: titleController.text,
                        amount: double.tryParse(amountController.text) ?? 0.0,
                        date: currentDate!,
                        category: currentCategory,
                      );
                      await BlocProvider.of<ExpenseCubit>(context).addExpense(
                        newExpense.title,
                        newExpense.amount,
                        newExpense.date,
                        newExpense.category,
                      );
                      titleController.clear();
                      amountController.clear();
                      currentDate = null;
                      currentCategory = ExpenseCategory.Other;

                      Navigator.pop(context);
                    }
                  },
                  child: Text('Save Expense'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
