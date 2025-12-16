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

List<String> getUniqueCategories(List<dynamic> transactions) {
  Set<String> categories = {};

  for (var txn in transactions) {
    if (txn is Map && txn['personal_finance_category'] != null) {
      var category = txn['personal_finance_category'];
      if (category is Map && category['primary'] != null) {
        String categoryName = category['primary'].toString();

        // Clean up the category name - replace underscores with spaces, capitalize properly
        categoryName = categoryName
            .replaceAll('_', ' ')
            .split(' ')
            .map((word) => word.isEmpty
                ? ''
                : word[0].toUpperCase() + word.substring(1).toLowerCase())
            .join(' ');

        categories.add(categoryName);
      }
    }
  }

  // Convert to list and sort alphabetically
  List<String> sortedCategories = categories.toList()..sort();

  return sortedCategories;
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
