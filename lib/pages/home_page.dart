import 'package:expenses/cubits/add_expense_cubit/expense_cubit.dart';
import 'package:expenses/cubits/add_expense_cubit/expense_cubit_state.dart';
import 'package:expenses/widgets/chart_bar_widget.dart';
import 'package:expenses/widgets/expenses_list.dart';
import 'package:expenses/widgets/model_bottom_sheet_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseCubit, ExpenseCubitState>(
      builder: (context, state) {
        if (state is ExpenseCubitLoadingState) {
          return Center(child: CircularProgressIndicator());
        } else if (state is ExpenseCubitLoadedState) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Expenses Tracker"),
              centerTitle: true,
            ),
            body: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: ChartBarWidget(
                    maxBarHeight: state.maxAmount,
                    categoryTotals: state.categoryTotals,
                  ),
                ),
                ExpensesList(expenses: state.expenses),
              ],
            ),

            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.blue,
              onPressed: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (ctx) {
                    return StatefulBuilder(
                      builder: (
                        context,
                        void Function(void Function()) setState,
                      ) {
                        return ModelBottomSheetWidget();
                      },
                    );
                  },
                );
              },
              tooltip: 'Add Expense',
              child: Icon(Icons.add, color: Colors.white),
            ),
          );
        } else if (state is ExpenseCubitErrorState) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Expenses Tracker"),
              centerTitle: true,
            ),
            body: Center(
              child: Text(
                'Error: ${state.error}',
                style: TextStyle(color: Colors.red, fontSize: 18.0),
              ),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Expenses Tracker"),
              centerTitle: true,
            ),
            body: Center(
              child: Text(
                'Unexpected state',
                style: TextStyle(color: Colors.red, fontSize: 18.0),
              ),
            ),
          );
        }
      },
    );
  }
}
