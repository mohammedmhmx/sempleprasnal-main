import 'package:flutter/material.dart';
import 'package:sempleprasant/%20widgets/expense_form.dart';
import 'package:sempleprasant/%20widgets/expense_list.dart';

import '../models/expense.dart';
import '../services/expense_service.dart';
import '../services/auth_service.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ExpenseService _expenseService = ExpenseService();
  final AuthService _authService = AuthService();
  List<Expense> _expenses = [];
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  void _loadExpenses() {
    setState(() {
      _expenses = _expenseService.getAllExpenses();
    });
  }

  void _addExpense(Expense expense) {
    _expenseService.addExpense(expense);
    _loadExpenses();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم إضافة المصروف بنجاح')),
    );
  }

  void _updateExpense(Expense expense) {
    _expenseService.updateExpense(expense.id, expense);
    _loadExpenses();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم تعديل المصروف بنجاح')),
    );
  }

  void _deleteExpense(String id) {
    _expenseService.deleteExpense(id);
    _loadExpenses();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم حذف المصروف بنجاح')),
    );
  }

  void _showExpenseForm([Expense? expense]) {
    showDialog(
      context: context,
      builder: (context) => ExpenseForm(
        expense: expense,
        onSubmit: expense == null ? _addExpense : _updateExpense,
      ),
    );
  }

  void _sortExpensesByDate() {
    _expenseService.sortByDate(_sortAscending);
    _sortAscending = !_sortAscending;
    _loadExpenses();
  }

  void _sortExpensesByAmount() {
    _expenseService.sortByAmount(_sortAscending);
    _sortAscending = !_sortAscending;
    _loadExpenses();
  }

  void _logout() {
    _authService.logout();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalAmount = _expenseService.getTotalExpenses();

    return Scaffold(
      appBar: AppBar(
        title: const Text('مدير المصروفات الشخصية'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'تسجيل الخروج',
          ),
        ],
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            color: Colors.blue[50],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'إجمالي المصروفات',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${totalAmount.toStringAsFixed(2)} ريال',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _sortExpensesByDate,
                    icon: const Icon(Icons.calendar_today),
                    label: const Text('ترتيب حسب التاريخ'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _sortExpensesByAmount,
                    icon: const Icon(Icons.attach_money),
                    label: const Text('ترتيب حسب المبلغ'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ExpenseList(
              expenses: _expenses,
              onEdit: _showExpenseForm,
              onDelete: _deleteExpense,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showExpenseForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}