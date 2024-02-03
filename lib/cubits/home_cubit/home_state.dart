part of 'home_cubit.dart';

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState.loading() = _Loading;
  const factory HomeState.success(List<Video> videos) = _Success;
  const factory HomeState.alert(String? message) = _Alert;
}
