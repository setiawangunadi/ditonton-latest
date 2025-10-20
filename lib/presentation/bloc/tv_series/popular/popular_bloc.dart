import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_popular_tv_series.dart';
import 'package:equatable/equatable.dart';

part 'popular_event.dart';

part 'popular_state.dart';

class PopularBloc extends Bloc<PopularEvent, PopularState> {
  final GetPopularTvSeries getPopularTvSeries;

  PopularBloc(this.getPopularTvSeries) : super(const PopularState()) {
    on<FetchPopular>(_onFetchPopular);
  }

  Future<void> _onFetchPopular(
    PopularEvent event,
    Emitter<PopularState> emit,
  ) async {
    emit(const PopularLoading());
    
    try {
      final result = await getPopularTvSeries.execute();
      
      result.fold(
        (failure) {
          emit(PopularError(failure.message));
        },
        (tvSeries) {
          emit(PopularLoaded(tvSeries));
        },
      );
    } catch (e) {
      emit(PopularError('Exception: $e'));
    }
  }
}
