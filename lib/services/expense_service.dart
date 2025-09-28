


import '../models/expense.dart';

class ExpenseService {
  final List<Expense> _expenses = [];
  int _nextId = 1;

  // Singleton pattern
  static final ExpenseService _instance = ExpenseService._internal();
  factory ExpenseService() => _instance;
  ExpenseService._internal();

  // إضافة مصروف جديد
  void addExpense(Expense expense) {
    expense.id = _nextId.toString();
    _expenses.add(expense);
    _nextId++;
  }

  // حذف مصروف
  bool deleteExpense(String id) {
    final initialLength = _expenses.length;
    _expenses.removeWhere((expense) => expense.id == id);
    return _expenses.length < initialLength;
  }

  // تعديل مصروف
  bool updateExpense(String id, Expense updatedExpense) {
    final index = _expenses.indexWhere((expense) => expense.id == id);
    if (index != -1) {
      updatedExpense.id = id;
      _expenses[index] = updatedExpense;
      return true;
    }
    return false;
  }

  // الحصول على جميع المصروفات
  List<Expense> getAllExpenses() {
    return List<Expense>.from(_expenses);
  }

  // الحصول على مصروف بواسطة ID
  Expense? getExpenseById(String id) {
    try {
      return _expenses.firstWhere((expense) => expense.id == id);
    } catch (e) {
      return null;
    }
  }

  // الحصول على إجمالي المصروفات
  double getTotalExpenses() {
    return _expenses.fold(0, (sum, expense) => sum + expense.amount);
  }

  // ترتيب المصروفات حسب التاريخ
  void sortByDate(bool ascending) {
    _expenses.sort((a, b) => ascending 
        ? a.date.compareTo(b.date) 
        : b.date.compareTo(a.date));
  }

  // ترتيب المصروفات حسب المبلغ
  void sortByAmount(bool ascending) {
    _expenses.sort((a, b) => ascending 
        ? a.amount.compareTo(b.amount) 
        : b.amount.compareTo(a.amount));
  }
}