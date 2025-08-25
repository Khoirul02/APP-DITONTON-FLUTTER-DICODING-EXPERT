import 'package:ditonton/presentation/bloc/now_playing_tv_show_cubit.dart';
import 'package:ditonton/presentation/bloc/now_playing_tv_show_state.dart';
import 'package:ditonton/presentation/widgets/tv_show_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NowPalyingTvShowPage extends StatefulWidget {
  static const ROUTE_NAME = '/now-palying-tv-show';

  @override
  _NowPalyingTvShowPageState createState() => _NowPalyingTvShowPageState();
}

class _NowPalyingTvShowPageState extends State<NowPalyingTvShowPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<NowPlayingTvShowCubit>().fetchNowPlayingTvShow(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Now Playing TV Show'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<NowPlayingTvShowCubit, NowPlayingTvShowState>(
          builder: (context, state) {
            if (state is NowPlayingTvShowLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is NowPlayingTvShowHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = state.result[index];
                  return TvShowCard(tv);
                },
                itemCount: state.result.length,
              );
            } else if (state is NowPlayingTvShowError) {
              return Center(
                key: Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return const Center(child: Text('No TV Show Found'));
            }
          },
        ),
      ),
    );
  }
}
