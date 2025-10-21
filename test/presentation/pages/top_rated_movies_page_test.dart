import 'dart:async';

import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/movie/top_rated/top_rated_bloc.dart' as top_bloc;
import 'package:ditonton/presentation/pages/movie/top_rated_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockTopRatedBloc extends Mock implements top_bloc.TopRatedBloc {}

void main() {
  late MockTopRatedBloc mockTopBloc;
  late StreamController<top_bloc.TopRatedState> stateController;

  setUp(() {
    mockTopBloc = MockTopRatedBloc();
    stateController = StreamController<top_bloc.TopRatedState>();

    when(mockTopBloc.stream).thenAnswer((_) => stateController.stream);
  });

  tearDown(() async {
    await stateController.close();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<top_bloc.TopRatedBloc>.value(
      value: mockTopBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('should show progress when loading', (tester) async {
    when(mockTopBloc.state).thenReturn(const top_bloc.TopRatedLoading());
    stateController.add(const top_bloc.TopRatedLoading());

    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byType(Center), findsWidgets);
  });

  testWidgets('should show ListView when loaded', (tester) async {
    final loaded = top_bloc.TopRatedLoaded(<Movie>[]);
    when(mockTopBloc.state).thenReturn(loaded);
    stateController.add(loaded);

    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('should show error text when error', (tester) async {
    final error = top_bloc.TopRatedError('Error message');
    when(mockTopBloc.state).thenReturn(error);
    stateController.add(error);

    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviesPage()));

    expect(find.byKey(const Key('error_message')), findsOneWidget);
    expect(find.text('Error message'), findsOneWidget);
  });
}
