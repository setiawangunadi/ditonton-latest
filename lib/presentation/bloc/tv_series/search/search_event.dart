part of 'search_bloc.dart';

@immutable
abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class QuerySubmitted extends SearchEvent {
  final String query;

  const QuerySubmitted(this.query);

  @override
  List<Object?> get props => [query];
}
