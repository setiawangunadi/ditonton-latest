part of 'search_bloc.dart';

class SearchState extends Equatable {
  final List<Movie> results;
  final String message;
  final bool isLoading;

  const SearchState({
    this.results = const <Movie>[],
    this.message = '',
    this.isLoading = false,
  });

  SearchState copyWith({
    List<Movie>? results,
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


