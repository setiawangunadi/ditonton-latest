import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/top_rated/top_rated_bloc.dart' as top_bloc;
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopRatedMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/top-rated-movie';

  @override
  _TopRatedMoviesPageState createState() => _TopRatedMoviesPageState();
}

class _TopRatedMoviesPageState extends State<TopRatedMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<top_bloc.TopRatedBloc>().add(top_bloc.FetchTopRated()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<top_bloc.TopRatedBloc, top_bloc.TopRatedState>(
          builder: (context, state) {
            if (state is top_bloc.TopRatedLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is top_bloc.TopRatedLoaded) {
              final movies = state.movies;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return MovieCard(movie);
                },
                itemCount: movies.length,
              );
            } else if (state is top_bloc.TopRatedError) {
              return Center(key: Key('error_message'), child: Text(state.message));
            } else {
              return SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
