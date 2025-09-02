// This is a basic Flutter widget test for the MyID app.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/annotations.dart';

import 'package:my_id/features/auth/domain/usecases/get_access_token.dart';
import 'package:my_id/features/auth/domain/usecases/get_user_details.dart';
import 'package:my_id/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:my_id/features/auth/presentation/pages/home_page.dart';

import 'widget_test.mocks.dart';

@GenerateMocks([GetAccessToken, GetUserDetails])
void main() {
  late MockGetAccessToken mockGetAccessToken;
  late MockGetUserDetails mockGetUserDetails;

  setUp(() {
    mockGetAccessToken = MockGetAccessToken();
    mockGetUserDetails = MockGetUserDetails();
  });

  testWidgets('MyID app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            getAccessToken: mockGetAccessToken,
            getUserDetails: mockGetUserDetails,
          ),
          child: const HomePage(),
        ),
      ),
    );

    // Verify that the app title is displayed.
    expect(find.text('MyID Authentication'), findsOneWidget);
    expect(find.text('Start SDK'), findsOneWidget);
  });
}
