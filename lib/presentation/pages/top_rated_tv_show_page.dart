import 'package:ditonton/presentation/bloc/top_rated_tv_show_cubit.dart';
import 'package:ditonton/presentation/bloc/top_rated_tv_show_state.dart';
import 'package:ditonton/presentation/widgets/tv_show_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopRatedTvShowPage extends StatefulWidget {
  static const ROUTE_NAME = '/top-rated-tv-show';

  @override
  _TopRatedTvShowPageState createState() => _TopRatedTvShowPageState();
}

class _TopRatedTvShowPageState extends State<TopRatedTvShowPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<TopRatedTvShowCubit>().fetchTopRatedTvShow(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated TV Show'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedTvShowCubit, TopRatedTvShowState>(
          builder: (context, state) {
            if (state is TopRatedTvShowLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TopRatedTvShowHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = state.result[index];
                  return TvShowCard(tv);
                },
                itemCount: state.result.length,
              );
            } else if (state is TopRatedTvShowError) {
              return Center(
                key: Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return Center(
                child: Text('Top Rate TV Show Not Found!'),
              );
            }
          },
        ),
      ),
    );
  }
}
