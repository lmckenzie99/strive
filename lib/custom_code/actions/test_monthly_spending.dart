// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<List<dynamic>> testMonthlySpending(
  List<dynamic>? transactions,
) async {
  print('TEST FUNCTION CALLED!');

  if (transactions == null || transactions.isEmpty) {
    print('No transactions');
    return [];
  }

  print('Got ${transactions.length} transactions');

  return [
    {'label': 'Test 1', 'amount': 100.0, 'sortKey': '2025-11-01'},
    {'label': 'Test 2', 'amount': 200.0, 'sortKey': '2025-11-02'},
  ];
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
