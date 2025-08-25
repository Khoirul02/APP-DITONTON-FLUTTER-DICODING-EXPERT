import 'package:ditonton/common/helper.dart';
import 'package:flutter/material.dart';
import 'package:ditonton/domain/entities/season.dart';

class SeasonListWidget extends StatelessWidget {
  final List<Season> seasons;
  final String title;

  const SeasonListWidget({
    Key? key,
    required this.seasons,
    this.title = 'Season',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (seasons.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: seasons.length,
          itemBuilder: (context, index) {
            final season = seasons[index];
            final String releaseDate = season.airDate != null
                ? Helper().getDateTimeByFormat(
                    'dd MMMM yyyy', 'en', DateTime.parse(season.airDate!))
                : "Unknown";

            return Card(
              child: ListTile(
                leading: season.posterPath != null
                    ? Image.network(
                        'https://image.tmdb.org/t/p/w92${season.posterPath}',
                        width: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.movie, size: 50);
                        },
                      )
                    : const Icon(Icons.movie, size: 50),
                title: Text(season.name),
                subtitle: Text(
                  '${season.episodeCount} episode • $releaseDate',
                ),
                onTap: () {},
              ),
            );
          },
        ),
      ],
    );
  }
}
