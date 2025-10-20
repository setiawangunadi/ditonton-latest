part of 'top_rated_bloc.dart';

class TopRatedState extends Equatable {
  final List<TvSeries> tvSeries;
  final String message;

  const TopRatedState({
    this.tvSeries = const <TvSeries>[],
    this.message = '',
  });

  @override
  List<Object> get props => [tvSeries, message];
}

class TopRatedLoading extends TopRatedState {
  const TopRatedLoading() : super();
}

class TopRatedLoaded extends TopRatedState {
  const TopRatedLoaded(List<TvSeries> tvSeries) : super(tvSeries: tvSeries);
}

class TopRatedError extends TopRatedState {
  const TopRatedError(String message) : super(message: message);
}
