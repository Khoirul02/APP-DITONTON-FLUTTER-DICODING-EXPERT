import 'package:ditonton/common/constants.dart';
import 'package:ditonton/presentation/bloc/header_title_cubit.dart';
import 'package:ditonton/presentation/bloc/search_bloc.dart';
import 'package:ditonton/presentation/bloc/search_event.dart';
import 'package:ditonton/presentation/bloc/search_state.dart';
import 'package:ditonton/presentation/bloc/search_tv_bloc.dart';
import 'package:ditonton/presentation/bloc/search_tv_event.dart';
import 'package:ditonton/presentation/bloc/search_tv_state.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/presentation/widgets/tv_show_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatelessWidget {
  static const ROUTE_NAME = '/search';

  @override
  Widget build(BuildContext context) {
    String headerTitle = context.watch<HeaderTitleCubit>().state;
    return Scaffold(
      appBar: AppBar(
        title: Text('Search of $headerTitle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (query) {
                if (headerTitle == 'Movies') {
                  context.read<SearchBloc>().add(OnQueryChanged(query));
                } else {
                  context.read<SearchTvBloc>().add(OnQueryChangedTv(query));
                }
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
            if (headerTitle == 'Movies')
              BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (state is SearchLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is SearchHasData) {
                    final result = state.result;
                    return Expanded(
                      child: result.isNotEmpty
                          ? ListView.builder(
                              padding: const EdgeInsets.all(8),
                              itemBuilder: (context, index) {
                                final movie = result[index];
                                return MovieCard(movie);
                              },
                              itemCount: result.length,
                            )
                          : Center(
                              child: Text('Data Not Found!'),
                            ),
                    );
                  } else if (state is SearchError) {
                    return Expanded(
                      child: Center(child: Text(state.message)),
                    );
                  } else {
                    return Expanded(child: Container());
                  }
                },
              ),
            if (headerTitle != 'Movies')
              BlocBuilder<SearchTvBloc, SearchTvState>(
                builder: (context, state) {
                  if (state is SearchLoadingTv) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is SearchHasDataTv) {
                    final result = state.result;
                    return Expanded(
                      child: result.isNotEmpty
                          ? ListView.builder(
                              padding: const EdgeInsets.all(8),
                              itemBuilder: (context, index) {
                                final tv = result[index];
                                return TvShowCard(tv);
                              },
                              itemCount: result.length,
                            )
                          : Center(
                              child: Text('Data Not Found!'),
                            ),
                    );
                  } else if (state is SearchErrorTv) {
                    return Expanded(
                      child: Center(child: Text(state.message)),
                    );
                  } else {
                    return Expanded(child: Container());
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}
