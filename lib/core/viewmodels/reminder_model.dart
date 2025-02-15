import 'package:flutter/material.dart';
import 'package:Tracketizer/core/enums/viewstate.dart';
import 'package:Tracketizer/core/services/notification_service.dart';
import 'package:Tracketizer/core/services/sharedprefs_service.dart';
import 'package:Tracketizer/core/viewmodels/base_model.dart';
import 'package:Tracketizer/core/services/balance_service.dart';

import '../../locator.dart';

// reminder model
class ReminderModel extends BaseModel {
  final NotificationService _notificationService =
      locator<NotificationService>();

  final SharedPrefrencesService _sharedPrefrencesService =
      locator<SharedPrefrencesService>();

  final BalanceService _balanceService =
      locator<BalanceService>();

  TimeOfDay selectedTime;
  String timeText = '';
  int _localThreshold = 0;

  int get balanceThreshold => _balanceService.balanceThreshold;

  void scheduleNotifaction() {
    if (selectedTime == null) return;
    _notificationService.showNotificationDaily(
        1,
        'Tracketizer',
        'Don\'t forget to record your expenses!',
        selectedTime.hour,
        selectedTime.minute);
  }

  pickTime(context) async {
    TimeOfDay time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      selectedTime = time;
      scheduleNotifaction();
      storeTime(); // in shaerd prefs
      timeText = await getTime();
      notifyListeners();
    }
  }

  // Update the local (temporary) threshold value
  void updateLocalThreshold(int threshold) {
    _localThreshold = threshold;
    notifyListeners();
  }

  // Set the balance threshold only when the user clicks the button
  void setBalanceThreshold() {
    _balanceService.setBalanceThreshold(_localThreshold);
    notifyListeners();
  }

  // Method to check if balance falls below the threshold
  void checkBalance() {
    int currentBalance = _balanceService.balance;
    int threshold = _balanceService.balanceThreshold;
    if (currentBalance <= threshold) {
      _notificationService.showNotification(
          2,
          'Balance Alert',
          'Your balance is low!');
    }
  }

  getTime() async {
    return await _sharedPrefrencesService.getTime();
  }

  storeTime() async {
    await _sharedPrefrencesService.storeTime(
        selectedTime.hour, selectedTime.minute);
  }

  init() async {
    setState(ViewState.Busy);
    notifyListeners();
    timeText = await getTime();
    setState(ViewState.Idle);
    notifyListeners();
  }
}
