import 'package:flutter_riverpod/flutter_riverpod.dart';

final dashboardProvider =
    StateNotifierProvider<DashboardStateNotifier, int>((ref) {
  return DashboardStateNotifier();
});

class DashboardStateNotifier extends StateNotifier<int> {
  DashboardStateNotifier() : super(0);

  void setIndex(int index) {
    state = index;
  }
}
