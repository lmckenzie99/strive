import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'a_i_button_component_widget.dart' show AIButtonComponentWidget;
import 'package:flutter/material.dart';

class AIButtonComponentModel extends FlutterFlowModel<AIButtonComponentWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for TextField_question widget.
  FocusNode? textFieldQuestionFocusNode1;
  TextEditingController? textFieldQuestionTextController1;
  String? Function(BuildContext, String?)?
      textFieldQuestionTextController1Validator;
  // State field(s) for TextField_question widget.
  FocusNode? textFieldQuestionFocusNode2;
  TextEditingController? textFieldQuestionTextController2;
  String? Function(BuildContext, String?)?
      textFieldQuestionTextController2Validator;
  // Stores action output result for [Backend Call - API (getAIResponse)] action in Button widget.
  ApiCallResponse? apiResponsessssssss;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldQuestionFocusNode1?.dispose();
    textFieldQuestionTextController1?.dispose();

    textFieldQuestionFocusNode2?.dispose();
    textFieldQuestionTextController2?.dispose();
  }

  /// Action blocks.
  Future apiResponse(BuildContext context) async {
    ApiCallResponse? responseFromAI;

    responseFromAI = await GetAIResponseCall.call(
      message: textFieldQuestionTextController1.text,
    );

    if ((responseFromAI.succeeded ?? true) == true) {
      FFAppState().responseFromGemini = getJsonField(
        (responseFromAI.jsonBody ?? ''),
        r'''$.response_text''',
      ).toString();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '',
            style: TextStyle(
              color: FlutterFlowTheme.of(context).primaryText,
            ),
          ),
          duration: Duration(milliseconds: 4000),
          backgroundColor: FlutterFlowTheme.of(context).secondary,
        ),
      );
    }
  }
}
