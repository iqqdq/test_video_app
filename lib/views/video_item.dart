import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test_video_app/entities/models.dart';

class VideoItem extends StatelessWidget {
  final Video video;
  final VoidCallback onTap;
  final VoidCallback onLikeTap;

  const VideoItem({
    super.key,
    required this.video,
    required this.onTap,
    required this.onLikeTap,
  });

  @override
  Widget build(BuildContext context) {
    DateTime createdAt = DateTime.parse(video.created_at);

    return Material(
      key: ValueKey(video.id),
      child: InkWell(
        highlightColor:
            Platform.isAndroid ? Colors.transparent : Colors.black12,
        splashColor: Platform.isAndroid ? Colors.black12 : Colors.transparent,
        onTap: () => onTap(),
        child: Container(
          height: 134.0,
          padding: const EdgeInsets.symmetric(
            horizontal: 17.0,
            vertical: 7.0,
          ),
          child: Row(
            children: [
              /// THUMBNAIL
              Container(
                width: 173.0,
                height: 134.0,
                color: Colors.grey[200],
                child: Image.network(
                  video.image,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 11.0),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// NAME
                  Expanded(
                    child: Text(
                      video.name,
                      maxLines: 3,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              /// VIEWS
                              Text(
                                '${video.views.toString()} просмотров',
                                style: const TextStyle(
                                    fontSize: 12.0,
                                    color: Color.fromRGBO(82, 82, 82, 1.0)),
                              ),
                              const SizedBox(height: 4.0),

                              /// CREATED AT
                              Text(
                                '${createdAt.day}.${createdAt.month}.${createdAt.year}',
                                style: const TextStyle(
                                    fontSize: 12.0,
                                    color: Color.fromRGBO(82, 82, 82, 1.0)),
                              ),
                            ])),
                        IconButton(
                          onPressed: () => onLikeTap(),
                          icon: SvgPicture.asset(video.liked
                              ? 'assets/like.svg'
                              : 'assets/like_filled.svg'),
                        )
                      ])
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
