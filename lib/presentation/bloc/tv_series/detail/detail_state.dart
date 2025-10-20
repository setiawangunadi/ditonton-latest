part of 'detail_bloc.dart';

class DetailState extends Equatable {
  final TvSeriesDetail? tvSeries;
  final List<TvSeries> recommendations;
  final bool isAddedToWatchlist;
  final String message;
  final bool isLoadingDetail;
  final bool isLoadingRecommendations;

  const DetailState({
    this.tvSeries,
    this.recommendations = const <TvSeries>[],
    this.isAddedToWatchlist = false,
    this.message = '',
    this.isLoadingDetail = false,
    this.isLoadingRecommendations = false,
  });

  DetailState copyWith({
    TvSeriesDetail? tvSeries,
    List<TvSeries>? recommendations,
    bool? isAddedToWatchlist,
    String? message,
    bool? isLoadingDetail,
    bool? isLoadingRecommendations,
  }) {
    return DetailState(
      tvSeries: tvSeries ?? this.tvSeries,
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
        tvSeries,
        recommendations,
        isAddedToWatchlist,
        message,
        isLoadingDetail,
        isLoadingRecommendations,
      ];
}
