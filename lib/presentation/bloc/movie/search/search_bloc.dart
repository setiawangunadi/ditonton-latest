import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchMovies searchMovies;

  SearchBloc(this.searchMovies) : super(const SearchState()) {
    on<QuerySubmitted>(_onQuerySubmitted);
  }

  Future<void> _onQuerySubmitted(
    QuerySubmitted event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.trim().isEmpty) {
      emit(const SearchState(results: <Movie>[], message: '', isLoading: false));
      return;
    }

    emit(state.copyWith(isLoading: true, message: ''));

    final result = await searchMovies.execute(event.query);
    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, message: failure.message));
      },
      (data) {
        emit(state.copyWith(isLoading: false, results: data));
      },
    );
  }
}


