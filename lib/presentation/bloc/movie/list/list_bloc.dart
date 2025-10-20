import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'list_event.dart';
part 'list_state.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  final GetNowPlayingMovies getNowPlayingMovies;
  final GetPopularMovies getPopularMovies;
  final GetTopRatedMovies getTopRatedMovies;

  ListBloc({
    required this.getNowPlayingMovies,
    required this.getPopularMovies,
    required this.getTopRatedMovies,
  }) : super(const ListState()) {
    on<FetchNowPlaying>(_onFetchNowPlaying);
    on<FetchPopular>(_onFetchPopular);
    on<FetchTopRated>(_onFetchTopRated);
  }

  Future<void> _onFetchNowPlaying(
    FetchNowPlaying event,
    Emitter<ListState> emit,
  ) async {
    emit(state.copyWith(
      isLoadingNowPlaying: true,
      messageNowPlaying: '',
    ));

    final result = await getNowPlayingMovies.execute();
    result.fold(
      (failure) {
        emit(state.copyWith(
          isLoadingNowPlaying: false,
          messageNowPlaying: failure.message,
        ));
      },
      (moviesData) {
        emit(state.copyWith(
          isLoadingNowPlaying: false,
          nowPlaying: moviesData,
        ));
      },
    );
  }

  Future<void> _onFetchPopular(
    FetchPopular event,
    Emitter<ListState> emit,
  ) async {
    emit(state.copyWith(
      isLoadingPopular: true,
      messagePopular: '',
    ));

    final result = await getPopularMovies.execute();
    result.fold(
      (failure) {
        emit(state.copyWith(
          isLoadingPopular: false,
          messagePopular: failure.message,
        ));
      },
      (moviesData) {
        emit(state.copyWith(
          isLoadingPopular: false,
          popular: moviesData,
        ));
      },
    );
  }

  Future<void> _onFetchTopRated(
    FetchTopRated event,
    Emitter<ListState> emit,
  ) async {
    emit(state.copyWith(
      isLoadingTopRated: true,
      messageTopRated: '',
    ));

    final result = await getTopRatedMovies.execute();
    result.fold(
      (failure) {
        emit(state.copyWith(
          isLoadingTopRated: false,
          messageTopRated: failure.message,
        ));
      },
      (moviesData) {
        emit(state.copyWith(
          isLoadingTopRated: false,
          topRated: moviesData,
        ));
      },
    );
  }
}


