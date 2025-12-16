import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'a_i_button_component_model.dart';
export 'a_i_button_component_model.dart';

class AIButtonComponentWidget extends StatefulWidget {
  const AIButtonComponentWidget({super.key});

  @override
  State<AIButtonComponentWidget> createState() =>
      _AIButtonComponentWidgetState();
}

class _AIButtonComponentWidgetState extends State<AIButtonComponentWidget> {
  late AIButtonComponentModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AIButtonComponentModel());

    _model.textFieldQuestionTextController1 ??= TextEditingController();
    _model.textFieldQuestionFocusNode1 ??= FocusNode();

    _model.textFieldQuestionTextController2 ??= TextEditingController();
    _model.textFieldQuestionFocusNode2 ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Questions?',
          style: FlutterFlowTheme.of(context).titleMedium.override(
                font: GoogleFonts.interTight(
                  fontWeight: FontWeight.w600,
                  fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
                ),
                color: FlutterFlowTheme.of(context).primary,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w600,
                fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
              ),
        ),
        SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (FFAppState().responseFromGemini == '')
                TextFormField(
                  controller: _model.textFieldQuestionTextController1,
                  focusNode: _model.textFieldQuestionFocusNode1,
                  autofocus: false,
                  obscureText: false,
                  decoration: InputDecoration(
                    hintText: 'Type your quesitons here',
                    hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.inter(
                            fontWeight: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                          color: FlutterFlowTheme.of(context).primaryText,
                          letterSpacing: 0.0,
                          fontWeight: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFDAE5E1),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).primary,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    filled: true,
                    fillColor: Color(0xFFDAE5E1),
                    contentPadding: EdgeInsets.all(16.0),
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.inter(
                          fontWeight: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                        color: FlutterFlowTheme.of(context).primaryText,
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                  maxLines: 4,
                  minLines: 3,
                  keyboardType: TextInputType.multiline,
                  cursorColor: FlutterFlowTheme.of(context).primary,
                  validator: _model.textFieldQuestionTextController1Validator
                      .asValidator(context),
                ),
              if (FFAppState().responseFromGemini != '')
                TextFormField(
                  controller: _model.textFieldQuestionTextController2,
                  focusNode: _model.textFieldQuestionFocusNode2,
                  autofocus: false,
                  obscureText: false,
                  decoration: InputDecoration(
                    hintText: FFAppState().responseFromGemini,
                    hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.inter(
                            fontWeight: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                          color: FlutterFlowTheme.of(context).primaryText,
                          letterSpacing: 0.0,
                          fontWeight: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFDAE5E1),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).primary,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x00000000),
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    filled: true,
                    fillColor: Color(0xFFDAE5E1),
                    contentPadding: EdgeInsets.all(16.0),
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.inter(
                          fontWeight: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                        color: FlutterFlowTheme.of(context).primaryText,
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                  maxLines: 4,
                  minLines: 3,
                  keyboardType: TextInputType.multiline,
                  cursorColor: FlutterFlowTheme.of(context).primary,
                  validator: _model.textFieldQuestionTextController2Validator
                      .asValidator(context),
                ),
            ],
          ),
        ),
        FFButtonWidget(
          onPressed: () async {
            _model.apiResponsessssssss = await GetAIResponseCall.call(
              message: _model.textFieldQuestionTextController1.text,
            );

            if ((_model.apiResponsessssssss?.succeeded ?? true)) {
              FFAppState().responseFromGemini = getJsonField(
                (_model.apiResponsessssssss?.jsonBody ?? ''),
                r'''$.response_text''',
              ).toString();
              safeSetState(() {});
              await Future.delayed(
                Duration(
                  milliseconds: 20000,
                ),
              );
              FFAppState().deleteResponseFromGemini();
              FFAppState().responseFromGemini = '';

              safeSetState(() {});
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

            safeSetState(() {});
          },
          text: 'Ask',
          icon: Icon(
            Icons.send_rounded,
            size: 20.0,
          ),
          options: FFButtonOptions(
            width: double.infinity,
            height: 50.0,
            padding: EdgeInsets.all(8.0),
            iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
            iconColor: Colors.white,
            color: FlutterFlowTheme.of(context).primary,
            textStyle: FlutterFlowTheme.of(context).titleMedium.override(
                  font: GoogleFonts.interTight(
                    fontWeight: FontWeight.w600,
                    fontStyle:
                        FlutterFlowTheme.of(context).titleMedium.fontStyle,
                  ),
                  color: Colors.white,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                  fontStyle: FlutterFlowTheme.of(context).titleMedium.fontStyle,
                ),
            elevation: 2.0,
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ].divide(SizedBox(height: 16.0)),
    );
  }
}
