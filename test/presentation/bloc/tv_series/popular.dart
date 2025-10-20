import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_popular_tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_series/popular/popular_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../pages/tv_series/popular_tv_series_page.mocks.dart';

@GenerateMocks([GetPopularTvSeries])
void main() {
  late MockGetPopularTvSeries mockGetPopularTvSeries;
  late PopularBloc popularBloc;

  setUp(() {
    mockGetPopularTvSeries = MockGetPopularTvSeries();
    popularBloc = PopularBloc(mockGetPopularTvSeries);
  });

  final tTvSeries = TvSeries(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    name: 'name',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    firstAirDate: DateTime.now(),
    originalLanguage: "originalLanguage",
    originalName: "originalName",
    originCountry: ["originCountry"],
    voteAverage: 1,
    voteCount: 1,
  );
  final tTvSeriesList = <TvSeries>[tTvSeries];

  group('PopularBloc', () {
    group('Initial State', () {
      test('should have correct initial state', () {
        expect(popularBloc.state, const PopularState());
        expect(popularBloc.state.tvSeries, isEmpty);
        expect(popularBloc.state.message, isEmpty);
      });
    });

    group('FetchPopular Event', () {
      blocTest<PopularBloc, PopularState>(
        'should emit [PopularLoading, PopularLoaded] when data is gotten successfully',
        build: () {
          when(mockGetPopularTvSeries.execute())
              .thenAnswer((_) async => Right(tTvSeriesList));
          return popularBloc;
        },
        act: (bloc) => bloc.add(FetchPopular()),
        expect: () => [
          const PopularLoading(),
          PopularLoaded(tTvSeriesList),
        ],
        verify: (bloc) {
          verify(mockGetPopularTvSeries.execute()).called(1);
        },
      );

      blocTest<PopularBloc, PopularState>(
        'should emit [PopularLoading, PopularLoaded] with empty list when data is empty',
        build: () {
          when(mockGetPopularTvSeries.execute())
              .thenAnswer((_) async => const Right(<TvSeries>[]));
          return popularBloc;
        },
        act: (bloc) => bloc.add(FetchPopular()),
        expect: () => [
          const PopularLoading(),
          const PopularLoaded(<TvSeries>[]),
        ],
        verify: (bloc) {
          verify(mockGetPopularTvSeries.execute()).called(1);
        },
      );

      blocTest<PopularBloc, PopularState>(
        'should emit [PopularLoading, PopularError] when ServerFailure occurs',
        build: () {
          when(mockGetPopularTvSeries.execute())
              .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
          return popularBloc;
        },
        act: (bloc) => bloc.add(FetchPopular()),
        expect: () => [
          const PopularLoading(),
          const PopularError('Server Failure'),
        ],
        verify: (bloc) {
          verify(mockGetPopularTvSeries.execute()).called(1);
        },
      );

      blocTest<PopularBloc, PopularState>(
        'should emit [PopularLoading, PopularError] when ConnectionFailure occurs',
        build: () {
          when(mockGetPopularTvSeries.execute()).thenAnswer(
              (_) async => Left(ConnectionFailure('Connection Failure')));
          return popularBloc;
        },
        act: (bloc) => bloc.add(FetchPopular()),
        expect: () => [
          const PopularLoading(),
          const PopularError('Connection Failure'),
        ],
        verify: (bloc) {
          verify(mockGetPopularTvSeries.execute()).called(1);
        },
      );

      blocTest<PopularBloc, PopularState>(
        'should emit [PopularLoading, PopularError] when DatabaseFailure occurs',
        build: () {
          when(mockGetPopularTvSeries.execute()).thenAnswer(
              (_) async => Left(DatabaseFailure('Database Failure')));
          return popularBloc;
        },
        act: (bloc) => bloc.add(FetchPopular()),
        expect: () => [
          const PopularLoading(),
          const PopularError('Database Failure'),
        ],
        verify: (bloc) {
          verify(mockGetPopularTvSeries.execute()).called(1);
        },
      );

      blocTest<PopularBloc, PopularState>(
        'should emit [PopularLoading, PopularError] when usecase throws exception',
        build: () {
          when(mockGetPopularTvSeries.execute())
              .thenThrow(Exception('Unexpected error'));
          return popularBloc;
        },
        act: (bloc) => bloc.add(FetchPopular()),
        expect: () => [
          const PopularLoading(),
          const PopularError('Exception: Exception: Unexpected error'),
        ],
        verify: (bloc) {
          verify(mockGetPopularTvSeries.execute()).called(1);
        },
      );

      test('should not emit new states when bloc is closed', () async {
        when(mockGetPopularTvSeries.execute())
            .thenAnswer((_) async => Right(tTvSeriesList));

        // Add event before closing
        popularBloc.add(FetchPopular());

        // Wait for the event to be processed
        await Future.delayed(const Duration(milliseconds: 100));

        // Close the bloc
        popularBloc.close();

        // Verify that the use case was called before closing
        verify(mockGetPopularTvSeries.execute()).called(1);

        // Reset the mock
        reset(mockGetPopularTvSeries);

        // Try to add another event after closing (this should be ignored)
        try {
          popularBloc.add(FetchPopular());
        } catch (e) {
          // Expected to throw an error when trying to add events to closed bloc
          expect(e.toString(),
              contains('Cannot add new events after calling close'));
        }

        // Verify that no additional calls were made
        verifyNever(mockGetPopularTvSeries.execute());
      });
    });

    group('State Properties', () {
      test('PopularState should have correct properties', () {
        final state = PopularState(tvSeries: tTvSeriesList, message: 'test');
        expect(state.tvSeries, tTvSeriesList);
        expect(state.message, 'test');
        expect(state.props, [tTvSeriesList, 'test']);
      });

      test('PopularLoading should have correct properties', () {
        const state = PopularLoading();
        expect(state.tvSeries, isEmpty);
        expect(state.message, isEmpty);
        expect(state.props, [<TvSeries>[], '']);
      });

      test('PopularLoaded should have correct properties', () {
        final state = PopularLoaded(tTvSeriesList);
        expect(state.tvSeries, tTvSeriesList);
        expect(state.message, isEmpty);
        expect(state.props, [tTvSeriesList, '']);
      });

      test('PopularError should have correct properties', () {
        const state = PopularError('Error message');
        expect(state.tvSeries, isEmpty);
        expect(state.message, 'Error message');
        expect(state.props, [<TvSeries>[], 'Error message']);
      });
    });

    group('State Equality', () {
      test('PopularState instances with same data should be equal', () {
        final state1 = PopularState(tvSeries: tTvSeriesList, message: 'test');
        final state2 = PopularState(tvSeries: tTvSeriesList, message: 'test');
        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
      });

      test('PopularState instances with different data should not be equal',
          () {
        final state1 = PopularState(tvSeries: tTvSeriesList, message: 'test1');
        final state2 = PopularState(tvSeries: tTvSeriesList, message: 'test2');
        expect(state1, isNot(equals(state2)));
      });

      test('PopularLoading instances should be equal', () {
        const state1 = PopularLoading();
        const state2 = PopularLoading();
        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
      });

      test('PopularLoaded instances with same data should be equal', () {
        final state1 = PopularLoaded(tTvSeriesList);
        final state2 = PopularLoaded(tTvSeriesList);
        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
      });

      test('PopularError instances with same message should be equal', () {
        const state1 = PopularError('Error message');
        const state2 = PopularError('Error message');
        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
      });
    });

    group('Multiple Events', () {
      blocTest<PopularBloc, PopularState>(
        'should handle multiple FetchPopular events correctly',
        build: () {
          when(mockGetPopularTvSeries.execute())
              .thenAnswer((_) async => Right(tTvSeriesList));
          return popularBloc;
        },
        act: (bloc) {
          bloc.add(FetchPopular());
          bloc.add(FetchPopular());
        },
        expect: () => [
          const PopularLoading(),
          PopularLoaded(tTvSeriesList),
          const PopularLoading(),
          PopularLoaded(tTvSeriesList),
        ],
        verify: (bloc) {
          verify(mockGetPopularTvSeries.execute()).called(2);
        },
      );

      test('should handle mixed success and error events', () async {
        // First event - success
        when(mockGetPopularTvSeries.execute())
            .thenAnswer((_) async => Right(tTvSeriesList));

        final successBloc = PopularBloc(mockGetPopularTvSeries);
        successBloc.add(FetchPopular());

        await expectLater(
          successBloc.stream,
          emitsInOrder([
            const PopularLoading(),
            PopularLoaded(tTvSeriesList),
          ]),
        );

        // Second event - error
        when(mockGetPopularTvSeries.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Error')));

        final errorBloc = PopularBloc(mockGetPopularTvSeries);
        errorBloc.add(FetchPopular());

        await expectLater(
          errorBloc.stream,
          emitsInOrder([
            const PopularLoading(),
            const PopularError('Server Error'),
          ]),
        );

        verify(mockGetPopularTvSeries.execute()).called(2);
      });
    });
  });
}
