import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_top_rated_tv_series.dart';
import 'package:equatable/equatable.dart';

part 'top_rated_event.dart';

part 'top_rated_state.dart';

class TopRatedBloc extends Bloc<TopRatedEvent, TopRatedState> {
  final GetTopRatedTvSeries getTopRatedTvSeries;

  TopRatedBloc(this.getTopRatedTvSeries) : super(TopRatedState()) {
    on<FetchTopRated>(_onFetchTopRated);
  }

  Future<void> _onFetchTopRated(
    FetchTopRated event,
    Emitter<TopRatedState> emit,
  ) async {
    emit(const TopRatedLoading());

    try {
      final result = await getTopRatedTvSeries.execute();

      result.fold(
        (failure) {
          emit(TopRatedError(failure.message));
        },
        (tvSeries) {
          emit(TopRatedLoaded(tvSeries));
        },
      );
    } catch (e) {
      emit(TopRatedError('Exception: $e'));
    }
  }
}
