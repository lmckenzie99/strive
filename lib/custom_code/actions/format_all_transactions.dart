// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

List<dynamic> formatAllTransactions(List<dynamic> transactions) {
  List<dynamic> formatted = [];

  for (var txn in transactions) {
    if (txn is Map) {
      Map<String, dynamic> formattedTxn = Map.from(txn);

      // Format the amount as currency
      if (formattedTxn['amount'] != null) {
        double amount = formattedTxn['amount'] is double
            ? formattedTxn['amount']
            : double.tryParse(formattedTxn['amount'].toString()) ?? 0.0;
        formattedTxn['amount'] = '\$${amount.abs().toStringAsFixed(2)}';
      }

      // Add a DISPLAY field for category without modifying the original
      if (formattedTxn['personal_finance_category'] != null) {
        var cat = formattedTxn['personal_finance_category'];
        if (cat is Map && cat['primary'] != null) {
          String displayName = cat['primary']
              .toString()
              .replaceAll('_', ' ')
              .split(' ')
              .map((word) => word.isEmpty
                  ? ''
                  : word[0].toUpperCase() + word.substring(1).toLowerCase())
              .join(' ');
          // Add as a new field instead of overwriting
          formattedTxn['category_display'] = displayName;
        }
      }

      formatted.add(formattedTxn);
    }
  }

  return formatted;
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
