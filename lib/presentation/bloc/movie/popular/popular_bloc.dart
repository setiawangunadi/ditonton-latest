import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:equatable/equatable.dart';

part 'popular_event.dart';

part 'popular_state.dart';

class PopularBloc extends Bloc<PopularEvent, PopularState> {
  final GetPopularMovies getPopularMovies;

  PopularBloc(this.getPopularMovies) : super(const PopularState()) {
    on<FetchPopular>(_onFetchPopular);
  }

  Future<void> _onFetchPopular(
    PopularEvent event,
    Emitter<PopularState> emit,
  ) async {
    emit(const PopularLoading());

    try {
      final result = await getPopularMovies.execute();

      result.fold(
        (failure) {
          emit(PopularError(failure.message));
        },
        (movies) {
          emit(PopularLoaded(movies));
        },
      );
    } catch (e) {
      emit(PopularError('Exception: $e'));
    }
  }
}


