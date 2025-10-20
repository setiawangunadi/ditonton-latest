import 'package:ditonton/common/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/search/search_bloc.dart' as search_bloc;
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  static const ROUTE_NAME = '/search';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onSubmitted: (query) {
                context.read<search_bloc.SearchBloc>().add(search_bloc.QuerySubmitted(query));
              },
              decoration: InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            SizedBox(height: 16),
            Text(
              'Search Result',
              style: kHeading6,
            ),
            Expanded(
              child: BlocBuilder<search_bloc.SearchBloc, search_bloc.SearchState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (state.message.isNotEmpty) {
                    return Center(child: Text(state.message));
                  }
                  final results = state.results;
                  if (results.isEmpty) {
                    return SizedBox.shrink();
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      final movie = results[index];
                      return MovieCard(movie);
                    },
                    itemCount: results.length,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
