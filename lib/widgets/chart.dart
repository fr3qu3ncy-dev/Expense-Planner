import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/transaction.dart';
import 'package:flutter_complete_guide/widgets/chart_bar.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  double get totalSpending {
    return recentTransactions.fold(
        0, (previousValue, element) => previousValue + element.amount);
  }

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      var startDay = DateTime.now();
      for (int i = 0; i < 6; i++) {
        startDay = startDay.subtract(Duration(days: 1));
        if (startDay.weekday == DateTime.monday) {
          startDay = new DateTime(
              startDay.year, startDay.month, startDay.day, 0, 0, 0, 0, 0);
          break;
        }
      }

      final weekDay = startDay.add(Duration(days: index));
      double totalSum = recentTransactions
          .where((element) =>
              element.date.day == weekDay.day &&
              element.date.month == weekDay.month &&
              element.date.year == weekDay.year)
          .fold(0, (previousValue, element) => previousValue + element.amount);

      print("${DateFormat.yMMMd().format(weekDay)} ${totalSum}");

      return {
        "day": DateFormat.E().format(weekDay).substring(0, 1),
        "amount": totalSum
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    print(groupedTransactionValues);

    return Card(
        shadowColor: Theme.of(context).primaryColorLight,
        shape: RoundedRectangleBorder(
            side: BorderSide(
                strokeAlign: StrokeAlign.outside,
                color: Theme.of(context).primaryColorLight,
                width: 2),
            borderRadius: BorderRadius.circular(30)),
        elevation: 10,
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: groupedTransactionValues.map((data) {
              return Flexible(
                fit: FlexFit.tight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: ChartBar(
                      data["day"],
                      data["amount"],
                      totalSpending > 0
                          ? (data["amount"] as double) / totalSpending
                          : 0),
                ),
              );
            }).toList(),
          ),
        ));
  }
}
