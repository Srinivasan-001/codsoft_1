import 'package:flutter/material.dart';

class Transaction {
  final String title;
  final double amount;
  final String category;
  final DateTime date;

  Transaction({
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Transaction> _transactions = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String _selectedCategory = 'General';
  double _monthlyBudget = 0.0;

  double get _totalExpenses => _transactions.fold(0.0, (sum, item) => sum + item.amount);

  void _addTransaction() {
    final String title = _titleController.text;
    final double? amount = double.tryParse(_amountController.text);

    if (title.isNotEmpty && amount != null) {
      setState(() {
        _transactions.add(Transaction(
          title: title,
          amount: amount,
          category: _selectedCategory,
          date: DateTime.now(),
        ));
      });
      _titleController.clear();
      _amountController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: _amountController,
                  decoration: const InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                ),
                DropdownButton<String>(
                  value: _selectedCategory,
                  items: ['General', 'Food', 'Transport', 'Shopping']
                      .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value ?? 'General';
                    });
                  },
                ),
                ElevatedButton(
                  onPressed: _addTransaction,
                  child: const Text('Add Transaction'),
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Set Monthly Budget'),
                  keyboardType: TextInputType.number,
                  onSubmitted: (value) {
                    setState(() {
                      _monthlyBudget = double.tryParse(value) ?? 0.0;
                    });
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text('Total Expenses: \$${_totalExpenses.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Monthly Budget: \$${_monthlyBudget.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Remaining Budget: \$${(_monthlyBudget - _totalExpenses).toStringAsFixed(2)}',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: (_monthlyBudget - _totalExpenses) < 0
                            ? Colors.red
                            : Colors.green)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                final transaction = _transactions[index];
                return ListTile(
                  title: Text(transaction.title),
                  subtitle: Text(
                      '${transaction.category} - ${transaction.date.toLocal().toString().split(' ')[0]}'),
                  trailing: Text('\$${transaction.amount.toStringAsFixed(2)}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
