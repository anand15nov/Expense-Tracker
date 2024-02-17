import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expence_tracker/models/expense.dart';

final formatter = DateFormat.yMd();

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;
  // TextEditingController will save data simultaneously
  // to delete space in memory we'll dispose TEController
  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(
        _amountController.text); // double.tryParse('String') : String to Number
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      // show ERROR message
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid Input'),
          content: const Text(
              'Please make sure a valid title , amount , date and category was entered'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            )
          ],
        ),
      );
      return;
    }

    widget.onAddExpense(
      Expense(
          title: _titleController.text,
          amount: enteredAmount,
          date: _selectedDate!,
          category: _selectedCategory),
    );

    // to close the Overlay after adding Expense

    Navigator.pop(context);
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    // show date and save date
    final pickedDate = await showDatePicker(
      // await will tell flutter to wait for this value
      context: context,
      firstDate:
          firstDate, // you can start picking date from last year i.e. now.year()-1
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    // to make things in + more responsive
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    // for ui elements overlapping issue from bottom (keyboard is overlapping on other ui elements)
    return LayoutBuilder(builder: (ctx, constrains) {
      // layoutBuilder : to make title and amount in same line , date and category in same line in landscape mode
      final width = constrains.maxWidth;
      return SizedBox(
        // to use all space in landscape mode
        height: double.infinity,
        child: SingleChildScrollView(
          // to make things in + scrollable
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
            child: Column(
              children: [
                if (width >= 600)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start ,
                    children: [
                     Expanded ( child : TextField(
                        controller: _titleController,
                        maxLength: 50, // less than 50 Characters
                        decoration: const InputDecoration(
                          label: Text('Title'),
                        ),
                      ),),
                      const SizedBox(width: 24),
                      Expanded (
                        child : TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          prefixText: '\$',
                          label: Text('Amount'),
                        ),
                      ),
                      ),
                    ],
                  )
                else
                  // title in + button
                  TextField(
                    controller: _titleController,
                    maxLength: 50, // less than 50 Characters
                    decoration: const InputDecoration(
                      label: Text('Title'),
                    ),
                  ),

                if(width >= 600) 
                Row(children: [
                   DropdownButton(
                      value: _selectedCategory,
                      items: Category.values
                          .map(
                            // to iterte through each category
                            (category) => DropdownMenuItem(
                              value:
                                  category, // dropdown options will get enum type i.e. Category category type
                              child: Text(
                                category.name.toUpperCase(),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        //to display category on selected on DropDown button

                        if (value == null) return;

                        setState(
                          () {
                            _selectedCategory = value;
                          },
                        );
                      },
                    ),
                    const SizedBox(width: 24,),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        // to push date and icon at right end
                        crossAxisAlignment: CrossAxisAlignment.center,
                        // to make it in center vertically
                        children: [
                          // date
                          Text(_selectedDate == null
                              ? ' No Date Selected !'
                              : formatter.format(_selectedDate!)),
                          // selectedDate! , here ! is used to tell dart this value is not null
                          // calendar icon
                          IconButton(
                            onPressed: _presentDatePicker,
                            icon: const Icon(Icons.calendar_month),
                          ),
                        ],
                      ),
                    ),
                ],)

                else 
                // amount and (date + icon)
                Row(
                  children: [
                    // amount in + button
                    Expanded(
                      child: TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          prefixText: '\$',
                          label: Text('Amount'),
                        ),
                      ),
                    ),

                    const SizedBox(
                      width: 16,
                    ),

                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        // to push date and icon at right end
                        crossAxisAlignment: CrossAxisAlignment.center,
                        // to make it in center vertically
                        children: [
                          // date
                          Text(_selectedDate == null
                              ? ' No Date Selected !'
                              : formatter.format(_selectedDate!)),
                          // selectedDate! , here ! is used to tell dart this value is not null
                          // calendar icon
                          IconButton(
                            onPressed: _presentDatePicker,
                            icon: const Icon(Icons.calendar_month),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox( height: 16),
                // next row for ...
                //  Dropdown Button, cancel , save
                if(width >= 600)
                  Row(children: [
                     const Spacer(),

                    TextButton(
                      // cancel button
                      onPressed: () {
                        Navigator.pop(context);
                        // deletes the overlay(title amount save cancel page) from screen
                        // by getting info from context of Widget build
                      },
                      child: const Text('Cancel'),
                    ),
                    // save button
                    ElevatedButton(
                      onPressed:
                          _submitExpenseData, // for getting all stuff that should get noted
                      child: const Text('Save Expense'),
                    ),
                  ],)
                else
                Row(
                  children: [
                    DropdownButton(
                      value: _selectedCategory,
                      items: Category.values
                          .map(
                            // to iterte through each category
                            (category) => DropdownMenuItem(
                              value:
                                  category, // dropdown options will get enum type i.e. Category category type
                              child: Text(
                                category.name.toUpperCase(),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        //to display category on selected on DropDown button

                        if (value == null) return;

                        setState(
                          () {
                            _selectedCategory = value;
                          },
                        );
                      },
                    ),

                    const Spacer(),

                    TextButton(
                      // cancel button
                      onPressed: () {
                        Navigator.pop(context);
                        // deletes the overlay(title amount save cancel page) from screen
                        // by getting info from context of Widget build
                      },
                      child: const Text('Cancel'),
                    ),
                    // save button
                    ElevatedButton(
                      onPressed:
                          _submitExpenseData, // for getting all stuff that should get noted
                      child: const Text('Save Expense'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
