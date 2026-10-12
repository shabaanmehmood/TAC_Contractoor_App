import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:taccontractor/dataproviders/api_service.dart';
import '../models/getUserById_model.dart';
import '../models/userdata_model.dart';

class UserController extends GetxController {
  Rxn<Data> userData = Rxn<Data>();
  late MyApIService apiService;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    apiService = MyApIService();
  }

  void setUser(Data data, {Data? authData}) {
    final previous = userData.value;
    data.token ??= authData?.token ?? previous?.token;
    data.role ??= authData?.role ?? previous?.role;
    data.registeringAs ??= authData?.registeringAs ?? previous?.registeringAs;
    data.isVerified ??= authData?.isVerified ?? previous?.isVerified;
    data.isActive ??= authData?.isActive ?? previous?.isActive;
    userData.value = data;
  }

  void clearUser() {
    userData.value = null;
  }

  String? get accessToken => userData.value?.token;
  String? get accountId => userData.value?.id;

  String? get accountType {
    final values = [userData.value?.role, userData.value?.registeringAs]
        .whereType<String>()
        .map((value) => value.toLowerCase());
    for (final value in values) {
      if (value.contains('admin')) return 'admin';
      if (value.contains('guard')) return 'guard';
      if (value.contains('contractor') || value.contains('company')) {
        return 'contractor';
      }
    }
    return null;
  }

  Future<void> getUserData({String? userId}) async {
    try {
      final response =
          await apiService.getUserByID(userId ?? userData.value?.id ?? '');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final userData = GetUserById.fromJson(json).data;

        if (userData != null) {
          setUser(userData);
          debugPrint('User data refreshed successfully');
        } else {
          clearUser();
          debugPrint('No user data received');
        }
      } else {
        clearUser();
        debugPrint('Error fetching user data: ${response.statusCode}');
      }
    } catch (e) {
      clearUser();
      debugPrint('Exception while fetching user data: $e');
    }
  }

  bool get isLoggedIn => userData.value != null;
}
