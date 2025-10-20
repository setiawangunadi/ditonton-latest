import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:equatable/equatable.dart';

part 'top_rated_event.dart';

part 'top_rated_state.dart';

class TopRatedBloc extends Bloc<TopRatedEvent, TopRatedState> {
  final GetTopRatedMovies getTopRatedMovies;

  TopRatedBloc(this.getTopRatedMovies) : super(TopRatedState()) {
    on<FetchTopRated>(_onFetchTopRated);
  }

  Future<void> _onFetchTopRated(
    FetchTopRated event,
    Emitter<TopRatedState> emit,
  ) async {
    emit(const TopRatedLoading());

    try {
      final result = await getTopRatedMovies.execute();

      result.fold(
        (failure) {
          emit(TopRatedError(failure.message));
        },
        (movies) {
          emit(TopRatedLoaded(movies));
        },
      );
    } catch (e) {
      emit(TopRatedError('Exception: $e'));
    }
  }
}


