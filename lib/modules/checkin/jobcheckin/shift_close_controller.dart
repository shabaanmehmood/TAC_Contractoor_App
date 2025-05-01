import 'package:get/get.dart';

class ShiftCloseController extends GetxController {
  var selectedReason = ''.obs;
  var customReason = ''.obs;

  final reasons = [
    'I have an emergency and need to leave',
    'I am feeling unwell and cannot continue',
    'There is a safety concern at the job site',
    'Other (please specify)'
  ];
}
