part of 'popular_bloc.dart';

class PopularState extends Equatable {
  final List<Movie> movies;
  final String message;

  const PopularState({
    this.movies = const [],
    this.message = '',
  });

  @override
  List<Object> get props => [movies, message];
}

class PopularLoading extends PopularState {
  const PopularLoading() : super();
}

class PopularLoaded extends PopularState {
  const PopularLoaded(List<Movie> movies) : super(movies: movies);
}

class PopularError extends PopularState {
  const PopularError(String message) : super(message: message);
}


