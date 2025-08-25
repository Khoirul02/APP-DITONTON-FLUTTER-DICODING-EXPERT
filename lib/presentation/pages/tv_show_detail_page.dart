import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/tv_show.dart';
import 'package:ditonton/domain/entities/tv_show_detail.dart';
import 'package:ditonton/presentation/bloc/tv_show_detail_cubit.dart';
import 'package:ditonton/presentation/bloc/tv_show_detail_state.dart';
import 'package:ditonton/presentation/widgets/episode_widget.dart';
import 'package:ditonton/presentation/widgets/season_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class TvShowDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail-tv-show';

  final int id;
  TvShowDetailPage({required this.id});

  @override
  _TvShowDetailPageState createState() => _TvShowDetailPageState();
}

class _TvShowDetailPageState extends State<TvShowDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TvShowDetailCubit>().fetchTvShowDetail(widget.id);
      context.read<TvShowDetailCubit>().loadWatchlistStatus(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TvShowDetailCubit, TvShowDetailState>(
        builder: (context, state) {
          if (state is TvShowDetailLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TvShowDetailHasData) {
            final tv = state.tvShow;
            return SafeArea(
              child: DetailContent(
                tv,
                state.recommendations,
                state.isAddedToWatchlist,
              ),
            );
          } else if (state is TvShowDetailError) {
            return Text(state.message);
          } else {
            return Text('Not Found!');
          }
        },
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final TvShowDetail tv;
  final List<TvShow> recommendations;
  final bool isAddedWatchlist;

  DetailContent(this.tv, this.recommendations, this.isAddedWatchlist);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${tv.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        BlocListener<TvShowDetailCubit, TvShowDetailState>(
            listenWhen: (prev, curr) =>
                curr is TvShowDetailHasData && curr.watchlistMessage.isNotEmpty,
            listener: (context, state) {
              if (state is TvShowDetailHasData) {
                final message = state.watchlistMessage;
                if (message == 'Added to Watchlist' ||
                    message == 'Removed from Watchlist') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(message)),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(content: Text(message)),
                  );
                }
              }
            },
            child: Container(
              margin: const EdgeInsets.only(top: 48 + 8),
              child: DraggableScrollableSheet(
                builder: (context, scrollController) {
                  return Container(
                    decoration: BoxDecoration(
                      color: kRichBlack,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    padding: const EdgeInsets.only(
                      left: 16,
                      top: 16,
                      right: 16,
                    ),
                    child: Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 16),
                          child: SingleChildScrollView(
                            controller: scrollController,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tv.name,
                                  style: kHeading5,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: () async {
                                    if (!isAddedWatchlist) {
                                      await context
                                          .read<TvShowDetailCubit>()
                                          .addWatchlist(tv);
                                    } else {
                                      await context
                                          .read<TvShowDetailCubit>()
                                          .removeFromWatchlist(tv);
                                    }
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      isAddedWatchlist
                                          ? Icon(Icons.check)
                                          : Icon(Icons.add),
                                      Text('Watchlist'),
                                    ],
                                  ),
                                ),
                                Text(
                                  _showGenres(tv.genres),
                                ),
                                Row(
                                  children: [
                                    RatingBarIndicator(
                                      rating: tv.voteAverage / 2,
                                      itemCount: 5,
                                      itemBuilder: (context, index) => Icon(
                                        Icons.star,
                                        color: kMikadoYellow,
                                      ),
                                      itemSize: 24,
                                    ),
                                    Text('${tv.voteAverage}')
                                  ],
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Overview',
                                  style: kHeading6,
                                ),
                                Text(
                                  tv.overview,
                                ),
                                SizedBox(height: 16),
                                EpisodeWidget(
                                    title: 'Last Episode',
                                    episode: tv.lastEpisodeToAir),
                                SizedBox(height: 16),
                                SeasonListWidget(seasons: tv.seasons),
                                EpisodeWidget(
                                    title: 'Next Episode',
                                    episode: tv.nextEpisodeToAir),
                                SizedBox(height: 16),
                                Text(
                                  'Recommendations',
                                  style: kHeading6,
                                ),
                                BlocBuilder<TvShowDetailCubit,
                                    TvShowDetailState>(
                                  builder: (context, state) {
                                    if (state == TvShowDetailLoading) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else if (state is TvShowDetailError) {
                                      return Text(state.message);
                                    } else if (state is TvShowDetailHasData) {
                                      return Container(
                                        height: 150,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            final tv = recommendations[index];
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator
                                                      .pushReplacementNamed(
                                                    context,
                                                    TvShowDetailPage.ROUTE_NAME,
                                                    arguments: tv.id,
                                                  );
                                                },
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(8),
                                                  ),
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        'https://image.tmdb.org/t/p/w500${tv.posterPath}',
                                                    placeholder:
                                                        (context, url) =>
                                                            Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(Icons.error),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                          itemCount: recommendations.length,
                                        ),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            color: Colors.white,
                            height: 4,
                            width: 48,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                minChildSize: 0.25,
              ),
            )),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += genre.name + ', ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }
}
