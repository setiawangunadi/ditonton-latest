part of 'search_bloc.dart';

@immutable
class SearchState extends Equatable {
  final List<TvSeries> results;
  final String message;
  final bool isLoading;

  const SearchState({
    this.results = const <TvSeries>[],
    this.message = '',
    this.isLoading = false,
  });

  SearchState copyWith({
    List<TvSeries>? results,
    String? message,
    bool? isLoading,
  }) {
    return SearchState(
      results: results ?? this.results,
      message: message ?? this.message,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [results, message, isLoading];
}
