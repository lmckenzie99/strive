import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'trend_analysis_widget.dart' show TrendAnalysisWidget;
import 'package:flutter/material.dart';

class TrendAnalysisModel extends FlutterFlowModel<TrendAnalysisWidget> {
  ///  Local state fields for this page.

  dynamic aiInsights;

  bool isLoadingInsights = false;

  String geminiAPIKey = 'AIzaSyCNUZfb5SD68P6IQMV8-wD1DyFnrAssEa4';

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - monthlyFilter] action in TrendAnalysis widget.
  List<dynamic>? thisWeekTransactions;
  // Stores action output result for [Custom Action - monthlyFilter] action in TrendAnalysis widget.
  List<dynamic>? lastWeekTransactions;
  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
  // Stores action output result for [Custom Action - weeklyFilter] action in DropDown widget.
  List<dynamic>? lastWeekResult;
  // Stores action output result for [Custom Action - weeklyFilter] action in DropDown widget.
  List<dynamic>? thisWeekResult;
  // Stores action output result for [Custom Action - monthlyFilter] action in DropDown widget.
  List<dynamic>? monthlyLastWeekResult;
  // Stores action output result for [Custom Action - monthlyFilter] action in DropDown widget.
  List<dynamic>? monthlyThisWeekResult;
  // Stores action output result for [Custom Action - analyzeTransactionsWithGemini] action in Button widget.
  String? geminiInsights;
  // Stores action output result for [Custom Action - monthlyFilter] action in Button widget.
  List<dynamic>? testLastWeek;
  // Stores action output result for [Custom Action - monthlyFilter] action in Button widget.
  List<dynamic>? testThisWeek;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
