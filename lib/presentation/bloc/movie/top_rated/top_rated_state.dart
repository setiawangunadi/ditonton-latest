part of 'top_rated_bloc.dart';

class TopRatedState extends Equatable {
  final List<Movie> movies;
  final String message;

  const TopRatedState({
    this.movies = const [],
    this.message = '',
  });

  @override
  List<Object> get props => [movies, message];
}

class TopRatedLoading extends TopRatedState {
  const TopRatedLoading() : super();
}

class TopRatedLoaded extends TopRatedState {
  TopRatedLoaded(List<Movie> movies) : super(movies: movies);
}

class TopRatedError extends TopRatedState {
  TopRatedError(String message) : super(message: message);
}


