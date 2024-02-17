import 'package:expence_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem(this.expense, {super.key});

  final Expense expense;
  @override
  Widget build(BuildContext context) {
    return Card(
       // used for card look
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(expense.title , style: Theme.of(context).textTheme.titleLarge,),
            const SizedBox(height: 4),
            Row(
              // Row is used to make sub categories in respective titles
              children: [
                Text('\$${expense.amount.toStringAsFixed(2)}'),
                const Spacer(), // get all spac betn Text() & Row() below
                // toStringAsFixed(2) => 12.3435 = 12.34
                // $ is used to inject this complex value({....}) to Text()
                // \$ is used to get print of $ sign as $ 12.99
                 Row(
                  // it used to bind category and date together 
                // & they should be present on right corner
                  children: [
                    Icon(categoryIcons[expense.category]),
                   const  SizedBox(width : 8),
                    Text(expense.formattedDate),// getter so dont use ()
                  ],
                ), 
              ],
            )
          ],
        ),
      ),
    );
  }
}
