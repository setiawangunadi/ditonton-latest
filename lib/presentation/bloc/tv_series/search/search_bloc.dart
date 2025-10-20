import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/search_tv_series.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchTvSeries searchTvSeries;

  SearchBloc(this.searchTvSeries) : super(const SearchState()) {
    on<QuerySubmitted>(_onQuerySubmitted);
  }

  Future<void> _onQuerySubmitted(
    QuerySubmitted event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.trim().isEmpty) {
      emit(const SearchState(results: <TvSeries>[], message: '', isLoading: false));
      return;
    }

    emit(state.copyWith(isLoading: true, message: ''));

    final result = await searchTvSeries.execute(event.query);
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
