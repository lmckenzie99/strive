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

List<dynamic> monthlyFilter(
  List<dynamic> allTransactions,
  String? weekType,
) {
  if (allTransactions.isEmpty || weekType == null) {
    return [];
  }

  // Extract all valid dates and sort them
  List<Map<String, dynamic>> transactionsWithDates = [];

  for (var txn in allTransactions) {
    if (txn is Map && txn['authorized_date'] != null) {
      try {
        String dateStr = txn['authorized_date'].toString();
        DateTime txnDate = DateTime.parse(dateStr);
        transactionsWithDates.add({
          'transaction': txn,
          'date': txnDate,
        });
      } catch (e) {
        continue;
      }
    }
  }

  if (transactionsWithDates.isEmpty) {
    return [];
  }

  // Sort by date (oldest first)
  transactionsWithDates.sort((a, b) => a['date'].compareTo(b['date']));

  // Split all 45 transactions in half
  // Last Week = first 22 (oldest)
  // This Week = last 23 (newest)
  int midpoint = (transactionsWithDates.length / 2).floor(); // Should be 22

  List<dynamic> filteredTransactions = [];

  if (weekType == 'lastWeek') {
    // Return first half (older transactions)
    for (int i = 0; i < midpoint; i++) {
      Map<String, dynamic> txn =
          Map.from(transactionsWithDates[i]['transaction']);
      // Format the amount as currency
      if (txn['amount'] != null) {
        double amount = txn['amount'] is double
            ? txn['amount']
            : double.tryParse(txn['amount'].toString()) ?? 0.0;
        txn['amount'] = '\$${amount.abs().toStringAsFixed(2)}';
      }
      filteredTransactions.add(txn);
    }
  } else if (weekType == 'thisWeek') {
    // Return second half (newer transactions)
    for (int i = midpoint; i < transactionsWithDates.length; i++) {
      Map<String, dynamic> txn =
          Map.from(transactionsWithDates[i]['transaction']);
      // Format the amount as currency
      if (txn['amount'] != null) {
        double amount = txn['amount'] is double
            ? txn['amount']
            : double.tryParse(txn['amount'].toString()) ?? 0.0;
        txn['amount'] = '\$${amount.abs().toStringAsFixed(2)}';
      }
      filteredTransactions.add(txn);
    }
  }

  return filteredTransactions;
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
