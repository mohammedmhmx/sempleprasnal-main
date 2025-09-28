import 'package:flutter/material.dart';

import '../models/expense.dart';

class ExpenseForm extends StatefulWidget {
  final Expense? expense;
  final Function(Expense) onSubmit;

  const ExpenseForm({Key? key, this.expense, required this.onSubmit}) : super(key: key);

  @override
  _ExpenseFormState createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _selectedCategory = 'طعام';

  final List<String> _categories = [
    'طعام',
    'مواصلات',
    'تسوق',
    'ترفيه',
    'صحة',
    'أخرى'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.expense != null) {
      _titleController.text = widget.expense!.title;
      _amountController.text = widget.expense!.amount.toString();
      _selectedDate = widget.expense!.date;
      _selectedCategory = widget.expense!.category;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final expense = Expense(
        id: widget.expense?.id ?? '',
        title: _titleController.text,
        amount: double.parse(_amountController.text),
        date: _selectedDate,
        category: _selectedCategory,
      );
      widget.onSubmit(expense);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.expense == null ? 'إضافة مصروف' : 'تعديل مصروف'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'العنوان'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال العنوان';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'المبلغ'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال المبلغ';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'يرجى إدخال مبلغ صحيح';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
                decoration: const InputDecoration(labelText: 'الفئة'),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text('التاريخ: ${_selectedDate.toLocal().toString().split(' ')[0]}'),
                  const Spacer(),
                  TextButton(
                    onPressed: () => _selectDate(context),
                    child: const Text('اختيار التاريخ'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: _submitForm,
          child: Text(widget.expense == null ? 'إضافة' : 'تحديث'),
        ),
      ],
    );
  }
}