import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:integration_test/integration_test.dart';
import 'package:strive/flutter_flow/flutter_flow_drop_down.dart';
import 'package:strive/flutter_flow/flutter_flow_icon_button.dart';
import 'package:strive/flutter_flow/flutter_flow_widgets.dart';
import 'package:strive/flutter_flow/flutter_flow_theme.dart';
import 'package:strive/index.dart';
import 'package:strive/main.dart';
import 'package:strive/flutter_flow/flutter_flow_util.dart';

import 'package:provider/provider.dart';
import 'package:strive/backend/firebase/firebase_config.dart';
import 'package:strive/auth/firebase_auth/auth_util.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initFirebase();
  });

  setUp(() async {
    await authManager.signOut();
    FFAppState.reset();
    final appState = FFAppState();
    await appState.initializePersistedState();
  });

  testWidgets('US1 Account Creation', (WidgetTester tester) async {
    _overrideOnError();

    await tester.pumpWidget(ChangeNotifierProvider(
      create: (context) => FFAppState(),
      child: MyApp(
        entryPage: CreateAccountWidget(),
      ),
    ));
    await GoogleFonts.pendingFonts();

    await tester.pumpAndSettle(const Duration(milliseconds: 10000));
    await tester.tap(find.byKey(const ValueKey('emailAddress_Create_eqmw')));
    await tester.pumpAndSettle(const Duration(milliseconds: 10000));
    await tester.enterText(
        find.byKey(const ValueKey('emailAddress_Create_eqmw')),
        'test100@test.com');
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle(const Duration(milliseconds: 10000));
    await tester.tap(find.byKey(const ValueKey('password_Create_ajqt')));
    await tester.pumpAndSettle(const Duration(milliseconds: 10000));
    await tester.enterText(
        find.byKey(const ValueKey('password_Create_ajqt')), 'test123');
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle(const Duration(milliseconds: 10000));
    await tester.tap(find.byKey(const ValueKey('password_Conf_kubt')));
    await tester.pumpAndSettle(const Duration(milliseconds: 10000));
    await tester.enterText(
        find.byKey(const ValueKey('password_Conf_kubt')), 'test123');
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle(const Duration(milliseconds: 10000));
    await tester.tap(find.byKey(const ValueKey('Button_jc03')));
    await tester.pumpAndSettle(const Duration(milliseconds: 10000));
    expect(find.byKey(const ValueKey('Text_ffb9')), findsWidgets);
  });

  testWidgets('US3ProfileCreation', (WidgetTester tester) async {
    _overrideOnError();
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: 'test@test.com', password: 'test123');
    await tester.pumpWidget(ChangeNotifierProvider(
      create: (context) => FFAppState(),
      child: const MyApp(),
    ));
    await GoogleFonts.pendingFonts();

    await tester.enterText(find.byKey(const ValueKey('Name_pdx6')), 'John');
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle(const Duration(milliseconds: 2000));
    await tester.tap(find.byKey(const ValueKey('IconButton_4oph')));
    await tester.pumpAndSettle(
      const Duration(milliseconds: 3000),
      EnginePhase.sendSemanticsUpdate,
      const Duration(milliseconds: 12),
    );
    await tester.tap(find.text('Guidance'));
    await tester.pumpAndSettle(
      const Duration(milliseconds: 5),
      EnginePhase.sendSemanticsUpdate,
      const Duration(milliseconds: 15),
    );
  });

  testWidgets('US4 Golden Path', (WidgetTester tester) async {
    _overrideOnError();

    await tester.pumpWidget(ChangeNotifierProvider(
      create: (context) => FFAppState(),
      child: MyApp(
        entryPage: LoginWidget(),
      ),
    ));
    await GoogleFonts.pendingFonts();

    await tester.enterText(
        find.byKey(const ValueKey('emailAddress_1rls')), 'test@test.com');
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle(const Duration(milliseconds: 3000));
    await tester.enterText(
        find.byKey(const ValueKey('password_i5zf')), 'test123');
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pumpAndSettle(const Duration(milliseconds: 3000));
    await tester.tap(find.byKey(const ValueKey('Button_byib')));
    await tester.pumpAndSettle(const Duration(milliseconds: 3000));
    expect(find.text('Summary'), findsOneWidget);
    await tester.pumpAndSettle(const Duration(milliseconds: 3000));
    await tester.tap(find.byKey(const ValueKey('IconButton_5yet')));
    await tester.pumpAndSettle(const Duration(milliseconds: 3000));
    await tester.tap(find.text('Detailed View'));
    await tester.pumpAndSettle(const Duration(milliseconds: 3000));
    expect(find.byKey(const ValueKey('Text_tt5q')), findsOneWidget);
    await tester.pumpAndSettle(const Duration(milliseconds: 30000));
    await tester.tap(find.byKey(const ValueKey('DropDown_g9s4')));
    await tester.pumpAndSettle(const Duration(milliseconds: 3000));
    await tester.tap(find.byKey(const ValueKey('IconButton_noge')));
    await tester.pumpAndSettle(const Duration(milliseconds: 3000));
    await tester.tap(find.text('Trend Analysis'));
    await tester.pumpAndSettle(const Duration(milliseconds: 3000));
    await tester.tap(find.byKey(const ValueKey('Button_l5bo')));
    await tester.pumpAndSettle(const Duration(milliseconds: 3000));
    await tester.tap(find.byKey(const ValueKey('IconButton_5vi1')));
    await tester.pumpAndSettle(const Duration(milliseconds: 3000));
    await tester.tap(find.text('Guidance'));
    await tester.pumpAndSettle(const Duration(milliseconds: 3000));
    await tester.tap(find.byKey(const ValueKey('AIButtonComponent_ee9m')));
  });

  testWidgets('US5 Splashscreen Unit Test', (WidgetTester tester) async {
    _overrideOnError();
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: 'test@test.com', password: 'test123');
    await tester.pumpWidget(ChangeNotifierProvider(
      create: (context) => FFAppState(),
      child: const MyApp(),
    ));
    await GoogleFonts.pendingFonts();

    await tester.pumpAndSettle(const Duration(milliseconds: 3000));
    await tester.tap(find.byKey(const ValueKey('Text_btct')));
    await tester.pumpAndSettle(const Duration(milliseconds: 3000));
    // Note this will eventually be a graph, for now we look for 'Graph' placeholder
    await tester.tap(find.byKey(const ValueKey('Chart_w2xu')));
    await tester.pumpAndSettle(const Duration(milliseconds: 3000));
  });

  testWidgets('US 2 User Login', (WidgetTester tester) async {
    _overrideOnError();

    await tester.pumpWidget(ChangeNotifierProvider(
      create: (context) => FFAppState(),
      child: MyApp(
        entryPage: LoginWidget(),
      ),
    ));
    await GoogleFonts.pendingFonts();

    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const ValueKey('emailAddress_1rls')),
        'christiancdcurrie@uri.edu');
    await tester.enterText(
        find.byKey(const ValueKey('password_i5zf')), 'Darkus@94295286');
    await tester.tap(find.byKey(const ValueKey('Button_byib')));
    await tester.pumpAndSettle(const Duration(milliseconds: 3000));
    expect(find.byKey(const ValueKey('Column_3fpv')), findsWidgets);
  });
}

// There are certain types of errors that can happen during tests but
// should not break the test.
void _overrideOnError() {
  final originalOnError = FlutterError.onError!;
  FlutterError.onError = (errorDetails) {
    if (_shouldIgnoreError(errorDetails.toString())) {
      return;
    }
    originalOnError(errorDetails);
  };
}

bool _shouldIgnoreError(String error) {
  // It can fail to decode some SVGs - this should not break the test.
  if (error.contains('ImageCodecException')) {
    return true;
  }
  // Overflows happen all over the place,
  // but they should not break tests.
  if (error.contains('overflowed by')) {
    return true;
  }
  // Sometimes some images fail to load, it generally does not break the test.
  if (error.contains('No host specified in URI') ||
      error.contains('EXCEPTION CAUGHT BY IMAGE RESOURCE SERVICE')) {
    return true;
  }
  // These errors should be avoided, but they should not break the test.
  if (error.contains('setState() called after dispose()')) {
    return true;
  }
  // Web-specific error when interacting with TextInputType.emailAddress
  if (error.contains('setSelectionRange') &&
      error.contains('HTMLInputElement')) {
    return true;
  }

  return false;
}
