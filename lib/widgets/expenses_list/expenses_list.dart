import 'package:expence_tracker/models/expense.dart';
import 'package:expence_tracker/widgets/expenses_list/expense_item.dart';
import 'package:flutter/material.dart';

class ExpensesList extends StatelessWidget {
  // Stateless Widget is used here
  //because we just have to output data

  const ExpensesList(
      {super.key, required this.expenses, required this.onRemovedExpense});

  final void Function(Expense expense) onRemovedExpense;

  final List<Expense> expenses;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemBuilder: (ctx, index) => Dismissible(

              background: Container(
                color: Theme.of(context).colorScheme.error.withOpacity(0.5),
                margin:EdgeInsets.symmetric(horizontal : Theme.of(context).cardTheme.margin!.horizontal),
              ),

              key: ValueKey(expenses[index]),
              // Valuekey will create key obj as a value for key: parameter
              onDismissed: (direction) {

                onRemovedExpense(expenses[index]);

              },

              child: ExpenseItem(expenses[index]),

            ),
        itemCount: expenses.length);

    // ListView = scrollable ,  it is used for n no of item one below other
    // builder = to create and display items
    // if itemCount is 2 the function (ctx,index)=> ExpenseItem() will be called twice
    // Dismissible for deleting note by swapping from R to L
  }
}
