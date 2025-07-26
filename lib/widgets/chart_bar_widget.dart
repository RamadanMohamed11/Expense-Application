import 'package:expenses/models/expense_model.dart';
import 'package:flutter/material.dart';

class ChartBarWidget extends StatelessWidget {
  ChartBarWidget({
    super.key,
    required this.maxBarHeight,
    required this.categoryTotals,
  });

  double maxBarHeight;
  Map<ExpenseCategory, double> categoryTotals;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(10.0),
      ),
      height: maxBarHeight + 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: ExpenseCategory.values.length,
        itemBuilder: (BuildContext context, int index) {
          // log("category length: ${ExpenseCategory.values.length}");
          // log(state.categoryTotals[ExpenseCategory.values[index]].toString());

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0),
                    ),
                  ),
                  height: categoryTotals[ExpenseCategory.values[index]] ?? 0.0,
                  width: 50,
                ),
                SizedBox(height: 5.0),
                Text(
                  ExpenseCategory.values[index].toString().split('.').last,
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
