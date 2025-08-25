import 'package:ditonton/common/helper.dart';
import 'package:flutter/material.dart';
import 'package:ditonton/domain/entities/episode.dart';

class EpisodeWidget extends StatefulWidget {
  final String title;
  final Episode? episode;
  final String baseImageUrl = 'https://image.tmdb.org/t/p/w500';

  const EpisodeWidget({
    Key? key,
    this.title = "Episode",
    this.episode,
  }) : super(key: key);

  @override
  State<EpisodeWidget> createState() => _EpisodeWidgetState();
}

class _EpisodeWidgetState extends State<EpisodeWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.episode == null) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (widget.episode!.stillPath != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                '${widget.baseImageUrl}${widget.episode!.stillPath}',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox.shrink();
                },
              ),
            ),
          const SizedBox(height: 16),
          Text(
            'S${widget.episode!.seasonNumber}E${widget.episode!.episodeNumber} - ${widget.episode!.name}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Release Date: ${widget.episode!.airDate != null ? Helper().getDateTimeByFormat('dd MMMM yyyy', 'en', DateTime.parse(widget.episode!.airDate!)) : "Unknown"}',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          if (widget.episode!.overview.isNotEmpty) ...[
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.episode!.overview,
                    style: const TextStyle(fontSize: 14),
                    maxLines: _isExpanded ? null : 3,
                    overflow: _isExpanded
                        ? TextOverflow.visible
                        : TextOverflow.ellipsis,
                  ),
                  if (widget.episode!.overview.length > 100)
                    Text(
                      _isExpanded ? 'Close' : 'More...',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
