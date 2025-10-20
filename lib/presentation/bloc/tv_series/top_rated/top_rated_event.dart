part of 'top_rated_bloc.dart';

abstract class TopRatedEvent {
  const TopRatedEvent();

  List<Object> get props => [];
}

class FetchTopRated extends TopRatedEvent {}
