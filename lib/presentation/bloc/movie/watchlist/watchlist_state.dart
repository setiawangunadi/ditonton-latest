part of 'watchlist_bloc.dart';

class WatchlistState extends Equatable {
  final List<Movie> items;
  final String message;
  final bool isLoading;

  const WatchlistState({
    this.items = const <Movie>[],
    this.message = '',
    this.isLoading = false,
  });

  WatchlistState copyWith({
    List<Movie>? items,
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


