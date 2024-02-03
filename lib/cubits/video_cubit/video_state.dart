part of 'video_cubit.dart';

@freezed
abstract class VideoState with _$VideoState {
  const factory VideoState.initial(Video video) = _Initial;
}
