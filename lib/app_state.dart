import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _transitionType = prefs.getString('ff_transitionType') ?? _transitionType;
    });
    _safeInit(() {
      _npsTaken = prefs.getBool('ff_npsTaken') ?? _npsTaken;
    });
    _safeInit(() {
      _npsNumeric = prefs.getInt('ff_npsNumeric') ?? _npsNumeric;
    });
    _safeInit(() {
      _npsComment = prefs.getString('ff_npsComment') ?? _npsComment;
    });
    _safeInit(() {
      _responseFromGemini =
          prefs.getString('ff_responseFromGemini') ?? _responseFromGemini;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  String _transitionType = '';
  String get transitionType => _transitionType;
  set transitionType(String value) {
    _transitionType = value;
    prefs.setString('ff_transitionType', value);
  }

  bool _npsTaken = false;
  bool get npsTaken => _npsTaken;
  set npsTaken(bool value) {
    _npsTaken = value;
    prefs.setBool('ff_npsTaken', value);
  }

  int _npsNumeric = 0;
  int get npsNumeric => _npsNumeric;
  set npsNumeric(int value) {
    _npsNumeric = value;
    prefs.setInt('ff_npsNumeric', value);
  }

  String _npsComment = '';
  String get npsComment => _npsComment;
  set npsComment(String value) {
    _npsComment = value;
    prefs.setString('ff_npsComment', value);
  }

  String _responseFromGemini = '';
  String get responseFromGemini => _responseFromGemini;
  set responseFromGemini(String value) {
    _responseFromGemini = value;
    prefs.setString('ff_responseFromGemini', value);
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
