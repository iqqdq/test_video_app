import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:test_video_app/entities/data_providers.dart';
import 'package:test_video_app/entities/models.dart';
import 'package:test_video_app/pages/search_page.dart';
import 'package:test_video_app/pages/video_page.dart';
part 'home_state.dart';
part 'home_cubit.freezed.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState.loading());

  Pagination _pagination = const Pagination(
    page: 1,
    hasMore: true,
  );

  List<Video> _videos = [];

  Future fetchVideos({required bool isRefresh}) async {
    if (isRefresh) {
      _videos.clear();
      emit(const HomeState.loading());
    }

    try {
      await const VideosDataProviderMock()
          .getVideos(page: _pagination.page)
          .then((value) => {
                if (value.data.isNotEmpty)
                  {
                    _pagination =
                        _pagination.copyWith(page: _pagination.page + 1),
                    _videos.addAll(value.data),
                    emit(HomeState.success(_videos)),
                  }
              });
    } on Exception catch (e) {
      emit(HomeState.alert(e.toString()));
    }
  }

  void likeVideo({
    required int index,
    required List<Video> videos,
  }) {
    List<Video> newVideos = [];
    newVideos.addAll(videos);
    newVideos[index] = videos[index].copyWith(liked: !videos[index].liked);
    _videos = newVideos;
    emit(HomeState.success(_videos));
  }

  void showSearchPage({required BuildContext context}) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SearchPage(
                onPop: (videos) => {
                      if (videos.isNotEmpty)
                        {
                          for (var video in _videos)
                            {
                              for (var newVideo in videos)
                                {
                                  if (video.id == newVideo.id)
                                    {
                                      _videos[_videos.indexOf(video)] =
                                          newVideo,
                                    }
                                }
                            }
                        },
                      emit(const HomeState.loading()),
                      emit(HomeState.success(_videos))
                    })));
  }

  void showVideoPage({
    required BuildContext context,
    required int index,
    required List<Video> videos,
  }) {
    List<Video> newVideos = [];

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoPage(
            video: videos[index],
            onPop: (newVideo) => {
              if (newVideo != null)
                {
                  newVideos.addAll(videos),
                  newVideos[index] = newVideo,
                  _videos = newVideos,
                  emit(HomeState.success(_videos)),
                },
            },
          ),
        ));
  }
}
