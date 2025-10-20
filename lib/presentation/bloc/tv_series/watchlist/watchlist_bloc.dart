import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_watchlist_tv_series.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'watchlist_event.dart';
part 'watchlist_state.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  final GetWatchlistTvSeries getWatchlistTvSeries;

  WatchlistBloc({required this.getWatchlistTvSeries}) : super(const WatchlistState()) {
    on<WatchlistRequested>(_onWatchlistRequested);
  }

  Future<void> _onWatchlistRequested(
    WatchlistRequested event,
    Emitter<WatchlistState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, message: ''));

    final result = await getWatchlistTvSeries.execute();
    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, message: failure.message));
      },
      (tvSeriesData) {
        emit(state.copyWith(isLoading: false, items: tvSeriesData));
      },
    );
  }
}
