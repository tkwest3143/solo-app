import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'build/home.g.dart';

@riverpod
class HomeState extends _$HomeState {
  @override
  Future<String> build() async {
    return "Solo App Home State";
  }
}
