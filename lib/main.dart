import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/bloc/tv_series/list/list_bloc.dart' as tv_bloc;
// tv_bloc aliases kept minimal to only what's used below
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/movie/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/movie/home_movie_page.dart';
import 'package:ditonton/presentation/pages/movie/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/movie/top_rated_movies_page.dart';
import 'package:ditonton/presentation/pages/tv_series/home_tv_series_page.dart';
import 'package:ditonton/presentation/pages/movie/watchlist_movies_page.dart';
import 'package:ditonton/presentation/pages/tv_series/popular_tv_series_page.dart';
import 'package:ditonton/presentation/pages/tv_series/tv_series_detail_page.dart';
import 'package:ditonton/presentation/bloc/tv_series/detail/detail_bloc.dart' as tv_detail_bloc;
import 'package:ditonton/presentation/bloc/tv_series/watchlist/watchlist_bloc.dart' as tv_watchlist_bloc;
import 'package:ditonton/presentation/bloc/tv_series/popular/popular_bloc.dart' as tv_popular_bloc;
import 'package:ditonton/presentation/bloc/tv_series/top_rated/top_rated_bloc.dart' as tv_top_rated_bloc;
import 'package:ditonton/presentation/bloc/tv_series/search/search_bloc.dart' as tv_search_bloc;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ditonton/injection.dart' as di;

import 'presentation/pages/tv_series/search_tv_series_page.dart';
// removed unused tv series bloc imports
// Movie BLoCs
// movie list bloc not needed in main providers
import 'package:ditonton/presentation/bloc/movie/list/list_bloc.dart' as movie_bloc;
import 'package:ditonton/presentation/bloc/movie/detail/detail_bloc.dart' as movie_bloc;
import 'package:ditonton/presentation/bloc/movie/search/search_bloc.dart' as movie_bloc;
import 'package:ditonton/presentation/bloc/movie/popular/popular_bloc.dart' as movie_bloc;
import 'package:ditonton/presentation/bloc/movie/top_rated/top_rated_bloc.dart' as movie_bloc;
import 'package:ditonton/presentation/bloc/movie/watchlist/watchlist_bloc.dart' as movie_bloc;
import 'presentation/pages/tv_series/top_rated_tv_series_page.dart';
import 'presentation/pages/tv_series/watchlist_tv_series_page.dart';

void main() {
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<tv_bloc.ListBloc>(
          create: (_) => di.locator<tv_bloc.ListBloc>(),
        ),
        BlocProvider<tv_detail_bloc.DetailBloc>(
          create: (_) => di.locator<tv_detail_bloc.DetailBloc>(),
        ),
        BlocProvider<tv_watchlist_bloc.WatchlistBloc>(
          create: (_) => di.locator<tv_watchlist_bloc.WatchlistBloc>(),
        ),
        BlocProvider<tv_popular_bloc.PopularBloc>(
          create: (_) => di.locator<tv_popular_bloc.PopularBloc>(),
        ),
        BlocProvider<tv_top_rated_bloc.TopRatedBloc>(
          create: (_) => di.locator<tv_top_rated_bloc.TopRatedBloc>(),
        ),
        BlocProvider<tv_search_bloc.SearchBloc>(
          create: (_) => di.locator<tv_search_bloc.SearchBloc>(),
        ),
        BlocProvider<movie_bloc.ListBloc>(
          create: (_) => di.locator<movie_bloc.ListBloc>(),
        ),
        BlocProvider<movie_bloc.DetailBloc>(
          create: (_) => di.locator<movie_bloc.DetailBloc>(),
        ),
        BlocProvider<movie_bloc.SearchBloc>(
          create: (_) => di.locator<movie_bloc.SearchBloc>(),
        ),
        BlocProvider<movie_bloc.TopRatedBloc>(
          create: (_) => di.locator<movie_bloc.TopRatedBloc>(),
        ),
        BlocProvider<movie_bloc.PopularBloc>(
          create: (_) => di.locator<movie_bloc.PopularBloc>(),
        ),
        BlocProvider<movie_bloc.WatchlistBloc>(
          create: (_) => di.locator<movie_bloc.WatchlistBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
          drawerTheme: kDrawerTheme,
        ),
        home: HomeMoviePage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case HomeMoviePage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => HomeMoviePage());
            case HomeTvSeriesPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => HomeTvSeriesPage());
            case PopularMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
            case PopularTvSeriesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularTvSeriesPage());
            case TopRatedMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
            case TopRatedTvSeriesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedTvSeriesPage());
            case MovieDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case TvSeriesDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TvSeriesDetailPage(id: id),
                settings: settings,
              );
            case SearchPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => SearchPage());
            case SearchTvSeriesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => SearchTvSeriesPage());
            case WatchlistMoviesPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistMoviesPage());
            case WatchlistTvSeriesPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistTvSeriesPage());
            case AboutPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => AboutPage());
            default:
              return MaterialPageRoute(builder: (_) {
                return Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}
