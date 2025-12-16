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

Future<List<dynamic>> aggregatePlaidTransactions(
  List<dynamic>? transactions,
) async {
  if (transactions == null || transactions.isEmpty) {
    return [];
  }

  print('Processing ${transactions.length} transactions');

  Map<String, Map<String, dynamic>> categoryData = {};
  double totalSpending = 0.0;

  for (var transaction in transactions) {
    // Handle amount as string or number
    double amount = 0.0;
    var amountValue = transaction['amount'];

    if (amountValue != null) {
      if (amountValue is String) {
        amount = double.tryParse(amountValue) ?? 0.0;
      } else if (amountValue is num) {
        amount = amountValue.toDouble();
      }
    }

    // Only count spending (positive amounts in Plaid)
    if (amount <= 0) continue;

    totalSpending += amount;

    // Get category from Plaid
    String category = 'Other';
    if (transaction['personal_finance_category'] != null) {
      category = transaction['personal_finance_category']['primary'] ?? 'Other';
    } else if (transaction['category'] != null &&
        (transaction['category'] as List).isNotEmpty) {
      category = transaction['category'][0];
    }

    // Clean up category name for display
    category = category.replaceAll('_', ' ').toLowerCase();
    category = category
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');

    // Initialize or update category
    if (!categoryData.containsKey(category)) {
      categoryData[category] = {
        'category': category,
        'total': 0.0,
        'count': 0,
      };
    }

    categoryData[category]!['total'] =
        (categoryData[category]!['total'] as double) + amount;
    categoryData[category]!['count'] =
        (categoryData[category]!['count'] as int) + 1;
  }

  print('Found ${categoryData.length} categories');

  // Convert to list and add percentages
  List<Map<String, dynamic>> allResults = categoryData.values.map((data) {
    double total = data['total'] as double;
    return {
      'category': data['category'],
      'total': total,
      'count': data['count'],
      'percentage': totalSpending > 0 ? (total / totalSpending * 100) : 0.0,
    };
  }).toList()
    ..sort((a, b) => (b['total'] as double).compareTo(a['total'] as double));

  print('Total categories: ${allResults.length}');

  // If 5 or fewer categories, return all
  if (allResults.length <= 5) {
    print('Returning all ${allResults.length} categories');
    return allResults;
  }

  // Take top 5
  List<Map<String, dynamic>> result = [];
  for (int i = 0; i < 5; i++) {
    result.add(allResults[i]);
  }

  // Combine the rest into "Other"
  double otherTotal = 0.0;
  int otherCount = 0;

  for (int i = 5; i < allResults.length; i++) {
    otherTotal += allResults[i]['total'] as double;
    otherCount += allResults[i]['count'] as int;
  }

  print('Other total: $otherTotal from ${allResults.length - 5} categories');

  result.add({
    'category': 'Other',
    'total': otherTotal,
    'count': otherCount,
    'percentage': totalSpending > 0 ? (otherTotal / totalSpending * 100) : 0.0,
  });

  print('Returning ${result.length} categories (top 5 + Other)');
  return result;
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
