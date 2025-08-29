import 'package:ditonton/presentation/bloc/watchlist_tv_show_cubit.dart';
import 'package:ditonton/presentation/bloc/watchlist_tv_show_state.dart';
import 'package:ditonton/presentation/widgets/tv_show_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistTvShowWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<WatchlistTvShowCubit, WatchlistTvShowState>(
        builder: (context, state) {
          if (state is WatchlistTvShowLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is WatchlistTvShowHasData) {
            return state.tvShows.isNotEmpty
                ? ListView.builder(
                    itemBuilder: (context, index) {
                      final tv = state.tvShows[index];
                      return TvShowCard(tv);
                    },
                    itemCount: state.tvShows.length,
                  )
                : Center(
                    child: Text('No Watchlist Item!'),
                  );
          } else if (state is WatchlistTvShowError) {
            return Center(
              key: ValueKey('error_message'),
              child: Text(state.message),
            );
          } else {
            return Center(
              child: Text('Data Not Found!'),
            );
          }
        },
      ),
    );
  }
}
