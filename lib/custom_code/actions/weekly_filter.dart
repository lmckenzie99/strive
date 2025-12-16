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

List<dynamic> weeklyFilter(
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

  // First split: Get the "This Week" portion from monthly (newer half of all 45)
  int monthlyMidpoint = (transactionsWithDates.length / 2).floor(); // 22

  // Take only the newer half (what was "This Week" in monthly view)
  List<Map<String, dynamic>> monthlyThisWeek =
      transactionsWithDates.sublist(monthlyMidpoint);

  // Second split: Split "This Week" in half again for weekly view
  int weeklyMidpoint = (monthlyThisWeek.length / 2).floor();

  List<dynamic> filteredTransactions = [];

  if (weekType == 'lastWeek') {
    // Return first half of monthlyThisWeek (older transactions)
    for (int i = 0; i < weeklyMidpoint; i++) {
      Map<String, dynamic> txn = Map.from(monthlyThisWeek[i]['transaction']);
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
    // Return second half of monthlyThisWeek (newer transactions)
    for (int i = weeklyMidpoint; i < monthlyThisWeek.length; i++) {
      Map<String, dynamic> txn = Map.from(monthlyThisWeek[i]['transaction']);
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
