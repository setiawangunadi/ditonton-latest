part of 'detail_bloc.dart';

class DetailState extends Equatable {
  final MovieDetail? movie;
  final List<Movie> recommendations;
  final bool isAddedToWatchlist;
  final String message;
  final bool isLoadingDetail;
  final bool isLoadingRecommendations;

  const DetailState({
    this.movie,
    this.recommendations = const <Movie>[],
    this.isAddedToWatchlist = false,
    this.message = '',
    this.isLoadingDetail = false,
    this.isLoadingRecommendations = false,
  });

  DetailState copyWith({
    MovieDetail? movie,
    List<Movie>? recommendations,
    bool? isAddedToWatchlist,
    String? message,
    bool? isLoadingDetail,
    bool? isLoadingRecommendations,
  }) {
    return DetailState(
      movie: movie ?? this.movie,
      recommendations: recommendations ?? this.recommendations,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      message: message ?? this.message,
      isLoadingDetail: isLoadingDetail ?? this.isLoadingDetail,
      isLoadingRecommendations:
          isLoadingRecommendations ?? this.isLoadingRecommendations,
    );
  }

  @override
  List<Object?> get props => [
        movie,
        recommendations,
        isAddedToWatchlist,
        message,
        isLoadingDetail,
        isLoadingRecommendations,
      ];
}


