import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/popular/popular_bloc.dart' as popular_bloc;
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PopularMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-movie';

  @override
  _PopularMoviesPageState createState() => _PopularMoviesPageState();
}

class _PopularMoviesPageState extends State<PopularMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<popular_bloc.PopularBloc>().add(popular_bloc.FetchPopular()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<popular_bloc.PopularBloc, popular_bloc.PopularState>(
          builder: (context, state) {
            if (state is popular_bloc.PopularLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is popular_bloc.PopularLoaded) {
              final movies = state.movies;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return MovieCard(movie);
                },
                itemCount: movies.length,
              );
            } else if (state is popular_bloc.PopularError) {
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
