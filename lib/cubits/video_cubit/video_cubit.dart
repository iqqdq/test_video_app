import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:test_video_app/entities/models.dart';
part 'video_state.dart';
part 'video_cubit.freezed.dart';

class VideoCubit extends Cubit<VideoState> {
  final Video video;
  Video? newVideo;

  VideoCubit(this.video) : super(VideoState.initial(video));

  void likeVideo({required Video video}) {
    bool isLiked = !video.liked;
    newVideo = video.copyWith(liked: isLiked);

    if (newVideo != null) {
      emit(VideoState.initial(newVideo!));
    }
  }
}
