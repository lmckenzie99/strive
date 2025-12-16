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

Future<String> formatTransactionsForAI(List<dynamic>? transactions) async {
  if (transactions == null || transactions.isEmpty) {
    return "No transactions found.";
  }

  StringBuffer formatted = StringBuffer();
  double totalSpending = 0;

  // Group by category for better insights
  Map<String, double> categoryTotals = {};

  for (var transaction in transactions) {
    double amount = (transaction['amount'] ?? 0).toDouble();
    String merchant =
        transaction['merchant_name'] ?? transaction['name'] ?? 'Unknown';
    String date = transaction['date'] ?? '';
    List<dynamic> categories = transaction['category'] ?? [];
    String category = categories.isNotEmpty ? categories[0] : 'Other';

    // Only count positive amounts (money going out)
    if (amount > 0) {
      totalSpending += amount;
      categoryTotals[category] = (categoryTotals[category] ?? 0) + amount;

      formatted.writeln(
          '- \$${amount.toStringAsFixed(2)} at $merchant on $date ($category)');
    }
  }

  // Add summary at the top
  String summary = 'Total Spending: \$${totalSpending.toStringAsFixed(2)}\n\n';
  summary += 'Spending by Category:\n';
  categoryTotals.forEach((category, total) {
    summary += '  • $category: \$${total.toStringAsFixed(2)}\n';
  });
  summary += '\nRecent Transactions:\n';

  return summary + formatted.toString();
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
