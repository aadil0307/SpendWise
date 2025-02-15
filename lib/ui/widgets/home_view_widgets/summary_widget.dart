import 'package:flutter/material.dart';
import 'package:Tracketizer/ui/shared/text_styles.dart';
import 'package:Tracketizer/ui/shared/ui_helpers.dart';
import 'package:Tracketizer/core/viewmodels/reminder_model.dart';
import 'package:Tracketizer/core/services/balance_service.dart';
import 'package:Tracketizer/locator.dart';

class SummaryWidget extends StatelessWidget {
  final int income;
  final int expense;

  const SummaryWidget({this.income, this.expense});

  @override
  Widget build(BuildContext context) {
    final BalanceService balanceService = locator<BalanceService>();

    // Update the balance in BalanceService
    balanceService.setIncome(income);
    balanceService.setExpense(expense);
    final int balance = balanceService.balance;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal, // Scroll horizontally
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // Income Column
                Column(
                  children: <Widget>[
                    Text('Income', style: summaryTextStyle),
                    UIHelper.verticalSpaceSmall(),
                    Text(
                      income.toString(),
                      style: summaryNumberTextStyle,
                    ),
                  ],
                ),

                // Add space between columns
                SizedBox(width: 10), // You can adjust the width as needed

                // Separator
                Text(
                  '|',
                  style: TextStyle(
                      fontSize: 40,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.w200),
                ),

                // Add space between the separator and next column
                SizedBox(width: 10),

                // Expense Column
                Column(
                  children: <Widget>[
                    Text(
                      'Expense',
                      style: summaryTextStyle,
                    ),
                    UIHelper.verticalSpaceSmall(),
                    Text(
                      expense.toString(),
                      style: summaryNumberTextStyle,
                    ),
                  ],
                ),

                SizedBox(width: 10), // Space between columns

                // Separator
                Text(
                  '|',
                  style: TextStyle(
                      fontSize: 40,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.w200),
                ),

                SizedBox(width: 10), // Space between the separator and next column

                // Balance Column
                Column(
                  children: <Widget>[
                    Text(
                      'Balance',
                      style: summaryTextStyle,
                    ),
                    UIHelper.verticalSpaceSmall(),
                    Text(
                      balance.toString(),
                      style: summaryNumberTextStyle,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

