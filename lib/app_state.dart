import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:csv/csv.dart';
import 'package:synchronized/synchronized.dart';
import 'flutter_flow/flutter_flow_util.dart';

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
    secureStorage = FlutterSecureStorage();
    await _safeInitAsync(() async {
      _transitionType =
          await secureStorage.getString('ff_transitionType') ?? _transitionType;
    });
    await _safeInitAsync(() async {
      _npsTaken = await secureStorage.getBool('ff_npsTaken') ?? _npsTaken;
    });
    await _safeInitAsync(() async {
      _npsNumeric = await secureStorage.getInt('ff_npsNumeric') ?? _npsNumeric;
    });
    await _safeInitAsync(() async {
      _npsComment =
          await secureStorage.getString('ff_npsComment') ?? _npsComment;
    });
    await _safeInitAsync(() async {
      _responseFromGemini =
          await secureStorage.getString('ff_responseFromGemini') ??
              _responseFromGemini;
    });
    await _safeInitAsync(() async {
      _plaidAccessToken =
          await secureStorage.getString('ff_plaidAccessToken') ??
              _plaidAccessToken;
    });
    await _safeInitAsync(() async {
      _apiK = await secureStorage.getString('ff_apiK') ?? _apiK;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late FlutterSecureStorage secureStorage;

  String _transitionType = '';
  String get transitionType => _transitionType;
  set transitionType(String value) {
    _transitionType = value;
    secureStorage.setString('ff_transitionType', value);
  }

  void deleteTransitionType() {
    secureStorage.delete(key: 'ff_transitionType');
  }

  bool _npsTaken = false;
  bool get npsTaken => _npsTaken;
  set npsTaken(bool value) {
    _npsTaken = value;
    secureStorage.setBool('ff_npsTaken', value);
  }

  void deleteNpsTaken() {
    secureStorage.delete(key: 'ff_npsTaken');
  }

  int _npsNumeric = 0;
  int get npsNumeric => _npsNumeric;
  set npsNumeric(int value) {
    _npsNumeric = value;
    secureStorage.setInt('ff_npsNumeric', value);
  }

  void deleteNpsNumeric() {
    secureStorage.delete(key: 'ff_npsNumeric');
  }

  String _npsComment = '';
  String get npsComment => _npsComment;
  set npsComment(String value) {
    _npsComment = value;
    secureStorage.setString('ff_npsComment', value);
  }

  void deleteNpsComment() {
    secureStorage.delete(key: 'ff_npsComment');
  }

  String _responseFromGemini = '';
  String get responseFromGemini => _responseFromGemini;
  set responseFromGemini(String value) {
    _responseFromGemini = value;
    secureStorage.setString('ff_responseFromGemini', value);
  }

  void deleteResponseFromGemini() {
    secureStorage.delete(key: 'ff_responseFromGemini');
  }

  List<dynamic> _aggregateCategories = [];
  List<dynamic> get aggregateCategories => _aggregateCategories;
  set aggregateCategories(List<dynamic> value) {
    _aggregateCategories = value;
  }

  void addToAggregateCategories(dynamic value) {
    aggregateCategories.add(value);
  }

  void removeFromAggregateCategories(dynamic value) {
    aggregateCategories.remove(value);
  }

  void removeAtIndexFromAggregateCategories(int index) {
    aggregateCategories.removeAt(index);
  }

  void updateAggregateCategoriesAtIndex(
    int index,
    dynamic Function(dynamic) updateFn,
  ) {
    aggregateCategories[index] = updateFn(_aggregateCategories[index]);
  }

  void insertAtIndexInAggregateCategories(int index, dynamic value) {
    aggregateCategories.insert(index, value);
  }

  List<dynamic> _rawTransactions = [];
  List<dynamic> get rawTransactions => _rawTransactions;
  set rawTransactions(List<dynamic> value) {
    _rawTransactions = value;
  }

  void addToRawTransactions(dynamic value) {
    rawTransactions.add(value);
  }

  void removeFromRawTransactions(dynamic value) {
    rawTransactions.remove(value);
  }

  void removeAtIndexFromRawTransactions(int index) {
    rawTransactions.removeAt(index);
  }

  void updateRawTransactionsAtIndex(
    int index,
    dynamic Function(dynamic) updateFn,
  ) {
    rawTransactions[index] = updateFn(_rawTransactions[index]);
  }

  void insertAtIndexInRawTransactions(int index, dynamic value) {
    rawTransactions.insert(index, value);
  }

  String _plaidAccessToken =
      'access-sandbox-dfa5c403-d7a6-4039-802a-ba8eb90e0f9a';
  String get plaidAccessToken => _plaidAccessToken;
  set plaidAccessToken(String value) {
    _plaidAccessToken = value;
    secureStorage.setString('ff_plaidAccessToken', value);
  }

  void deletePlaidAccessToken() {
    secureStorage.delete(key: 'ff_plaidAccessToken');
  }

  List<dynamic> _monthlySpending = [];
  List<dynamic> get monthlySpending => _monthlySpending;
  set monthlySpending(List<dynamic> value) {
    _monthlySpending = value;
  }

  void addToMonthlySpending(dynamic value) {
    monthlySpending.add(value);
  }

  void removeFromMonthlySpending(dynamic value) {
    monthlySpending.remove(value);
  }

  void removeAtIndexFromMonthlySpending(int index) {
    monthlySpending.removeAt(index);
  }

  void updateMonthlySpendingAtIndex(
    int index,
    dynamic Function(dynamic) updateFn,
  ) {
    monthlySpending[index] = updateFn(_monthlySpending[index]);
  }

  void insertAtIndexInMonthlySpending(int index, dynamic value) {
    monthlySpending.insert(index, value);
  }

  List<double> _chartAmounts = [];
  List<double> get chartAmounts => _chartAmounts;
  set chartAmounts(List<double> value) {
    _chartAmounts = value;
  }

  void addToChartAmounts(double value) {
    chartAmounts.add(value);
  }

  void removeFromChartAmounts(double value) {
    chartAmounts.remove(value);
  }

  void removeAtIndexFromChartAmounts(int index) {
    chartAmounts.removeAt(index);
  }

  void updateChartAmountsAtIndex(
    int index,
    double Function(double) updateFn,
  ) {
    chartAmounts[index] = updateFn(_chartAmounts[index]);
  }

  void insertAtIndexInChartAmounts(int index, double value) {
    chartAmounts.insert(index, value);
  }

  List<double> _chartLabels = [];
  List<double> get chartLabels => _chartLabels;
  set chartLabels(List<double> value) {
    _chartLabels = value;
  }

  void addToChartLabels(double value) {
    chartLabels.add(value);
  }

  void removeFromChartLabels(double value) {
    chartLabels.remove(value);
  }

  void removeAtIndexFromChartLabels(int index) {
    chartLabels.removeAt(index);
  }

  void updateChartLabelsAtIndex(
    int index,
    double Function(double) updateFn,
  ) {
    chartLabels[index] = updateFn(_chartLabels[index]);
  }

  void insertAtIndexInChartLabels(int index, double value) {
    chartLabels.insert(index, value);
  }

  String _apiK = 'AIzaSyCNUZfb5SD68P6IQMV8-wD1DyFnrAssEa4';
  String get apiK => _apiK;
  set apiK(String value) {
    _apiK = value;
    secureStorage.setString('ff_apiK', value);
  }

  void deleteApiK() {
    secureStorage.delete(key: 'ff_apiK');
  }

  /// Gemini insights app state variable
  String _AiInsights = '';
  String get AiInsights => _AiInsights;
  set AiInsights(String value) {
    _AiInsights = value;
  }

  List<dynamic> _lastweekTransactions = [];
  List<dynamic> get lastweekTransactions => _lastweekTransactions;
  set lastweekTransactions(List<dynamic> value) {
    _lastweekTransactions = value;
  }

  void addToLastweekTransactions(dynamic value) {
    lastweekTransactions.add(value);
  }

  void removeFromLastweekTransactions(dynamic value) {
    lastweekTransactions.remove(value);
  }

  void removeAtIndexFromLastweekTransactions(int index) {
    lastweekTransactions.removeAt(index);
  }

  void updateLastweekTransactionsAtIndex(
    int index,
    dynamic Function(dynamic) updateFn,
  ) {
    lastweekTransactions[index] = updateFn(_lastweekTransactions[index]);
  }

  void insertAtIndexInLastweekTransactions(int index, dynamic value) {
    lastweekTransactions.insert(index, value);
  }

  List<dynamic> _thisweekTransactions = [];
  List<dynamic> get thisweekTransactions => _thisweekTransactions;
  set thisweekTransactions(List<dynamic> value) {
    _thisweekTransactions = value;
  }

  void addToThisweekTransactions(dynamic value) {
    thisweekTransactions.add(value);
  }

  void removeFromThisweekTransactions(dynamic value) {
    thisweekTransactions.remove(value);
  }

  void removeAtIndexFromThisweekTransactions(int index) {
    thisweekTransactions.removeAt(index);
  }

  void updateThisweekTransactionsAtIndex(
    int index,
    dynamic Function(dynamic) updateFn,
  ) {
    thisweekTransactions[index] = updateFn(_thisweekTransactions[index]);
  }

  void insertAtIndexInThisweekTransactions(int index, dynamic value) {
    thisweekTransactions.insert(index, value);
  }

  String _trendLeftLabel = '';
  String get trendLeftLabel => _trendLeftLabel;
  set trendLeftLabel(String value) {
    _trendLeftLabel = value;
  }

  String _trendRightLable = '';
  String get trendRightLable => _trendRightLable;
  set trendRightLable(String value) {
    _trendRightLable = value;
  }

  List<String> _categoryList = [];
  List<String> get categoryList => _categoryList;
  set categoryList(List<String> value) {
    _categoryList = value;
  }

  void addToCategoryList(String value) {
    categoryList.add(value);
  }

  void removeFromCategoryList(String value) {
    categoryList.remove(value);
  }

  void removeAtIndexFromCategoryList(int index) {
    categoryList.removeAt(index);
  }

  void updateCategoryListAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    categoryList[index] = updateFn(_categoryList[index]);
  }

  void insertAtIndexInCategoryList(int index, String value) {
    categoryList.insert(index, value);
  }

  List<dynamic> _formattedTransactions = [];
  List<dynamic> get formattedTransactions => _formattedTransactions;
  set formattedTransactions(List<dynamic> value) {
    _formattedTransactions = value;
  }

  void addToFormattedTransactions(dynamic value) {
    formattedTransactions.add(value);
  }

  void removeFromFormattedTransactions(dynamic value) {
    formattedTransactions.remove(value);
  }

  void removeAtIndexFromFormattedTransactions(int index) {
    formattedTransactions.removeAt(index);
  }

  void updateFormattedTransactionsAtIndex(
    int index,
    dynamic Function(dynamic) updateFn,
  ) {
    formattedTransactions[index] = updateFn(_formattedTransactions[index]);
  }

  void insertAtIndexInFormattedTransactions(int index, dynamic value) {
    formattedTransactions.insert(index, value);
  }

  List<String> _availableCategories = [];
  List<String> get availableCategories => _availableCategories;
  set availableCategories(List<String> value) {
    _availableCategories = value;
  }

  void addToAvailableCategories(String value) {
    availableCategories.add(value);
  }

  void removeFromAvailableCategories(String value) {
    availableCategories.remove(value);
  }

  void removeAtIndexFromAvailableCategories(int index) {
    availableCategories.removeAt(index);
  }

  void updateAvailableCategoriesAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    availableCategories[index] = updateFn(_availableCategories[index]);
  }

  void insertAtIndexInAvailableCategories(int index, String value) {
    availableCategories.insert(index, value);
  }

  List<dynamic> _detailFiltTransact = [];
  List<dynamic> get detailFiltTransact => _detailFiltTransact;
  set detailFiltTransact(List<dynamic> value) {
    _detailFiltTransact = value;
  }

  void addToDetailFiltTransact(dynamic value) {
    detailFiltTransact.add(value);
  }

  void removeFromDetailFiltTransact(dynamic value) {
    detailFiltTransact.remove(value);
  }

  void removeAtIndexFromDetailFiltTransact(int index) {
    detailFiltTransact.removeAt(index);
  }

  void updateDetailFiltTransactAtIndex(
    int index,
    dynamic Function(dynamic) updateFn,
  ) {
    detailFiltTransact[index] = updateFn(_detailFiltTransact[index]);
  }

  void insertAtIndexInDetailFiltTransact(int index, dynamic value) {
    detailFiltTransact.insert(index, value);
  }

  dynamic _weeklySummaryStats;
  dynamic get weeklySummaryStats => _weeklySummaryStats;
  set weeklySummaryStats(dynamic value) {
    _weeklySummaryStats = value;
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

extension FlutterSecureStorageExtensions on FlutterSecureStorage {
  static final _lock = Lock();

  Future<void> writeSync({required String key, String? value}) async =>
      await _lock.synchronized(() async {
        await write(key: key, value: value);
      });

  void remove(String key) => delete(key: key);

  Future<String?> getString(String key) async => await read(key: key);
  Future<void> setString(String key, String value) async =>
      await writeSync(key: key, value: value);

  Future<bool?> getBool(String key) async => (await read(key: key)) == 'true';
  Future<void> setBool(String key, bool value) async =>
      await writeSync(key: key, value: value.toString());

  Future<int?> getInt(String key) async =>
      int.tryParse(await read(key: key) ?? '');
  Future<void> setInt(String key, int value) async =>
      await writeSync(key: key, value: value.toString());

  Future<double?> getDouble(String key) async =>
      double.tryParse(await read(key: key) ?? '');
  Future<void> setDouble(String key, double value) async =>
      await writeSync(key: key, value: value.toString());

  Future<List<String>?> getStringList(String key) async =>
      await read(key: key).then((result) {
        if (result == null || result.isEmpty) {
          return null;
        }
        return CsvToListConverter()
            .convert(result)
            .first
            .map((e) => e.toString())
            .toList();
      });
  Future<void> setStringList(String key, List<String> value) async =>
      await writeSync(key: key, value: ListToCsvConverter().convert([value]));
}
