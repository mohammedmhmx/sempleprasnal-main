import 'package:flutter/material.dart';


import '../models/expense.dart';


class ExpenseList extends StatelessWidget {
  final List<Expense> expenses;
  final Function(Expense) onEdit;
  final Function(String) onDelete;

  const ExpenseList({
    Key? key,
    required this.expenses,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (expenses.isEmpty) {
      return const Center(
        child: Text(
          'لا توجد مصروفات مسجلة',
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        final expense = expenses[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _getCategoryColor(expense.category),
              child: Text(
                expense.amount.toStringAsFixed(0),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(expense.title),
            subtitle: Text(
              '${expense.category} - ${expense.date.toLocal().toString().split(' ')[0]}',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => onEdit(expense),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _showDeleteDialog(context, expense),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'طعام':
        return Colors.green;
      case 'مواصلات':
        return Colors.blue;
      case 'تسوق':
        return Colors.purple;
      case 'ترفيه':
        return Colors.orange;
      case 'صحة':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showDeleteDialog(BuildContext context, Expense expense) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف المصروف'),
        content: Text('هل أنت متأكد من حذف "${expense.title}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              onDelete(expense.id);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
}