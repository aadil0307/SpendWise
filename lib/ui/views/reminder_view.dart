import 'package:flutter/material.dart';
import 'package:Tracketizer/core/enums/viewstate.dart';
import 'package:Tracketizer/core/viewmodels/reminder_model.dart';
import 'package:Tracketizer/ui/views/base_view.dart';

class ReminderView extends StatelessWidget {
  const ReminderView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<ReminderModel>(
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(title: Text('Reminder')),
        body: model.state == ViewState.Busy
            ? CircularProgressIndicator()
            : Column(
                children: <Widget>[
                  ListTile(
                    title: Text('Daily Reminder'),
                    subtitle: Text(model.timeText),
                    trailing: InkWell(
                      child: Icon(Icons.edit),
                      onTap: () {
                        model.pickTime(context);
                      },
                    ),
                  ),
                  SizedBox(height: 20), // Space between widgets

                  // Balance threshold input
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Low Balance Alert Amount',
                            hintText: 'Enter Amount',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            int threshold = int.tryParse(value) ?? 0;
                            model.updateLocalThreshold(threshold);
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Display current balance threshold
                  Text('Current Balance Threshold: ${model.balanceThreshold}'),

                  // Button to check balance and update the threshold
                  ElevatedButton(
                    onPressed: () {
                      model.setBalanceThreshold();
                      model.checkBalance(); // Check balance against the threshold
                    },
                    child: Text('Set Threshold'),
                  ),
                ],
              ),
      ),
    );
  }
}
