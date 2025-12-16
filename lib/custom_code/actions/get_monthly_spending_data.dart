// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:convert';

Future<dynamic> getMonthlySpendingData(
  List<dynamic>? transactions,
  String groupBy,
) async {
  if (transactions == null || transactions.isEmpty) {
    return {'labels': [], 'amounts': []};
  }

  Map<String, double> dateData = {};

  for (var transaction in transactions) {
    double amount = 0.0;
    var amountValue = transaction['amount'];
    if (amountValue != null) {
      if (amountValue is String) {
        amount = double.tryParse(amountValue) ?? 0.0;
      } else if (amountValue is num) {
        amount = amountValue.toDouble();
      }
    }

    if (amount <= 0) continue;

    String? dateStr = transaction['date'];
    if (dateStr == null) continue;

    DateTime date = DateTime.parse(dateStr);
    String key = '${date.month}/${date.day}';

    dateData[key] = (dateData[key] ?? 0.0) + amount;
  }

  if (dateData.isEmpty) {
    return {'labels': [], 'amounts': []};
  }

  var sortedKeys = dateData.keys.toList()..sort();
  List<double> amounts = sortedKeys.map((k) => dateData[k]!).toList();

  // Hard cap at $500
  double cap = 150.0;

  List<double> cappedAmounts = amounts.map((amt) {
    if (amt > cap) {
      print('Capping $amt to $cap');
      return cap;
    }
    return amt;
  }).toList();

  // Convert to numeric labels
  List<double> numericLabels =
      List.generate(sortedKeys.length, (i) => (i + 1).toDouble());

  return {
    'labels': numericLabels,
    'amounts': cappedAmounts,
  };
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
