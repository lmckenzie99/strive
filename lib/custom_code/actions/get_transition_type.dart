// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Add firebase_remote_config: ^4.2.5 to pubspec.yaml
import 'package:firebase_remote_config/firebase_remote_config.dart';

Future<String> getTransitionType() async {
  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.fetchAndActivate();
  return remoteConfig.getString('page_transition_type');
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
