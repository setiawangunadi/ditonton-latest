import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'detail_event.dart';
part 'detail_state.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  DetailBloc({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
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

    final detailResult = await getMovieDetail.execute(event.id);
    final recommendationResult =
        await getMovieRecommendations.execute(event.id);

    detailResult.fold(
      (failure) {
        emit(state.copyWith(
          isLoadingDetail: false,
          message: failure.message,
        ));
      },
      (detail) async {
        emit(state.copyWith(
          movie: detail,
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
          (movies) {
            emit(state.copyWith(
              isLoadingRecommendations: false,
              recommendations: movies,
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
    final result = await saveWatchlist.execute(event.movieDetail);
    await result.fold(
      (failure) async {
        emit(state.copyWith(message: failure.message));
      },
      (successMessage) async {
        emit(state.copyWith(message: successMessage));
      },
    );
    add(LoadWatchlistStatus(event.movieDetail.id));
  }

  Future<void> _onRemoveFromWatchlist(
    RemoveFromWatchlist event,
    Emitter<DetailState> emit,
  ) async {
    final result = await removeWatchlist.execute(event.movieDetail);
    await result.fold(
      (failure) async {
        emit(state.copyWith(message: failure.message));
      },
      (successMessage) async {
        emit(state.copyWith(message: successMessage));
      },
    );
    add(LoadWatchlistStatus(event.movieDetail.id));
  }
}


