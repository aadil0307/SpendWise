import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BalanceService with ChangeNotifier {
  int _income = 0;
  int _expense = 0;
  int _balanceThreshold = 0;  // Global balance threshold

  int get income => _income;
  int get expense => _expense;
  int get balance => _income - _expense;
  int get balanceThreshold => _balanceThreshold;

  BalanceService() {
    _loadBalanceThreshold();  // Load the threshold when the service is initialized
  }

  // Set the income and notify listeners
  void setIncome(int newIncome) {
    _income = newIncome;
    notifyListeners();
  }

  // Set the expense and notify listeners
  void setExpense(int newExpense) {
    _expense = newExpense;
    notifyListeners();
  }

  // Set the balance threshold and persist it
  Future<void> setBalanceThreshold(int threshold) async {
    _balanceThreshold = threshold;
    notifyListeners();
    await _saveBalanceThreshold();
  }

  // Save the balance threshold to SharedPreferences
  Future<void> _saveBalanceThreshold() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('balanceThreshold', _balanceThreshold);
  }

  // Load the balance threshold from SharedPreferences
  Future<void> _loadBalanceThreshold() async {
    final prefs = await SharedPreferences.getInstance();
    _balanceThreshold = prefs.getInt('balanceThreshold') ?? 0;
    notifyListeners();  // Notify listeners to update any UI that depends on this value
  }
}
