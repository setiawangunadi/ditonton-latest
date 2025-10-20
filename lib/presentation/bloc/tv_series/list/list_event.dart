part of 'list_bloc.dart';

@immutable
sealed class ListEvent extends Equatable {}

class FetchNowPlaying extends ListEvent {
  @override
  List<Object?> get props => [];
}

class FetchPopular extends ListEvent {
  @override
  List<Object?> get props => [];
}

class FetchTopRated extends ListEvent {
  @override
  List<Object?> get props => [];
}
