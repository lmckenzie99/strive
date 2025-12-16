import '/components/a_i_button_component_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'guidance_a_i_widget.dart' show GuidanceAIWidget;
import 'package:flutter/material.dart';

class GuidanceAIModel extends FlutterFlowModel<GuidanceAIWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for AIButtonComponent component.
  late AIButtonComponentModel aIButtonComponentModel;

  @override
  void initState(BuildContext context) {
    aIButtonComponentModel =
        createModel(context, () => AIButtonComponentModel());
  }

  @override
  void dispose() {
    aIButtonComponentModel.dispose();
  }
}
