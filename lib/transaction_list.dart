import 'package:expense_tracker/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TransactionList extends StatelessWidget {
  final Box<TransactionModel> transactionBox = Hive.box<TransactionModel>('transactions');

 TransactionList({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: transactionBox.listenable(),
      builder: (context, Box<TransactionModel> box, _) {
        if (box.isEmpty) return Center(child: Text("No transactions available"));

        return ListView.builder(
          itemCount: box.length,
          itemBuilder: (context, index) {
            final transaction = box.getAt(index);
            if (transaction == null) return SizedBox.shrink();

            return ListTile(
              leading: Icon(transaction.isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                  color: transaction.isIncome ? Colors.green : Colors.red),
              title: Text(transaction.reason),
              subtitle: Text(transaction.dateTime.toString()),
              trailing: Text(
                '\$${transaction.amount.toStringAsFixed(2)}',
                style: TextStyle(color: transaction.isIncome ? Colors.green : Colors.red),
              ),
              onLongPress: () => _confirmDelete(context, index),
            );
          },
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Transaction'),
        content: Text('Are you sure you want to delete this transaction?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Cancel')),
          TextButton(
            onPressed: () {
              transactionBox.deleteAt(index);
              Navigator.of(context).pop();
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}
