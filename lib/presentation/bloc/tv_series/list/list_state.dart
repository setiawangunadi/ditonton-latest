part of 'list_bloc.dart';

@immutable
class ListState extends Equatable {
  final List<TvSeries> nowPlaying;
  final List<TvSeries> popular;
  final List<TvSeries> topRated;

  final bool isLoadingNowPlaying;
  final bool isLoadingPopular;
  final bool isLoadingTopRated;

  final String messageNowPlaying;
  final String messagePopular;
  final String messageTopRated;

  const ListState({
    this.nowPlaying = const <TvSeries>[],
    this.popular = const <TvSeries>[],
    this.topRated = const <TvSeries>[],
    this.isLoadingNowPlaying = false,
    this.isLoadingPopular = false,
    this.isLoadingTopRated = false,
    this.messageNowPlaying = '',
    this.messagePopular = '',
    this.messageTopRated = '',
  });

  ListState copyWith({
    List<TvSeries>? nowPlaying,
    List<TvSeries>? popular,
    List<TvSeries>? topRated,
    bool? isLoadingNowPlaying,
    bool? isLoadingPopular,
    bool? isLoadingTopRated,
    String? messageNowPlaying,
    String? messagePopular,
    String? messageTopRated,
  }) {
    return ListState(
      nowPlaying: nowPlaying ?? this.nowPlaying,
      popular: popular ?? this.popular,
      topRated: topRated ?? this.topRated,
      isLoadingNowPlaying: isLoadingNowPlaying ?? this.isLoadingNowPlaying,
      isLoadingPopular: isLoadingPopular ?? this.isLoadingPopular,
      isLoadingTopRated: isLoadingTopRated ?? this.isLoadingTopRated,
      messageNowPlaying: messageNowPlaying ?? this.messageNowPlaying,
      messagePopular: messagePopular ?? this.messagePopular,
      messageTopRated: messageTopRated ?? this.messageTopRated,
    );
  }

  @override
  List<Object?> get props => [
        nowPlaying,
        popular,
        topRated,
        isLoadingNowPlaying,
        isLoadingPopular,
        isLoadingTopRated,
        messageNowPlaying,
        messagePopular,
        messageTopRated,
      ];
}
