import 'dart:async';

import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/movie/popular/popular_bloc.dart' as popular_bloc;
import 'package:ditonton/presentation/pages/movie/popular_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockPopularBloc extends Mock implements popular_bloc.PopularBloc {}

void main() {
  late MockPopularBloc mockPopularBloc;
  late StreamController<popular_bloc.PopularState> stateController;

  setUp(() {
    mockPopularBloc = MockPopularBloc();
    stateController = StreamController<popular_bloc.PopularState>();

    when(mockPopularBloc.stream).thenAnswer((_) => stateController.stream);
  });

  tearDown(() async {
    await stateController.close();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<popular_bloc.PopularBloc>.value(
      value: mockPopularBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('should show progress when loading', (tester) async {
    when(mockPopularBloc.state).thenReturn(const popular_bloc.PopularLoading());
    stateController.add(const popular_bloc.PopularLoading());

    await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byType(Center), findsWidgets);
  });

  testWidgets('should show ListView when loaded', (tester) async {
    const loaded = popular_bloc.PopularLoaded(<Movie>[]);
    when(mockPopularBloc.state).thenReturn(loaded);
    stateController.add(loaded);

    await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('should show error text when error', (tester) async {
    const error = popular_bloc.PopularError('Error message');
    when(mockPopularBloc.state).thenReturn(error);
    stateController.add(error);

    await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

    expect(find.byKey(const Key('error_message')), findsOneWidget);
    expect(find.text('Error message'), findsOneWidget);
  });
}
