import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_video_app/cubits/video_cubit/video_cubit.dart';
import 'package:test_video_app/entities/models.dart';
import 'package:test_video_app/views/video_header.dart';

class VideoPage extends StatefulWidget {
  final Video video;
  final Function(Video?) onPop;

  const VideoPage({
    super.key,
    required this.video,
    required this.onPop,
  });

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoCubit _videoCubit;

  @override
  void initState() {
    _videoCubit = VideoCubit(widget.video);

    super.initState();
  }

  @override
  void dispose() {
    widget.onPop(_videoCubit.newVideo);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: BlocConsumer<VideoCubit, VideoState>(
          bloc: _videoCubit,
          listener: (context, state) {},
          builder: (context, state) {
            return state.when(
                initial: (video) => VideoHeader(
                      video: video,
                      onLikeTap: () => _videoCubit.likeVideo(video: video),
                    ));
          }),
    );
  }
}
