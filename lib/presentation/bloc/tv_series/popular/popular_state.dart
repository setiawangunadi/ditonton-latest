part of 'popular_bloc.dart';

class PopularState extends Equatable {
  final List<TvSeries> tvSeries;
  final String message;

  const PopularState({
    this.tvSeries = const [],
    this.message = '',
  });

  @override
  List<Object> get props => [tvSeries, message];
}

class PopularLoading extends PopularState {
  const PopularLoading() : super();
}

class PopularLoaded extends PopularState {
  const PopularLoaded(List<TvSeries> tvSeries) : super(tvSeries: tvSeries);
}

class PopularError extends PopularState {
  const PopularError(String message) : super(message: message);
}
