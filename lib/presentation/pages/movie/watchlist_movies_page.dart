import 'package:ditonton/common/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/watchlist/watchlist_bloc.dart' as watchlist_bloc;
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
 

class WatchlistMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-movie';

  @override
  _WatchlistMoviesPageState createState() => _WatchlistMoviesPageState();
}

class _WatchlistMoviesPageState extends State<WatchlistMoviesPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<watchlist_bloc.WatchlistBloc>().add(watchlist_bloc.WatchlistRequested()));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void didPopNext() {
    context.read<watchlist_bloc.WatchlistBloc>().add(watchlist_bloc.WatchlistRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<watchlist_bloc.WatchlistBloc, watchlist_bloc.WatchlistState>(
          builder: (context, state) {
            if (state.isLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state.items.isNotEmpty) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = state.items[index];
                  return MovieCard(movie);
                },
                itemCount: state.items.length,
              );
            } else if (state.message.isNotEmpty) {
              return Center(key: Key('error_message'), child: Text(state.message));
            } else {
              return Center(child: Text('No items'));
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
