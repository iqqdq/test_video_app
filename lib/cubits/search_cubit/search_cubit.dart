import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:test_video_app/components/debouncer.dart';
import 'package:test_video_app/entities/data_providers.dart';
import 'package:test_video_app/entities/models.dart';
import 'package:test_video_app/pages/video_page.dart';
part 'search_state.dart';
part 'search_cubit.freezed.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(const SearchState.loading());

  Pagination _pagination = const Pagination(
    page: 1,
    hasMore: true,
  );

  List<Video> videos = [];

  Future fetchVideos({required bool isRefresh}) async {
    if (isRefresh) {
      emit(const SearchState.loading());

      _pagination = const Pagination(
        page: 1,
        hasMore: true,
      );

      videos.clear();
    }

    try {
      await const VideosDataProviderMock()
          .getVideos(
            page: _pagination.page,
            search: '',
          )
          .then((value) => {
                if (value.data.isNotEmpty)
                  {
                    _pagination =
                        _pagination.copyWith(page: _pagination.page + 1),
                    videos.addAll(value.data),
                    emit(SearchState.success(videos)),
                  }
                else
                  emit(const SearchState.empty()),
              });
    } on Exception catch (e) {
      emit(SearchState.alert(e.toString()));
    }
  }

  Future searchVideos({required String text}) async {
    emit(const SearchState.loading());

    _pagination = const Pagination(
      page: 1,
      hasMore: true,
    );

    Debouncer(milliseconds: 500).run(() async {
      try {
        await const VideosDataProviderMock()
            .getVideos(
              page: _pagination.page,
              search: text,
            )
            .then((value) => {
                  if (value.data.isNotEmpty)
                    {
                      videos = value.data,
                      emit(SearchState.success(videos)),
                    }
                  else
                    {
                      emit(const SearchState.empty()),
                    }
                });
      } on Exception catch (e) {
        emit(SearchState.alert(e.toString()));
      }
    });
  }

  void likeVideo({
    required int index,
    required List<Video> currentVideos,
  }) {
    List<Video> newVideos = [];
    newVideos.addAll(videos);
    newVideos[index] =
        currentVideos[index].copyWith(liked: !currentVideos[index].liked);
    videos = newVideos;
    emit(SearchState.success(videos));
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
              newVideos.addAll(videos),
              newVideos[index] = newVideo ?? videos[index],
              videos = newVideos,
              emit(SearchState.success(videos)),
            },
          ),
        ));
  }
}
