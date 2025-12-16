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

    await tester.pumpAndSettle(const Duration(milliseconds: 100));
    await tester.tap(find.byKey(const ValueKey('emailAddress_Create_eqmw')));
    await tester.pumpAndSettle(const Duration(milliseconds: 100));
    await tester.enterText(
        find.byKey(const ValueKey('emailAddress_Create_eqmw')),
        'test1@test.com');
    await tester.pumpAndSettle(const Duration(milliseconds: 100));
    await tester.tap(find.byKey(const ValueKey('password_Create_ajqt')));
    await tester.pumpAndSettle(const Duration(milliseconds: 100));
    await tester.enterText(
        find.byKey(const ValueKey('password_Create_ajqt')), 'test123');
    await tester.pumpAndSettle(const Duration(milliseconds: 100));
    await tester.tap(find.byKey(const ValueKey('password_Conf_kubt')));
    await tester.pumpAndSettle(const Duration(milliseconds: 100));
    await tester.enterText(
        find.byKey(const ValueKey('password_Conf_kubt')), 'test123');
    await tester.pumpAndSettle(const Duration(milliseconds: 100));
    await tester.tap(find.byKey(const ValueKey('Button_jc03')));
    await tester.pumpAndSettle(const Duration(milliseconds: 100));
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

    await tester.tap(find.byKey(const ValueKey('UNDEFINED')));
    await tester.tap(find.byKey(const ValueKey('UNDEFINED')));
    await tester.tap(find.byKey(const ValueKey('UNDEFINED')));
    await tester.tap(find.byKey(const ValueKey('UNDEFINED')));
    await tester.pumpAndSettle(
      const Duration(milliseconds: 3),
      EnginePhase.sendSemanticsUpdate,
      const Duration(milliseconds: 12),
    );
    await tester.tap(find.byKey(const ValueKey('UNDEFINED')));
    await tester.pumpAndSettle(
      const Duration(milliseconds: 5),
      EnginePhase.sendSemanticsUpdate,
      const Duration(milliseconds: 15),
    );
    expect(find.byKey(const ValueKey('Settings_v2lp')), findsWidgets);
    await tester.tap(find.byKey(const ValueKey('UNDEFINED')));
    await tester.pumpAndSettle(
      const Duration(milliseconds: 5),
      EnginePhase.sendSemanticsUpdate,
      const Duration(milliseconds: 15),
    );
    expect(find.byKey(const ValueKey('Column_3fpv')), findsWidgets);
    await tester.tap(find.byKey(const ValueKey('UNDEFINED')));
    await tester.pumpAndSettle(
      const Duration(milliseconds: 5),
      EnginePhase.sendSemanticsUpdate,
      const Duration(milliseconds: 15),
    );
    expect(find.byKey(const ValueKey('CreateAccount_f6i8')), findsWidgets);
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

    await tester.enterText(find.byKey(const ValueKey('emailAddress_1rls')),
        'test-email3@gmail.com');
    await tester.enterText(
        find.byKey(const ValueKey('password_i5zf')), 'test-pass');
    await tester.tap(find.byKey(const ValueKey('Button_byib')));
    await tester.pumpAndSettle(const Duration(milliseconds: 3000));
    expect(find.byKey(const ValueKey('Container_8jy7')), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('UNDEFINED')));
    await tester.pumpAndSettle(const Duration(milliseconds: 3000));
    await tester.tap(find.text('Detailed View'));
    await tester.pumpAndSettle(const Duration(milliseconds: 3000));
    expect(find.byKey(const ValueKey('UNDEFINED')), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('UNDEFINED')));
    await tester.pumpAndSettle(const Duration(milliseconds: 3000));
    await tester.tap(find.text('Trend Analysis'));
    await tester.pumpAndSettle(const Duration(milliseconds: 3000));
    expect(find.byKey(const ValueKey('Container_c7hu')), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('IconButton_5vi1')));
    await tester.pumpAndSettle(const Duration(milliseconds: 3000));
    await tester.tap(find.text('Guidance'));
    await tester.pumpAndSettle(const Duration(milliseconds: 3000));
    expect(find.byKey(const ValueKey('Container_tevx')), findsOneWidget);
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
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('Text_btct')),
      100.0,
      scrollable: find
          .descendant(
            of: find.text('Summary'),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.pumpAndSettle(const Duration(milliseconds: 3000));
    // Note this will eventually be a graph, for now we look for 'Graph' placeholder
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('UNDEFINED')),
      100.0,
      scrollable: find
          .descendant(
            of: find.text('Account Graph from Plaid'),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.pumpAndSettle(const Duration(milliseconds: 3000));
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('Text_0rus')),
      100.0,
      scrollable: find
          .descendant(
            of: find.text('Additional Info'),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.pumpAndSettle(const Duration(milliseconds: 3000));
    // Note - will currently pass because prompt is just an image. this should fail  because the ai prompt is not implemented yet
    await tester.tap(find.byKey(const ValueKey('Image_02n0')));
    await tester.pumpAndSettle(const Duration(milliseconds: 3000));
    // likely will fail since prereq of this test is to be signed in to an account
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('UNDEFINED')),
      100.0,
      scrollable: find
          .descendant(
            of: find.text('Link Account'),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.pumpAndSettle(const Duration(milliseconds: 3000));
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('UNDEFINED')),
      100.0,
      scrollable: find
          .descendant(
            of: find.text('Refresh App'),
            matching: find.byType(Scrollable),
          )
          .first,
    );
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
