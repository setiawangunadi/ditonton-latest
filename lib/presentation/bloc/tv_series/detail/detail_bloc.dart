import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:ditonton/domain/usecases/tv_series/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/tv_series/get_tv_series_recommendations.dart';
import 'package:ditonton/domain/usecases/tv_series/get_watchlist_tv_series_status.dart';
import 'package:ditonton/domain/usecases/tv_series/remove_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/save_watchlist_tv_series.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'detail_event.dart';
part 'detail_state.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  final GetTvSeriesDetail getTvSeriesDetail;
  final GetTvSeriesRecommendations getTvSeriesRecommendations;
  final GetWatchListTvSeriesStatus getWatchListStatus;
  final SaveWatchlistTvSeries saveWatchlist;
  final RemoveWatchlistTvSeries removeWatchlist;

  DetailBloc({
    required this.getTvSeriesDetail,
    required this.getTvSeriesRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(const DetailState()) {
    on<FetchDetail>(_onFetchDetail);
    on<LoadWatchlistStatus>(_onLoadWatchlistStatus);
    on<AddToWatchlist>(_onAddToWatchlist);
    on<RemoveFromWatchlist>(_onRemoveFromWatchlist);
  }

  Future<void> _onFetchDetail(
    FetchDetail event,
    Emitter<DetailState> emit,
  ) async {
    emit(state.copyWith(isLoadingDetail: true, message: ''));

    final detailResult = await getTvSeriesDetail.execute(event.id);
    final recommendationResult =
        await getTvSeriesRecommendations.execute(event.id);

    detailResult.fold(
      (failure) {
        emit(state.copyWith(
          isLoadingDetail: false,
          message: failure.message,
        ));
      },
      (detail) async {
        emit(state.copyWith(
          tvSeries: detail,
          isLoadingDetail: false,
          isLoadingRecommendations: true,
        ));

        recommendationResult.fold(
          (failure) {
            emit(state.copyWith(
              isLoadingRecommendations: false,
              message: failure.message,
            ));
          },
          (tvSeries) {
            emit(state.copyWith(
              isLoadingRecommendations: false,
              recommendations: tvSeries,
            ));
          },
        );
      },
    );
  }

  Future<void> _onLoadWatchlistStatus(
    LoadWatchlistStatus event,
    Emitter<DetailState> emit,
  ) async {
    final result = await getWatchListStatus.execute(event.id);
    emit(state.copyWith(isAddedToWatchlist: result));
  }

  Future<void> _onAddToWatchlist(
    AddToWatchlist event,
    Emitter<DetailState> emit,
  ) async {
    final result = await saveWatchlist.execute(event.tvSeriesDetail);
    await result.fold(
      (failure) async {
        emit(state.copyWith(message: failure.message));
      },
      (successMessage) async {
        emit(state.copyWith(message: successMessage));
      },
    );
    add(LoadWatchlistStatus(event.tvSeriesDetail.id));
  }

  Future<void> _onRemoveFromWatchlist(
    RemoveFromWatchlist event,
    Emitter<DetailState> emit,
  ) async {
    final result = await removeWatchlist.execute(event.tvSeriesDetail);
    await result.fold(
      (failure) async {
        emit(state.copyWith(message: failure.message));
      },
      (successMessage) async {
        emit(state.copyWith(message: successMessage));
      },
    );
    add(LoadWatchlistStatus(event.tvSeriesDetail.id));
  }
}
