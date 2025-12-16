import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'n_p_s_screen_widget.dart' show NPSScreenWidget;
import 'package:flutter/material.dart';

class NPSScreenModel extends FlutterFlowModel<NPSScreenWidget> {
  ///  Local state fields for this page.

  int? selectedNumber = 8;

  DocumentReference? currentNPSMetric;

  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
