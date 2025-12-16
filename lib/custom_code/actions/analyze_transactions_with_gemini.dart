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
import 'package:http/http.dart' as http;

Future<String> analyzeTransactionsWithGemini(
  List<dynamic>? transactions,
  String? analysisType,
  String? apiKey,
) async {
  // Validate inputs
  if (transactions == null || transactions.isEmpty) {
    return "No transaction data available for analysis.";
  }

  if (apiKey == null || apiKey.isEmpty) {
    return "API key not configured.";
  }

  // Format transaction data for Gemini
  String formattedData = _formatTransactionsForAnalysis(transactions);

  // Build prompt based on analysis type
  String prompt = _buildPrompt(formattedData, analysisType ?? 'general');

  // Make API call to Gemini
  try {
    final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent?key=$apiKey');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': prompt}
            ]
          }
        ],
        'generationConfig': {
          'temperature': 0.7,
          'maxOutputTokens': 500,
        }
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      String analysisText = _extractGeminiResponse(responseData);
      return analysisText;
    } else {
      return "Failed to get analysis. Error: ${response.statusCode}";
    }
  } catch (e) {
    return "Error connecting to AI service: ${e.toString()}";
  }
}

String _formatTransactionsForAnalysis(List<dynamic> transactions) {
  StringBuffer buffer = StringBuffer();

  // Limit to recent 50 transactions to avoid token limits
  int limit = transactions.length > 50 ? 50 : transactions.length;

  for (int i = 0; i < limit; i++) {
    var txn = transactions[i];

    // Extract fields safely
    String date = txn['date']?.toString() ?? 'Unknown date';
    String merchant = txn['merchant_name']?.toString() ??
        txn['name']?.toString() ??
        'Unknown merchant';

    // Handle nested category structure
    String category = 'Uncategorized';
    if (txn['personal_finance_category'] != null) {
      var catObj = txn['personal_finance_category'];
      if (catObj is Map && catObj['primary'] != null) {
        category = catObj['primary'].toString();
      }
    }

    // Handle amount as string or number (from your Plaid integration)
    double amount = 0.0;
    var amountValue = txn['amount'];
    if (amountValue is String) {
      amount = double.tryParse(amountValue) ?? 0.0;
    } else if (amountValue is num) {
      amount = amountValue.toDouble();
    }

    // Only include positive amounts (spending, not income)
    if (amount > 0) {
      buffer.writeln(
          '• $date: $merchant - \$${amount.toStringAsFixed(2)} ($category)');
    }
  }

  return buffer.toString();
}

String _buildPrompt(String transactionData, String analysisType) {
  Map<String, String> prompts = {
    'spending_patterns':
        '''Analyze these recent transactions and identify spending patterns:

$transactionData

Provide a concise analysis covering:
1. Overall spending trends (increasing/decreasing)
2. Day-of-week or timing patterns
3. Merchant frequency patterns
4. Any concerning patterns to watch

Keep response under 200 words, be specific and actionable.''',
    'category_insights': '''Analyze spending across categories:

$transactionData

Provide insights on:
1. Top 3 spending categories with amounts
2. Categories with unusual or high activity
3. Recommended budget allocation per category

Keep response under 200 words, include specific dollar amounts.''',
    'recommendations':
        '''Based on these transactions, provide actionable financial advice:

$transactionData

Provide:
1. Top 2-3 areas to reduce spending with estimated savings
2. Positive spending habits to maintain
3. Specific action items for this week

Keep response under 200 words, be encouraging but honest.''',
    'general':
        '''Analyze these financial transactions and provide a helpful overview:

$transactionData

Provide a brief analysis covering:
- Total spending trend
- Top spending categories
- One key insight or recommendation

Keep response under 150 words, be friendly and clear.'''
  };

  return prompts[analysisType] ?? prompts['general']!;
}

String _extractGeminiResponse(dynamic jsonBody) {
  try {
    if (jsonBody is Map) {
      var candidates = jsonBody['candidates'];
      if (candidates != null && candidates is List && candidates.isNotEmpty) {
        var content = candidates[0]['content'];
        if (content != null && content is Map) {
          var parts = content['parts'];
          if (parts != null && parts is List && parts.isNotEmpty) {
            return parts[0]['text'] ?? 'No response text found.';
          }
        }
      }
    }
    return 'Unable to parse AI response.';
  } catch (e) {
    return 'Error parsing response: ${e.toString()}';
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
