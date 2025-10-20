import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_now_playing_tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_popular_tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_top_rated_tv_series.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'list_event.dart';
part 'list_state.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  final GetNowPlayingTvSeries getNowPlayingTvSeries;
  final GetPopularTvSeries getPopularTvSeries;
  final GetTopRatedTvSeries getTopRatedTvSeries;

  ListBloc({
    required this.getNowPlayingTvSeries,
    required this.getPopularTvSeries,
    required this.getTopRatedTvSeries,
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

    final result = await getNowPlayingTvSeries.execute();
    result.fold(
      (failure) {
        emit(state.copyWith(
          isLoadingNowPlaying: false,
          messageNowPlaying: failure.message,
        ));
      },
      (tvSeriesData) {
        emit(state.copyWith(
          isLoadingNowPlaying: false,
          nowPlaying: tvSeriesData,
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

    final result = await getPopularTvSeries.execute();
    result.fold(
      (failure) {
        emit(state.copyWith(
          isLoadingPopular: false,
          messagePopular: failure.message,
        ));
      },
      (tvSeriesData) {
        emit(state.copyWith(
          isLoadingPopular: false,
          popular: tvSeriesData,
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

    final result = await getTopRatedTvSeries.execute();
    result.fold(
      (failure) {
        emit(state.copyWith(
          isLoadingTopRated: false,
          messageTopRated: failure.message,
        ));
      },
      (tvSeriesData) {
        emit(state.copyWith(
          isLoadingTopRated: false,
          topRated: tvSeriesData,
        ));
      },
    );
  }
}
