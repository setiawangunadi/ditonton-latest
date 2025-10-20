import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'watchlist_event.dart';
part 'watchlist_state.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  final GetWatchlistMovies getWatchlistMovies;

  WatchlistBloc({required this.getWatchlistMovies}) : super(const WatchlistState()) {
    on<WatchlistRequested>(_onWatchlistRequested);
  }

  Future<void> _onWatchlistRequested(
    WatchlistRequested event,
    Emitter<WatchlistState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, message: ''));

    final result = await getWatchlistMovies.execute();
    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, message: failure.message));
      },
      (moviesData) {
        emit(state.copyWith(isLoading: false, items: moviesData));
      },
    );
  }
}


