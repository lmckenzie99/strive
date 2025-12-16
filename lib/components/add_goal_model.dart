import '/flutter_flow/flutter_flow_util.dart';
import 'add_goal_widget.dart' show AddGoalWidget;
import 'package:flutter/material.dart';

class AddGoalModel extends FlutterFlowModel<AddGoalWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for Titles widget.
  FocusNode? titlesFocusNode;
  TextEditingController? titlesTextController;
  String? Function(BuildContext, String?)? titlesTextControllerValidator;
  // State field(s) for Details widget.
  FocusNode? detailsFocusNode;
  TextEditingController? detailsTextController;
  String? Function(BuildContext, String?)? detailsTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    titlesFocusNode?.dispose();
    titlesTextController?.dispose();

    detailsFocusNode?.dispose();
    detailsTextController?.dispose();
  }
}
