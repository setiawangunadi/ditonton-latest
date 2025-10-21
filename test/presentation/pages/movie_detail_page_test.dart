import 'dart:async';

import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/movie/detail/detail_bloc.dart' as detail_bloc;
import 'package:ditonton/presentation/pages/movie/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';

class MockDetailBloc extends Mock implements detail_bloc.DetailBloc {}

void main() {
  late MockDetailBloc mockDetailBloc;
  late StreamController<detail_bloc.DetailState> stateController;

  setUp(() {
    mockDetailBloc = MockDetailBloc();
    stateController = StreamController<detail_bloc.DetailState>();

    when(mockDetailBloc.stream).thenAnswer((_) => stateController.stream);
  });

  tearDown(() async {
    await stateController.close();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<detail_bloc.DetailBloc>.value(
      value: mockDetailBloc,
      child: MaterialApp(home: body),
    );
  }

  detail_bloc.DetailState _baseLoadedState({required bool added}) {
    return detail_bloc.DetailState(
      movie: testMovieDetail,
      recommendations: const <Movie>[],
      isAddedToWatchlist: added,
      isLoadingDetail: false,
      isLoadingRecommendations: false,
      message: '',
    );
  }

  testWidgets('Watchlist button shows add icon when not added', (tester) async {
    final state = _baseLoadedState(added: false);
    when(mockDetailBloc.state).thenReturn(state);
    stateController.add(state);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('Watchlist button shows check icon when added', (tester) async {
    final state = _baseLoadedState(added: true);
    when(mockDetailBloc.state).thenReturn(state);
    stateController.add(state);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('Shows SnackBar when message is success', (tester) async {
    // initial loaded state
    final loaded = _baseLoadedState(added: false);
    // then a state with success message 'Added to Watchlist'
    final success = loaded.copyWith(message: 'Added to Watchlist');

    when(mockDetailBloc.state).thenReturn(loaded);
    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    // push the success state to trigger listener
    stateController.add(success);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets('Shows AlertDialog when message is failure', (tester) async {
    final loaded = _baseLoadedState(added: false);
    final failure = loaded.copyWith(message: 'Failed');

    when(mockDetailBloc.state).thenReturn(loaded);
    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    stateController.add(failure);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });
}
