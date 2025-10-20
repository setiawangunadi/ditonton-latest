part of 'watchlist_bloc.dart';

@immutable
class WatchlistState extends Equatable {
  final List<TvSeries> items;
  final String message;
  final bool isLoading;

  const WatchlistState({
    this.items = const <TvSeries>[],
    this.message = '',
    this.isLoading = false,
  });

  WatchlistState copyWith({
    List<TvSeries>? items,
    String? message,
    bool? isLoading,
  }) {
    return WatchlistState(
      items: items ?? this.items,
      message: message ?? this.message,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [items, message, isLoading];
}
