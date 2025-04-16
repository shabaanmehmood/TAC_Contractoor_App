import 'package:get/get.dart';
import 'dart:async';

class JobLiveController extends GetxController {
  var isApproved = false.obs;
  var seconds = 0.obs;
  var checkboxValue = false.obs;

  Timer? _timer;

  void startTimerIfApproved() {
    if (isApproved.value) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        seconds.value++;
      });
    }
  }

  void toggleApproval() {
    isApproved.value = true;
    startTimerIfApproved();
  }

  String get timerText {
    final hrs = (seconds.value ~/ 3600).toString().padLeft(2, '0');
    final mins = ((seconds.value % 3600) ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds.value % 60).toString().padLeft(2, '0');
    return "$hrs:$mins:$secs";
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
