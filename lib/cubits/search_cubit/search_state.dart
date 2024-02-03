part of 'search_cubit.dart';

@freezed
abstract class SearchState with _$SearchState {
  const factory SearchState.loading() = _Loading;
  const factory SearchState.empty() = _Empty;
  const factory SearchState.success(List<Video> videos) = _Success;
  const factory SearchState.alert(String? message) = _Alert;
}
