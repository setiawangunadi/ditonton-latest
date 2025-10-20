part of 'detail_bloc.dart';

@immutable
abstract class DetailEvent extends Equatable {
  const DetailEvent();

  @override
  List<Object?> get props => [];
}

class FetchDetail extends DetailEvent {
  final int id;

  const FetchDetail(this.id);

  @override
  List<Object?> get props => [id];
}

class LoadWatchlistStatus extends DetailEvent {
  final int id;

  const LoadWatchlistStatus(this.id);

  @override
  List<Object?> get props => [id];
}

class AddToWatchlist extends DetailEvent {
  final TvSeriesDetail tvSeriesDetail;

  const AddToWatchlist(this.tvSeriesDetail);

  @override
  List<Object?> get props => [tvSeriesDetail];
}

class RemoveFromWatchlist extends DetailEvent {
  final TvSeriesDetail tvSeriesDetail;

  const RemoveFromWatchlist(this.tvSeriesDetail);

  @override
  List<Object?> get props => [tvSeriesDetail];
}
