// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

List<dynamic> filterByCategory(
  List<dynamic> transactions,
  String? selectedCategory,
) {
  if (transactions.isEmpty ||
      selectedCategory == null ||
      selectedCategory.isEmpty) {
    return transactions;
  }

  // Handle "All" category - return all transactions (already formatted)
  if (selectedCategory.toUpperCase() == 'ALL') {
    return transactions;
  }

  List<dynamic> filtered = [];

  // Normalize for comparison - "Entertainment" → "ENTERTAINMENT"
  String normalizedSelected =
      selectedCategory.toUpperCase().replaceAll(' ', '_');

  for (var txn in transactions) {
    if (txn is Map && txn['personal_finance_category'] != null) {
      var category = txn['personal_finance_category'];
      if (category is Map && category['primary'] != null) {
        String categoryPrimary = category['primary'].toString();
        // Normalize the transaction category too
        String normalizedCategory =
            categoryPrimary.toUpperCase().replaceAll(' ', '_');

        if (normalizedCategory == normalizedSelected) {
          // Just pass through the transaction as-is, don't reformat
          filtered.add(txn);
        }
      }
    }
  }

  return filtered;
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
