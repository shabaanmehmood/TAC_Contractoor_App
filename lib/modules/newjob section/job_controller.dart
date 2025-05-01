import 'package:get/get.dart';
import 'job_model.dart';
import 'job_dummy_data.dart';

class JobController extends GetxController {
  var selectedFilter = 'Active'.obs;

  List<JobModel> get filteredJobs {
    if (selectedFilter.value == 'Active') {
      return dummyJobs
          .where((job) =>
              job.status == 'In Progress' ||
              job.status == 'Awaiting' ||
              job.status == 'Time')
          .toList();
    }
    return dummyJobs
        .where((job) => job.statusLabel == selectedFilter.value)
        .toList();
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }
}
