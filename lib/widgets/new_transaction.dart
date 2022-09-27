
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function onTransactionAdded;

  NewTransaction(this.onTransactionAdded);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate;

  var _enteredTitle;
  var _enteredAmount;

  _NewTransactionState() {
    _titleController.addListener(() => _onTextEdited());
    _amountController.addListener(() => _onTextEdited());
  }

  void _onTextEdited() {
    print("Edited");
    setState(() {
      _enteredTitle = _titleController.text;
      _enteredAmount = _amountController.text.isEmpty ? 0 : double.parse(_amountController.text);
    });
  }


  void _submitData() {
    if (_enteredTitle.isEmpty || _enteredAmount <= 0 || _selectedDate == null)
      return;

    widget.onTransactionAdded(_titleController.text,
        double.parse(_amountController.text), _selectedDate);
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    var now = DateTime.now();

    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(now.year),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) return;
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: InputDecoration(labelText: "Title"),
                controller: _titleController,
              ),
              TextField(
                decoration: InputDecoration(labelText: "Amount"),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                controller: _amountController,
                onSubmitted: (_) => _submitData(),
              ),
              Container(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(_selectedDate == null
                          ? "No Date chosen!"
                          : "Picked Date: ${DateFormat.yMd().format(_selectedDate)}"),
                    ),
                    TextButton(
                        onPressed: () => _presentDatePicker(),
                        child: Text(
                          "Choose Date",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              ),
              ElevatedButton(
                  onPressed: _titleController.text.isEmpty ||
                          _amountController.text.isEmpty ||
                          _selectedDate == null
                      ? null
                      : () => _submitData(),
                  child: Text(
                    "Add Transaction",
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
