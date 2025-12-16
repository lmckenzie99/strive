// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:intl/intl.dart';

Future updateWeeklySummary(List<dynamic> transactions) async {
  // If no transactions, set empty result
  if (transactions.isEmpty) {
    FFAppState().update(() {
      FFAppState().weeklySummaryStats = {
        'summaryText': 'No transaction data available',
      };
    });
    return;
  }

  // Group transactions by date and calculate daily totals
  Map<String, double> dailyTotals = {};

  for (var transaction in transactions) {
    String date = transaction['authorized_date'] ?? '';

    // Parse the amount string (remove $ and convert to double)
    String amountStr = transaction['amount']?.toString() ?? '0';
    amountStr = amountStr.replaceAll('\$', '').replaceAll(',', '');
    double amount = double.tryParse(amountStr) ?? 0.0;

    if (date.isNotEmpty) {
      dailyTotals[date] = (dailyTotals[date] ?? 0.0) + amount;
    }
  }

  // Find most and least expensive days
  String mostExpensiveDay = '';
  double mostExpensiveAmount = 0.0;
  String leastExpensiveDay = '';
  double leastExpensiveAmount = double.infinity;

  dailyTotals.forEach((date, amount) {
    if (amount > mostExpensiveAmount) {
      mostExpensiveAmount = amount;
      mostExpensiveDay = date;
    }
    if (amount < leastExpensiveAmount) {
      leastExpensiveAmount = amount;
      leastExpensiveDay = date;
    }
  });

  // Calculate average per day
  double totalSpent =
      dailyTotals.values.fold(0.0, (sum, amount) => sum + amount);
  double averagePerDay = totalSpent / dailyTotals.length;

  // Format dates to be more readable (e.g., "Dec 8")
  DateFormat dateFormat = DateFormat('MMM d');
  String formattedMostExpensive = mostExpensiveDay.isNotEmpty
      ? dateFormat.format(DateTime.parse(mostExpensiveDay))
      : 'N/A';
  String formattedLeastExpensive = leastExpensiveDay.isNotEmpty
      ? dateFormat.format(DateTime.parse(leastExpensiveDay))
      : 'N/A';

  // Create a formatted string with bullet points and better spacing
  String summaryText =
      '• Most expensive day: \$${mostExpensiveAmount.toStringAsFixed(2)} on $formattedMostExpensive\n\n'
      '• Least expensive day: \$${leastExpensiveAmount.toStringAsFixed(2)} on $formattedLeastExpensive\n\n'
      '• Average: \$${averagePerDay.toStringAsFixed(2)} per day';

  // Update App State
  FFAppState().update(() {
    FFAppState().weeklySummaryStats = {
      'summaryText': summaryText,
    };
  });
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
