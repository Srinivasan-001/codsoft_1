import 'package:expense_tracker/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';


class ExpenseTracker extends ChangeNotifier {
  Box<TransactionModel> transactionBox = Hive.box<TransactionModel>('transactions');

  List<TransactionModel> get transactions => transactionBox.values.toList();

  void addTransaction(TransactionModel transaction) {
    transactionBox.add(transaction);
    notifyListeners();
  }

  void deleteTransaction(int index) {
    transactionBox.deleteAt(index);
    notifyListeners();
  }
}
