import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/presentation/bloc/tv_show_list_cubit.dart';
import 'package:ditonton/presentation/bloc/tv_show_list_state.dart';
import 'package:ditonton/presentation/pages/now_palying_tv_show_page.dart';
import 'package:ditonton/presentation/pages/popular_tv_show_page.dart';
import 'package:ditonton/presentation/pages/top_rated_tv_show_page.dart';
import 'package:ditonton/presentation/pages/tv_show_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeTvShowPage extends StatefulWidget {
  @override
  _HomeTvShowPageState createState() => _HomeTvShowPageState();
}

class _HomeTvShowPageState extends State<HomeTvShowPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TvShowListCubit>().fetchTvShows();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _buildSubHeading(
            title: 'Popular',
            onTap: () => {
              Navigator.pushNamed(context, PopularTvShowPage.ROUTE_NAME),
            },
          ),
          BlocBuilder<TvShowListCubit, TvShowListState>(
              builder: (context, state) {
            if (state is TvShowListLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TvShowListHasData) {
              return TvShowList(state.popular);
            } else {
              return Text('Failed');
            }
          }),
          _buildSubHeading(
            title: 'Top Rated',
            onTap: () => {
              Navigator.pushNamed(context, TopRatedTvShowPage.ROUTE_NAME),
            },
          ),
          BlocBuilder<TvShowListCubit, TvShowListState>(
              builder: (context, state) {
            if (state is TvShowListLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TvShowListHasData) {
              return TvShowList(state.topRated);
            } else {
              return Text('Failed');
            }
          }),
          _buildSubHeading(
            title: 'Now Playing',
            onTap: () => {
              Navigator.pushNamed(context, NowPalyingTvShowPage.ROUTE_NAME),
            },
          ),
          BlocBuilder<TvShowListCubit, TvShowListState>(
              builder: (context, state) {
            if (state is TvShowListLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TvShowListHasData) {
              return TvShowList(state.nowPlaying);
            } else {
              return Text('Failed');
            }
          }),
        ])));
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class TvShowList extends StatelessWidget {
  final List<TvShow> tvShow;

  TvShowList(this.tvShow);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final item = tvShow[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TvShowDetailPage.ROUTE_NAME,
                  arguments: item.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${item.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tvShow.length,
      ),
    );
  }
}
