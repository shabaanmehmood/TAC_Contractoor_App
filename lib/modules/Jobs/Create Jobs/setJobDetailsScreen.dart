import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:taccontractor/data/data/constants/app_assets.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_spacing.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';
import 'package:taccontractor/models/jobCategoriesModel.dart';
import 'package:taccontractor/widhets/common%20widgets/buttons/tappableInputTile.dart';
import '../../../models/jobPremisesModel.dart';
import '../../../models/shift_model.dart';
import '../../../widhets/common overlays/jobCategory_overlay.dart';
import '../../../widhets/common overlays/jobPremises_overlay.dart';
import 'company_info_controller.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class SetJobDetailsScreen extends StatefulWidget {

  @override
  State<SetJobDetailsScreen> createState() => _SetJobDetailsScreenState();
}

class _SetJobDetailsScreenState extends State<SetJobDetailsScreen> {

  InputDecoration _inputDecoration(String hintText, String iconPath) {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.kDarkestBlue,
      prefixIconConstraints: const BoxConstraints(minWidth: 40),
      hintText: hintText,
      counter: const Offstage(),
      hintStyle: AppTypography.kLight14.copyWith(color: AppColors.kinput),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.kSkyBlue, width: 1.5),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.kSkyBlue, width: 2),
      ),
      border: const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.kSkyBlue),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 5),
    );
  }

  final SetJobDetailsController controller = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.fetchJobCategories(controller.userController.userData.value!.id!);
    controller.fetchJobPremises(controller.userController.userData.value!.id!);
  }

  final List<String> allDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  final Map<String, String> dayAbbreviationToFull = {
    'Mon': 'Monday',
    'Tue': 'Tuesday',
    'Wed': 'Wednesday',
    'Thu': 'Thursday',
    'Fri': 'Friday',
    'Sat': 'Saturday',
    'Sun': 'Sunday',
  };

  List<String> getDayAbbreviationsBetween(DateTime start, DateTime end) {
    final List<String> days = [];
    DateTime current = start;
    final DateFormat abbrevFormat = DateFormat('E'); // 'Mon', 'Tue', etc.

    while (!current.isAfter(end)) {
      days.add(abbrevFormat.format(current));
      current = current.add(Duration(days: 1));
    }
    return days;
  }

  String getTimePeriod(String time) {
    // Assumes time is in HH:MM format (e.g., "10:00", "13:00")
    final parts = time.split(':');
    if (parts.length != 2) return "AM"; // fallback
    final hour = int.tryParse(parts[0]) ?? 0;
    return hour < 12 ? "AM" : "PM";
  }


  void _showAddShiftDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final startDateController = TextEditingController();
    final endDateController = TextEditingController();
    final startTimeController = TextEditingController();
    final endTimeController = TextEditingController();

    // These will hold the actual DateTime values
    DateTime? pickedStartDate;
    DateTime? pickedEndDate;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add Shift", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.kDarkBlue,
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Obx(() => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (controller.jobType.value == 'recurring') ...[
                  TextFormField(
                    style: const TextStyle(color: AppColors.kWhite),
                    controller: startDateController,
                    validator: controller.validateRequired,
                    decoration: _inputDecoration("Start Date", AppAssets.kCal),
                    readOnly: true,
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2200),
                        builder: (context, child) => Theme(
                          data: Theme.of(context).copyWith(
                            dialogBackgroundColor: AppColors.kDarkestBlue,
                            colorScheme: ColorScheme.dark(
                              primary: AppColors.kSkyBlue,
                              onPrimary: Colors.black,
                              surface: AppColors.kDarkestBlue,
                              onSurface: Colors.white,
                            ),
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.kSkyBlue,
                              ),
                            ),
                          ),
                          child: child!,
                        ),
                      );
                      if (picked != null) {
                        pickedStartDate = picked;
                        startDateController.text = picked.toIso8601String().split('T').first;
                      }
                    },
                  ),
                  SizedBox(height: AppSpacing.tenVertical),
                  TextFormField(
                    style: const TextStyle(color: AppColors.kWhite),
                    controller: endDateController,
                    validator: controller.validateRequired,
                    decoration: _inputDecoration("End Date", AppAssets.kCal),
                    readOnly: true,
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2200),
                        builder: (context, child) => Theme(
                          data: Theme.of(context).copyWith(
                            dialogBackgroundColor: AppColors.kDarkestBlue,
                            colorScheme: ColorScheme.dark(
                              primary: AppColors.kSkyBlue,
                              onPrimary: Colors.black,
                              surface: AppColors.kDarkestBlue,
                              onSurface: Colors.white,
                            ),
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.kSkyBlue,
                              ),
                            ),
                          ),
                          child: child!,
                        ),
                      );
                      if (picked != null) {
                        pickedEndDate = picked;
                        endDateController.text = picked.toIso8601String().split('T').first;
                      }
                    },
                  ),
                ],
                if (controller.jobType.value == 'onetime') ...[
                  TextFormField(
                    style: const TextStyle(color: AppColors.kWhite),
                    controller: startDateController,
                    validator: controller.validateRequired,
                    decoration: _inputDecoration("Start Date", AppAssets.kCal),
                    readOnly: true,
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2200),
                        builder: (context, child) => Theme(
                          data: Theme.of(context).copyWith(
                            dialogBackgroundColor: AppColors.kDarkestBlue,
                            colorScheme: ColorScheme.dark(
                              primary: AppColors.kSkyBlue,
                              onPrimary: Colors.black,
                              surface: AppColors.kDarkestBlue,
                              onSurface: Colors.white,
                            ),
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.kSkyBlue,
                              ),
                            ),
                          ),
                          child: child!,
                        ),
                      );
                      if (picked != null) {
                        pickedStartDate = picked;
                        startDateController.text = picked.toIso8601String().split('T').first;
                      }
                    },
                  ),
                ],
                SizedBox(height: AppSpacing.fifteenVertical),
                TextFormField(
                  style: const TextStyle(color: AppColors.kWhite),
                  controller: startTimeController,
                  validator: controller.validateRequired,
                  decoration: _inputDecoration("Start Time", AppAssets.kCal),
                  readOnly: true,
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                      builder: (context, child) => MediaQuery(
                        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            dialogBackgroundColor: AppColors.kDarkestBlue,
                            colorScheme: ColorScheme.dark(
                              primary: AppColors.kSkyBlue,
                              onPrimary: Colors.black,
                              surface: AppColors.kDarkestBlue,
                              onSurface: Colors.white,
                            ),
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.kSkyBlue,
                              ),
                            ),
                          ),
                          child: child!,
                        ),
                      ),
                    );
                    if (picked != null) {
                      startTimeController.text =
                      '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
                    }
                  },
                ),
                SizedBox(height: AppSpacing.tenVertical),
                TextFormField(
                  style: const TextStyle(color: AppColors.kWhite),
                  controller: endTimeController,
                  validator: controller.validateRequired,
                  decoration: _inputDecoration("End Time", AppAssets.kCal),
                  readOnly: true,
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                      builder: (context, child) => MediaQuery(
                        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            dialogBackgroundColor: AppColors.kDarkestBlue,
                            colorScheme: ColorScheme.dark(
                              primary: AppColors.kSkyBlue,
                              onPrimary: Colors.black,
                              surface: AppColors.kDarkestBlue,
                              onSurface: Colors.white,
                            ),
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.kSkyBlue,
                              ),
                            ),
                          ),
                          child: child!,
                        ),
                      ),
                    );
                    if (picked != null) {
                      endTimeController.text =
                      '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
                    }
                  },
                ),
              ],
            )),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("Cancel", style: AppTypography.kBold16.copyWith(color: AppColors.kSkyBlue)),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                DateTime? startDate;
                DateTime? endDate;

                try {
                  startDate = pickedStartDate ?? DateTime.parse(startDateController.text);
                  if (controller.jobType.value == 'recurring') {
                    endDate = pickedEndDate ?? DateTime.parse(endDateController.text);
                  }
                } catch (e) {
                  Get.snackbar('Error', 'Please select valid start and end dates.');
                  return;
                }

                // FIX 2: Only validate endDate for recurring jobs
                if (controller.jobType.value == 'recurring') {
                  if (endDate == null) {
                    Get.snackbar('Error', 'End date required for recurring jobs');
                    return;
                  }
                  if (startDate.isAfter(endDate)) {
                    Get.snackbar('Error', 'Start date cannot be after end date');
                    return;
                  }
                }



                // Generate days between
                List<Shift> shiftsList = [];

                if (controller.jobType.value == 'onetime') {
                  shiftsList = generateShiftsPerDay(
                    startDate: startDate,
                    endDate: startDate.add(Duration(days: 1)),
                    startTime: startTimeController.text,
                    endTime: endTimeController.text,
                  );
                } else {
                  if (startDate != null && endDate != null && !endDate.isBefore(startDate)) {
                    shiftsList = generateShiftsPerDay(
                      startDate: startDate,
                      endDate: endDate,
                      startTime: startTimeController.text,
                      endTime: endTimeController.text,
                    );
                  } else {
                    Get.snackbar('Error', 'End date must be after start date.');
                    return;
                  }
                }

                controller.addShifts(shiftsList);
                Get.back();
              }
            },
            child: Text("Add", style: AppTypography.kBold16.copyWith(color: AppColors.kSkyBlue)),
          ),
        ],
      ),
    );
  }

  Widget _buildShiftList() {
    return Obx(() {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ...controller.shifts.asMap().entries.map((entry) {
            final index = entry.key;
            final shift = entry.value;
            final dayWords = shift.days
                .map((d) => dayAbbreviationToFull[d] ?? d)
                .join(', ');
            return ListTile(
              style: ListTileStyle.drawer,
              title: Text(
                dayWords,
                style: AppTypography.kBold16.copyWith(color: AppColors.kSkyBlue),
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => controller.removeShift(index),
              ),
            );
          }).toList(),
          if (controller.canAddShift)
            TextButton(
              onPressed: () => _showAddShiftDialog(Get.context!),
              child: Text(
                "Add Shift +",
                style: AppTypography.kBold16.copyWith(color: AppColors.kSkyBlue),
              ),
            ),
        ],
      );
    });
  }

  final _uuid = Uuid();

  List<Shift> generateShiftsPerDay({
    required DateTime startDate,
    required DateTime endDate,
    required String startTime, // In HH:MM 24-hour
    required String endTime,   // In HH:MM 24-hour
    bool? isOvernight,
  }) {
    List<Shift> shifts = [];
    DateTime current = startDate;

    while (!current.isAfter(endDate)) {
      String dayName = DateFormat('EEEE').format(current);
      String dateIso = current.toIso8601String().split('T').first + "T00:00:00.000Z";
      String timePeriod = getTimePeriod(startTime); // "AM" or "PM" based on startTime

      // Convert to 12-hour without AM/PM
      String startTime12 = convertTo12HourNoAmPm(startTime);
      String endTime12 = convertTo12HourNoAmPm(endTime);

      shifts.add(
        Shift(
          id: _uuid.v4(),
          date: dateIso,
          days: [dayName],
          timePeriod: timePeriod,
          startTime: startTime12, // Now in 12-hour without AM/PM
          endTime: endTime12,     // Now in 12-hour without AM/PM
          isOvernight: isOvernight,
        ),
      );
      current = current.add(Duration(days: 1));
    }
    return shifts;
  }

  String convertTo12HourNoAmPm(String time24) {
    int hour = int.tryParse(time24.split(':')[0]) ?? 0;
    int minute = int.tryParse(time24.split(':')[1]) ?? 0;
    hour = hour % 12;
    hour = hour == 0 ? 12 : hour; // 0 becomes 12 in 12-hour
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }



  void showJobCategoryBottomSheet(BuildContext context, controller) {
    showModalBottomSheet(
      context: context,
      enableDrag: true,
      isDismissible: true,
      useSafeArea: true,
      backgroundColor: AppColors.kDarkBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Obx(() {
            if (controller.availableCategories.isEmpty) {
              return Center(child: CircularProgressIndicator());
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Divider(
                  color: Colors.grey,
                  thickness: 5,
                  indent: 140,
                  endIndent: 140,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Job Category",
                      style: AppTypography.kBold18.copyWith(color: AppColors.kWhite),
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Text("Done", style: AppTypography.kBold16.copyWith(color: AppColors.kSkyBlue)),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.tenVertical),
                ...controller.availableCategories.map((category) =>
                    _buildJobCategoryOption(controller, category)
                ).toList(),
              ],
            );
          }),
        );
      },
    );
  }

  Widget _buildJobCategoryOption(controller, JobCategoryModel category) {
    return RadioListTile<String>(
      value: category.id.toString(),
      groupValue: controller.selectedCategory.value,
      onChanged: (String? value) {
        debugPrint('Selected value: $value');
        controller.selectedCategory.value = value;
        debugPrint('Selected category: ${controller.selectedCategory.value}');
      },
      title: Text(category.name, style: TextStyle(color: Colors.white)),
      activeColor: AppColors.kSkyBlue,
    );
  }

  void showJobPremisesBottomSheet(BuildContext context, controller) {
    showModalBottomSheet(
      context: context,
      enableDrag: true,
      isDismissible: true,
      useSafeArea: true,
      backgroundColor: AppColors.kDarkBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Obx(() {
            if (controller.availablePremises.isEmpty) {
              return Center(child: CircularProgressIndicator());
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Divider(
                  color: Colors.grey,
                  thickness: 5,
                  indent: 140,
                  endIndent: 140,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Job Premises",
                      style: AppTypography.kBold18.copyWith(color: AppColors.kWhite),
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Text(
                        "Done",
                        style: AppTypography.kBold16.copyWith(color: AppColors.kSkyBlue),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.tenVertical),
                ...controller.availablePremises.map((premise) =>
                    _buildJobPremisesOption(controller, premise)
                ).toList(),
              ],
            );
          }),
        );
      },
    );
  }

  Widget _buildJobPremisesOption(controller, JobPremisesModel premise) {
    return RadioListTile<String>(
      value: premise.id,
      groupValue: controller.selectedPremises.value,
      onChanged: (String? value) {
        controller.selectedPremises.value = value;
      },
      title: Text(premise.name, style: TextStyle(color: Colors.white)),
      activeColor: AppColors.kSkyBlue,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkestBlue,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                      onTap: () => Get.back(),
                      child: Image.asset(AppAssets.kArrowBackward)
                  ),                  const SizedBox(width: 10),
                  Text("Create New Job", style: AppTypography.kBold24.copyWith(color: Colors.white)),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: const [
                  StepTab(title: "Job Details", isCurrent: true),
                  StepTab(title: "Preferences"),
                  StepTab(title: "Required Docs"),
                ],
              ),
              const SizedBox(height: 20),
              Text("Set Jobs Details",
                  style: AppTypography.kBold20.copyWith(color: Colors.white)),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          style: const TextStyle(color: AppColors.kWhite),
                          controller: controller.jobTitle,
                          decoration:
                              _inputDecoration("Set Job Title", AppAssets.kPer),
                          validator: controller.validateRequired,
                          onChanged: (value){
                            controller.formKey.currentState?.validate();
                          },
                        ),
                        SizedBox(height: AppSpacing.fifteenVertical),
                        TextFormField(
                          controller: controller.payPerHour,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: const TextStyle(color: AppColors.kWhite),
                          decoration: _inputDecoration(
                              "Set Pay Per Hour", AppAssets.kMail),
                          validator: controller.validateRequired,
                          onChanged: (value){
                            controller.formKey.currentState?.validate();
                          },
                        ),
                        SizedBox(height: AppSpacing.fifteenVertical),
                        Obx(() {
                          final selectedName = controller.selectedCategory.value.isEmpty
                              ? "Job Category"
                              : controller.availableCategories
                              .firstWhere(
                                (cat) => cat.id == controller.selectedCategory.value,
                            orElse: () => JobCategoryModel(id: '', name: 'Unknown'),
                          ).name;

                          return TappableInputTile(
                            title: "Job Category",
                            controller: TextEditingController(text: selectedName),
                            onTap: () {
                              showJobCategoryBottomSheet(context, controller);
                            },
                          );
                        }),
                        SizedBox(height: AppSpacing.fifteenVertical),
                        TextFormField(
                          style: const TextStyle(color: AppColors.kWhite),
                          controller: controller.jobResponsiblities,
                          decoration: _inputDecoration(
                              "Job Responsibilities", AppAssets.kCal),
                          validator: controller.validateRequired,
                          onChanged: (value){
                            controller.formKey.currentState?.validate();
                          },
                        ),
                        SizedBox(height: AppSpacing.fifteenVertical),
                        TextFormField(
                          style: const TextStyle(color: AppColors.kWhite),
                          controller: controller.jobSOPs,
                          decoration: _inputDecoration(
                              "Job SOP", AppAssets.kCal),
                          validator: controller.validateRequired,
                          onChanged: (value){
                            controller.formKey.currentState?.validate();
                          },
                        ),
                        SizedBox(height: AppSpacing.fifteenVertical),
                        TextFormField(
                          style: const TextStyle(color: AppColors.kWhite),
                          controller: controller.noOfGuardsRequired,
                          keyboardType: TextInputType.number,
                          decoration: _inputDecoration(
                              "No. Required Guards", AppAssets.kCal),
                          validator: controller.validateRequired,
                          onChanged: (value){
                            controller.formKey.currentState?.validate();
                          },
                          maxLength: 3,
                        ),
                        SizedBox(height: AppSpacing.fifteenVertical),
                        Text(
                          "Leader Required",
                          style: AppTypography.kBold16.copyWith(
                              color: AppColors.kWhite),
                        ),
                        SizedBox(height: AppSpacing.fiveVertical),
                        Obx(() => Row(
                          children: [
                            Row(
                              children: [
                                Radio<bool>(
                                  activeColor: AppColors.kSkyBlue,
                                  value: true,
                                  groupValue: controller.leaderRequired.value,
                                  onChanged: (value) => controller.leaderRequired.value = value!,
                                ),
                                Text('Yes', style: AppTypography.kBold16.copyWith(color: AppColors.kWhite)),
                              ],
                            ),
                            SizedBox(width: 20),
                            Row(
                              children: [
                                Radio<bool>(
                                  activeColor: AppColors.kSkyBlue,
                                  value: false,
                                  groupValue: controller.leaderRequired.value,
                                  onChanged: (value) => controller.leaderRequired.value = value!,
                                ),
                                Text('No', style: AppTypography.kBold16.copyWith(color: AppColors.kWhite)),
                              ],
                            ),
                          ],
                        )),
                        TextFormField(
                          style: const TextStyle(color: AppColors.kWhite),
                          controller: controller.siteLocation,
                          decoration: _inputDecoration(
                              "Site Location", AppAssets.kCal),
                          validator: controller.validateRequired,
                          onChanged: (value){
                            controller.formKey.currentState?.validate();
                          },
                        ),
                        SizedBox(height: AppSpacing.fifteenVertical),
                        Obx(() {
                          final selectedName = controller.selectedPremises.value.isEmpty
                              ? "Job Premises"
                              : controller.availablePremises
                              .firstWhere(
                                (cat) => cat.id == controller.selectedPremises.value,
                            orElse: () => JobPremisesModel(id: '', name: 'Unknown'),
                          ).name;

                          return TappableInputTile(
                            title: "Job Premises",
                            controller: TextEditingController(text: selectedName),
                            onTap: () {
                              showJobPremisesBottomSheet(context, controller);
                            },
                          );
                        }),
                        SizedBox(height: AppSpacing.fifteenVertical),
                        TextFormField(
                          style: const TextStyle(color: AppColors.kWhite),
                          controller: controller.reportingManager,
                          decoration: _inputDecoration(
                              "Reporting Manager", AppAssets.kCal),
                          validator: controller.validateRequired,
                          onChanged: (value){
                            controller.formKey.currentState?.validate();
                          },
                          maxLength: 9,
                        ),
                        SizedBox(height: AppSpacing.fifteenVertical),
                        TextFormField(
                          style: const TextStyle(color: AppColors.kWhite),
                          controller: controller.reportingManagerNumber,
                          decoration: _inputDecoration(
                              "Reporting Manager Number", AppAssets.kCal),
                          validator: controller.validatePhone,
                          onChanged: (value){
                            controller.formKey.currentState?.validate();
                          },
                          maxLength: 10,
                        ),
                        SizedBox(height: AppSpacing.fifteenVertical),
                        Text(
                          "Job",
                          style: AppTypography.kBold16.copyWith(
                              color: AppColors.kWhite),
                        ),
                        Obx(() => Row(
                          children: [
                            Row(
                              children: [
                                Radio<String>(
                                  activeColor: AppColors.kSkyBlue,
                                  value: 'recurring',
                                  groupValue: controller.jobType.value,
                                  onChanged: (value) => controller.jobType.value = value!,
                                ),
                                Text('Recurring',style: AppTypography.kBold16.copyWith(color: AppColors.kWhite),),
                              ],
                            ),
                            SizedBox(width: 20),
                            Row(
                              children: [
                                Radio<String>(
                                  activeColor: AppColors.kSkyBlue,
                                  value: 'onetime',
                                  groupValue: controller.jobType.value,
                                  onChanged: (value) => controller.jobType.value = value!,
                                ),
                                Text('One Time', style: AppTypography.kBold16.copyWith(color: AppColors.kWhite),),
                              ],
                            ),
                          ],
                        )),
                        _buildShiftList(),
                        SizedBox(height: AppSpacing.fifteenVertical),
                      ],
                    ),
                  ),
                ),
              ),
              const Divider(
                  color: AppColors.ktextlight, thickness: 1, height: 0),
              const SizedBox(height: 10),
              Row(
                children: [
                  OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                          color: AppColors.kSkyBlue, width: 1.5),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text('Back',
                        style: AppTypography.kBold16
                            .copyWith(color: AppColors.kSkyBlue)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: controller.onContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.kSkyBlue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text("Next & Set Preferences",
                          style: AppTypography.kBold16
                              .copyWith(color: Colors.black)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class StepTab extends StatelessWidget {
  final String title;
  final bool isCurrent;
  final bool isCompleted;

  const StepTab({
    required this.title,
    this.isCurrent = false,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    Color progressColor = isCompleted
        ? AppColors.kSkyBlue
        : isCurrent
            ? AppColors.kWhite
            : AppColors.ktextlight.withOpacity(0.2);

    double progressValue = isCompleted
        ? 1
        : isCurrent
            ? 0.5
            : 0.0;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 8.0), // Adjust this padding to your preference
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: progressValue,
                minHeight: 8,
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                backgroundColor: AppColors.ktextlight.withOpacity(0.2),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: AppTypography.kBold14.copyWith(
                color: Colors.white,
                fontFamily: 'YourFontFamily', // Specify the font family
                fontSize: 13, // Adjust the font size
                fontWeight:
                    FontWeight.w600, // Adjust the font weight (optional)
              ),
            )
          ],
        ),
      ),
    );
  }
}
