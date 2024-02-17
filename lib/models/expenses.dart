import 'package:expence_tracker/widgets/chart/chart.dart';
import 'package:expence_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expence_tracker/models/expense.dart';
import 'package:expence_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  // Stateful Widget is used to manage data
  const Expenses({super.key});
  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
        title: 'Flutter Course',
        amount: 19.99,
        date: DateTime.now(),
        category: Category.work),
    Expense(
        title: 'Cinema',
        amount: 15.69,
        date: DateTime.now(),
        category: Category.leisure)
  ];

  // method for + button
  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true, // to stay away from device features like camera and punch area
      isScrollControlled:
          true, // to stop overlapping of keyboard on Dropdown button and other buttons too
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: _addExpense),
    );
    // adds new ui element
    // context is added by flutter Globally
    // contex has info of Expenses widget
    // ctx holds info of showModalExpenseOverlay
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);

    setState(() {
      _registeredExpenses.remove(expense);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    // making Undo Button
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense deleted.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;


    Widget mainContent = const Center(
      child: Text('No expenses found , Start adding some !'),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemovedExpense: _removeExpense,
      );
    }
    return Scaffold(
      // Toolbar with Add button using Row() widget
      appBar: AppBar(title: const Text('Expense Tracker'), actions: [
        IconButton(
          onPressed: _openAddExpenseOverlay,
          icon: const Icon(Icons.add), // + icon add kelo
        ),
      ]),
      body: width < 600 ? Column(
        children: [
          Chart(
            expenses: _registeredExpenses,
          ),
          Expanded(
              // Expanded is used here because ExpencesList will show Column
              // because We are already in Column in line : 28
              child: mainContent),
        ],
      ) : Row(
        children: [
          Expanded(
            child: Chart(
              expenses: _registeredExpenses,
            ),
          ),
          Expanded(
              // Expanded is used here because ExpencesList will show Column
              // because We are already in Column in line : 28
              child: mainContent),
        ],

      ),
    );
  }
}
