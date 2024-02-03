import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test_video_app/entities/models.dart';

class VideoHeader extends StatelessWidget {
  final double? height;
  final Video video;
  final VoidCallback onLikeTap;

  const VideoHeader({
    super.key,
    required this.video,
    this.height,
    required this.onLikeTap,
  });

  @override
  Widget build(BuildContext context) {
    DateTime createdAt = DateTime.parse(video.created_at);

    Widget column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// THUMBNAIL
        Container(
          width: MediaQuery.of(context).size.width,
          height: 212.0,
          color: Colors.grey[200],
          child: Image.network(
            video.image,
            fit: BoxFit.cover,
          ),
        ),
        ListView(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.only(top: 14.0),
          children: [
            /// NAME
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 17.0),
                child: Text(
                  video.name,
                  maxLines: 3,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14.0,
                    overflow: TextOverflow.ellipsis,
                  ),
                )),
            const SizedBox(height: 4.0),
            Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 17.0,
                ),
                child: Row(children: [
                  /// VIEWS
                  Text(
                    '${video.views.toString()} просмотров • ',
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: Color.fromRGBO(82, 82, 82, 1.0),
                    ),
                  ),

                  /// CREATED AT
                  Text(
                    '${createdAt.day}.${createdAt.month}.${createdAt.year}',
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: Color.fromRGBO(82, 82, 82, 1.0),
                    ),
                  ),
                ])),

            Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4.0,
                ),
                child: Row(
                  children: [
                    /// LIKE BUTTON
                    IconButton(
                      onPressed: () => onLikeTap(),
                      icon: SvgPicture.asset(video.liked
                          ? 'assets/like.svg'
                          : 'assets/like_filled.svg'),
                    ),
                  ],
                ))
          ],
        )
      ],
    );

    return height == null
        ? column
        : SizedBox(
            height: height,
            child: column,
          );
  }
}
