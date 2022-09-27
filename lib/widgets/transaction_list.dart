import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> userTransactions;
  final Function onDeleteTransaction;

  TransactionList(this.userTransactions, this.onDeleteTransaction);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: userTransactions.isEmpty
          ? Column(
              children: [
                Text("No transactions added yet!",
                    style: Theme.of(context).textTheme.titleMedium),
                SizedBox(
                  height: 15,
                ),
                Container(
                  height: 200,
                  child: Image.asset(
                    "assets/images/waiting.png",
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
                )
              ],
            )
          : ListView.builder(
              itemBuilder: (ctx, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: EdgeInsets.all(6),
                        child: FittedBox(
                            child: Text(
                                "\$${userTransactions[index].amount.toStringAsFixed(2)}")),
                      ),
                    ),
                    title: Text(userTransactions[index].title,
                        style: Theme.of(context).textTheme.titleMedium),
                    subtitle: Text(DateFormat.yMMMd()
                        .format(userTransactions[index].date)),
                    trailing: IconButton(
                      onPressed: () => onDeleteTransaction(userTransactions[index].id),
                      icon: Icon(Icons.delete),
                      color: Theme.of(context).errorColor,
                    ),
                  ),
                );
              },
              itemCount: userTransactions.length,
            ),
    );
  }
}
