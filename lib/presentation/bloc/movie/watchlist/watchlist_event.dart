part of 'watchlist_bloc.dart';

@immutable
abstract class WatchlistEvent extends Equatable {
  const WatchlistEvent();

  @override
  List<Object?> get props => [];
}

class WatchlistRequested extends WatchlistEvent {}


