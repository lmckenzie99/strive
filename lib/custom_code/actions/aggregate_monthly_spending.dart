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

Future<List<dynamic>> aggregateMonthlySpending(
  List<dynamic>? transactions,
  String groupBy,
) async {
  print('===== START =====');

  if (transactions == null || transactions.isEmpty) {
    print('No transactions');
    return [];
  }

  print('Got ${transactions.length} transactions');

  Map<String, Map<String, dynamic>> dateData = {};

  for (var transaction in transactions) {
    // Parse amount (handle string or number)
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

    String key =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    String label = '${date.month}/${date.day}';

    if (!dateData.containsKey(key)) {
      dateData[key] = {'key': key, 'label': label, 'amount': 0.0};
    }

    dateData[key]!['amount'] = (dateData[key]!['amount'] as double) + amount;
  }

  print('Found ${dateData.length} dates');

  List<Map<String, dynamic>> result = dateData.values
      .map((data) => {
            'label': data['label'],
            'amount': data['amount'],
            'sortKey': data['key'],
          })
      .toList()
    ..sort((a, b) => a['sortKey'].compareTo(b['sortKey']));

  print('Returning ${result.length} items');
  return result;
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
