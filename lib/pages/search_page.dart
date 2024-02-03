import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_video_app/cubits/search_cubit/search_cubit.dart';
import 'package:test_video_app/entities/models.dart';
import 'package:test_video_app/views/custom_text_field.dart';
import 'package:test_video_app/views/video_item.dart';

class SearchPage extends StatefulWidget {
  final Function(List<Video>) onPop;

  const SearchPage({
    super.key,
    required this.onPop,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final SearchCubit _searchCubit = SearchCubit();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    _textEditingController.addListener(_textListener);

    super.initState();

    _searchCubit.fetchVideos(isRefresh: true);
  }

  void _scrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _searchCubit.fetchVideos(isRefresh: false);
      }
    });
  }

  void _textListener() {
    _textEditingController.addListener(() {
      _searchCubit.searchVideos(text: _textEditingController.text);
    });
  }

  @override
  void dispose() {
    widget.onPop(_searchCubit.videos);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: TextViewWidget(
          textEditingController: _textEditingController,
          focusNode: _focusNode,
          placeholder: 'Поиск видео',
        ),
      ),
      body: BlocConsumer<SearchCubit, SearchState>(
        bloc: _searchCubit,
        listener: (context, state) {},
        builder: (context, state) {
          return state.when(
            success: (videos) => Scrollbar(
                child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: _scrollController,
                    itemCount: videos.length,
                    itemBuilder: (context, index) {
                      return VideoItem(
                        video: videos[index],
                        onTap: () => _searchCubit.showVideoPage(
                          context: context,
                          index: index,
                          videos: videos,
                        ),
                        onLikeTap: () => _searchCubit.likeVideo(
                          index: index,
                          currentVideos: videos,
                        ),
                      );
                    })),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            alert: (message) => Center(
                child: TextButton(
              onPressed: () => _textEditingController.text.isEmpty
                  ? _searchCubit.fetchVideos(isRefresh: true)
                  : _searchCubit.searchVideos(
                      text: _textEditingController.text),
              child: const Text(
                'Обновить',
                style: TextStyle(fontSize: 20.0),
              ),
            )),
            empty: () => const Center(
                child: Text(
              'Нет результатов',
              style: TextStyle(fontSize: 16.0),
            )),
          );
        },
      ),
    );
  }
}
