import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:test_video_app/cubits/home_cubit/home_cubit.dart';
import 'package:test_video_app/views/video_header.dart';
import 'package:test_video_app/views/video_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _headerHeight = 331.0;
  static const _searchHeight = 40.0;
  final _homeCubit = HomeCubit();
  final ScrollController _scrollController = ScrollController();
  double _scrollPosition = 0.0;

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);

    super.initState();

    _homeCubit.fetchVideos(isRefresh: true);
  }

  void _scrollListener() {
    setState(() => _scrollPosition = _scrollController.position.pixels);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _homeCubit.fetchVideos(isRefresh: false);
      }
    });
  }

  Widget _searchButton() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 17.0),
        height: _searchHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// TITLE
            const Text(
              'Все видео',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16.0,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            /// BUTTON
            IconButton(
              onPressed: () => _homeCubit.showSearchPage(context: context),
              icon: SvgPicture.asset('assets/search.svg'),
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _scrollPosition >= _searchHeight + _headerHeight
          ? AppBar(
              titleSpacing: 0.0,
              title: _searchButton(),
            )
          : AppBar(
              title: const Text(
              'Список видео',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18.0,
              ),
            )),
      body: BlocConsumer<HomeCubit, HomeState>(
        bloc: _homeCubit,
        listener: (context, state) {},
        builder: (context, state) {
          return state.when(
            success: (videos) => Scrollbar(
                child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: _scrollController,
                    itemCount: videos.length,
                    itemBuilder: (context, index) {
                      return Column(children: [
                        index == 0
                            ? Column(children: [
                                VideoHeader(
                                  key: ValueKey(videos[index].id),
                                  video: videos[index],
                                  height: _headerHeight,
                                  onLikeTap: () => _homeCubit.likeVideo(
                                    index: index,
                                    videos: videos,
                                  ),
                                ),
                                _searchButton(),
                              ])
                            : VideoItem(
                                video: videos[index],
                                onTap: () => _homeCubit.showVideoPage(
                                  context: context,
                                  index: index,
                                  videos: videos,
                                ),
                                onLikeTap: () => _homeCubit.likeVideo(
                                  index: index,
                                  videos: videos,
                                ),
                              )
                      ]);
                    })),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            alert: (message) => Center(
                child: TextButton(
              onPressed: () => _homeCubit.fetchVideos(isRefresh: true),
              child: const Text(
                'Обновить',
                style: TextStyle(fontSize: 20.0),
              ),
            )),
          );
        },
      ),
    );
  }
}
