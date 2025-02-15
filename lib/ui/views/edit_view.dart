import 'package:flutter/material.dart';
import 'package:Tracketizer/core/database/moor_database.dart';
import 'package:Tracketizer/core/viewmodels/edit_model.dart';
import 'package:Tracketizer/ui/shared/app_colors.dart';
import 'package:Tracketizer/ui/shared/ui_helpers.dart';
import 'package:Tracketizer/ui/views/base_view.dart';
import 'package:Tracketizer/core/viewmodels/reminder_model.dart';
import 'package:Tracketizer/locator.dart';

class EditView extends StatelessWidget {
  final Transaction transaction;
  EditView(this.transaction);

  @override
  Widget build(BuildContext context) {
    ReminderModel reminderModel = locator<ReminderModel>();
    return BaseView<EditModel>(
      onModelReady: (model) => model.init(transaction),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text('Edit'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              ListTile(
                title: Text(model.category.name),
                leading: CircleAvatar(
                  child: Icon(
                    model.category.icon,
                    size: 20,
                  ),
                ),
              ),
              UIHelper.verticalSpaceMedium(),
              buildTextField(
                model.memoController,
                'Memo:',
                "Enter a memo for your transaction",
                Icons.edit,
                false,
              ),
              UIHelper.verticalSpaceMedium(),
              buildTextField(
                model.amountController,
                'Amount:',
                "Enter the amount for the transaction",
                Icons.attach_money, // Icon is used here for non-numeric fields
                true, // Marking this as numeric for amount field
              ),
              UIHelper.verticalSpaceMedium(),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'SELECT DATE:',
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
                ),
              ),
              Divider(
                thickness: 2,
              ),
              Divider(
                thickness: 2,
              ),
              Container(
                width: 20,
                height: 50,
                child: RaisedButton(
                  child: Text(model.getSelectedDate()),
                  onPressed: () async {
                    await model.selectDate(context);
                  },
                ),
              ),
              UIHelper.verticalSpaceLarge(),
              Align(
                alignment: Alignment.centerLeft,
                child: RaisedButton(
                  child: Text(
                    'EDIT',
                    style: TextStyle(fontSize: 16),
                  ),
                  color: backgroundColor,
                  textColor: Colors.black,
                  onPressed: () async {
                    await model.editTransaction(
                      context,
                      transaction.type,
                      transaction.categoryindex,
                      transaction.id,
                    );
                    Future.delayed(Duration(seconds: 5), () {
                      reminderModel.checkBalance();
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField buildTextField(
      TextEditingController controller,
      String text,
      String helperText,
      IconData icon,
      bool isNumeric,
      ) {
    return TextFormField(
      cursorColor: Colors.black,
      maxLength: isNumeric ? 10 : 40,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        // Use Rupee symbol for numeric fields, and icon for others
        icon: isNumeric
            ? Text('₹', style: TextStyle(fontSize: 24)) // Rupee symbol for amount
            : Icon(icon, color: Colors.black), // Regular icon for non-numeric fields
        labelText: text,
        suffixIcon: InkWell(
          onTap: () {
            controller.clear();
          },
          child: Icon(
            Icons.clear,
            color: Colors.black,
          ),
        ),
        labelStyle: TextStyle(
          color: Color(0xFFFF000000),
        ),
        helperText: helperText,
      ),
    );
  }
}
