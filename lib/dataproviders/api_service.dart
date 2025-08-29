import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:taccontractor/models/ReportAnIssue.dart';
import 'package:taccontractor/models/createDisputeModel.dart';
import 'package:taccontractor/models/jobApplication_model.dart';
import 'package:taccontractor/models/jobCategoriesModel.dart';
import 'package:taccontractor/models/notification_model.dart';
import 'package:taccontractor/models/signUpModelForCompany.dart';

import '../controllers/user_controller.dart';
import '../models/createJobModel.dart';
import '../models/getUserById_model.dart';
import '../models/jobResponse_model.dart';
import '../models/myJobs_model.dart';
import '../models/userdata_model.dart';
import '../models/userupdate_model.dart';

class MyApIService {

  UserController get userController => Get.find<UserController>();

  //get access token url:
  ///this 'http://192.168.5.175/flutter' part of loginTokenUrl
  ///must match the same portion of your base URL.
  ///E.g: If the base URL is = 'http://192.168.5.171/RecruitziUI/api/mobile/
  ///then the loginTokenUrl must be = 'http://192.168.5.171/RecruitziUI/oauth/token';

  ///IIS server on Remote Desktop:
  //String loginTokenUrl= 'http://192.168.5.175/flutter/oauth/token';
  //String baseurl = 'http://192.168.5.175/flutter/api/mobile/';

  /// Live portal server:
  // String loginTokenUrl = 'https://truegigs.com/portal/oauth/token';
  String baseurl = 'http://148.66.158.113:3006/api/v1/'; //portal flutter.
  // String controllerBase = 'https://truegigs.com/portal/'; //baseUrl for other calls


  Future<http.Response> signUpForCompany({required SignUpModelForCompany SignUpModelForCompany,}) async {
    var functionUrl = 'contractorAuth/signUp';
    final response = await http.post(Uri.parse(baseurl + functionUrl),
      headers: {
        'Content-Type': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      },
    body: jsonEncode(SignUpModelForCompany.toJson())
    );
    //   body: jsonEncode({
    //     'registeringAs': registeringAs,
    //     'email': email,
    //     'Name': Name,
    //     'phone': phone,
    //     'postalAddress': postalAddress,
    //     'masterSecurityLicense': masterLicense,
    //     'austraLianBusinessNumber': austraLianBusinessNumber,
    //     'australianCompanyNumber': australianCompanyNumber,
    //     'password': password,
    //     'confirmPassword': confirmPassword,
    //     'passport': passport,
    //     'securityLicense': securityLicense,
    //     'visaWorkingRights': visaWorkingRights,
    //     'abn': abn,
    //     'nationalCrimeCheck': nationalCrimeCheck,
    //     'whiteCard': whiteCard,
    //   }),
    // );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      debugPrint('Response in signUp: $jsonData');
      final userDataModel = UserDataModel.fromJson(jsonData);
      if (userDataModel.data != null) {
        final userId = userDataModel.data!.id;
        debugPrint('User ID: $userId');
        userController.setUser(userDataModel.data!);
        final getuserbyid = await getUserByID(userId!);
        debugPrint('get user by ID called $getuserbyid');
        if (getuserbyid.statusCode == 200) {
          final userData = GetUserById.fromJson(jsonDecode(getuserbyid.body)).data;
          if (userData != null) {
            Get.find<UserController>().setUser(userData);
          }
        }
      }
    } else {
      debugPrint('inside signup method call for company: ${response.statusCode}');
    }
    return response;
  }

  Future<http.Response> signUpForContractor({SignUpModelForIndividual}) async {
    var functionUrl = 'contractorAuth/signUp';
    final response = await http.post(Uri.parse(baseurl + functionUrl),
      headers: {
        'Content-Type': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      },
      // body: jsonEncode({
      //   'registeringAs': registeringAs,
      //   'email': email,
      //   'Name': Name,
      //   'phone': phone,
      //   'postalAddress': postalAddress,
      //   // 'masterSecurityLicense': masterLicense,
      //   'austraLianBusinessNumber': austraLianBusinessNumber,
      //   // 'australianCompanyNumber': australianCompanyNumber,
      //   'password': password,
      //   'confirmPassword': confirmPassword,
      //   // 'role': role,
      //   'dob' : dob,
      //   'gender' : gender,
      //   'passport': passport,
      //   'securityLicense': securityLicense,
      //   'visaWorkingRights': visaWorkingRights,
      //   'abn': abn,
      //   'nationalCrimeCheck': nationalCrimeCheck,
      //   'whiteCard': whiteCard,
      // }),
      body: jsonEncode(SignUpModelForIndividual.toJson() // Encode body as JSON string
      ),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      debugPrint('Response in signUp: $jsonData');
      final userDataModel = UserDataModel.fromJson(jsonData);
      if (userDataModel.data != null) {
        final userId = userDataModel.data!.id;
        debugPrint('User ID: $userId');
        userController.setUser(userDataModel.data!);
        final getuserbyid = await getUserByID(userId!);
        debugPrint('get user by ID called $getuserbyid');
        if (getuserbyid.statusCode == 200) {
          final userData = GetUserById.fromJson(jsonDecode(getuserbyid.body)).data;
          if (userData != null) {
            Get.find<UserController>().setUser(userData);
          }
        }
      }
    } else {
      debugPrint('inside signup method call for company: ${response.statusCode}');
    }
    return response;
  }

  Future<http.Response> login(String email, String password, String fcmToken) async {
    var functionUrl = 'contractorAuth/login';
    final response = await http.post(
      Uri.parse(baseurl + functionUrl),
      headers: {
        "Content-Type": "application/json",
        'ngrok-skip-browser-warning': 'true',
      },
      body: jsonEncode({ // Encode body as JSON string
        "email": email,
        "password": password,
        "fcmToken": fcmToken,
      }),
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      debugPrint('Response in login: $jsonData');
      final userDataModel = UserDataModel.fromJson(jsonData);

      if (userDataModel.data != null) {
        final userId = userDataModel.data!.id;
        debugPrint('User ID: $userId');
        // userController.setUser(userDataModel.data!);
        // final getuserbyid = await getUserByID(userId!);
        // debugPrint('get user by ID called $getuserbyid');
        // Get complete user data including image
        final getUserResponse = await getUserByID(userId!);
        if (getUserResponse.statusCode == 200) {
          final userData = GetUserById.fromJson(jsonDecode(getUserResponse.body)).data;
          if (userData != null) {
            Get.find<UserController>().setUser(userData);
          }
        }
      }
    } else {
      debugPrint('inside Login method call: ${response.statusCode}');
    }
    return response;
  }

  Future<http.Response> sendOtp(String email) async {
    var functionUrl = 'contractorAuth/forgot-password';
    final response = await http.post(
      Uri.parse(baseurl + functionUrl),
      headers: {
        "Content-Type": "application/json",
        'ngrok-skip-browser-warning': 'true',
      },
      body: jsonEncode({ // Encode body as JSON string
        "email": email,
      }),
    );
    return response;
  }

  Future<http.Response> verifyOtp(String email, String otp) async {
    var functionUrl = 'contractorAuth/verify-otp';
    final response = await http.post(
      Uri.parse(baseurl + functionUrl),
      headers: {
        "Content-Type": "application/json",
        'ngrok-skip-browser-warning': 'true',
      },
      body: jsonEncode({ // Encode body as JSON string
        "email": email,
        "otp": otp,
      }),
    );
    return response;
  }

  Future<http.Response> resetPassword(String email, String password, String confirmPassword) async {
    var functionUrl = 'contractorAuth/set-password-by-email';
    final response = await http.post(
      Uri.parse(baseurl + functionUrl),
      headers: {
        "Content-Type": "application/json",
        'ngrok-skip-browser-warning': 'true',
      },
      body: jsonEncode({ // Encode body as JSON string
        "email": email,
        "password": password,
        "confirmPassword": confirmPassword,
      }),
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final userDataModel = UserDataModel.fromJson(jsonData);

      if (userDataModel.data != null) {
        final userId = userDataModel.data!.id;
        debugPrint('User ID: $userId');
        userController.setUser(userDataModel.data!);
        final getuserbyid = await getUserByID(userId!);
        debugPrint('get user by ID called $getuserbyid');
      }
    } else {
      debugPrint('inside Reset Password method call: ${response.statusCode}');
    }
    return response;
  }

  Future<http.Response> logout(String userId) async {
    var functionUrl = 'auth/logOut/$userId';
    final response = await http.post(
      Uri.parse(baseurl + functionUrl),
      headers: {
        "Content-Type": "application/json",
        'ngrok-skip-browser-warning': 'true',
      },
    );
    return response;
  }

  Future<http.StreamedResponse> uploadFile(String userId, String fileType, String filePath) async {
    var functionUrl = 'contractorDocuments/upload';
    final request = http.MultipartRequest('POST',Uri.parse(baseurl + functionUrl))
      ..fields['userId'] = userId
      ..fields['type'] = fileType
      ..files.add(await http.MultipartFile.fromPath('file', filePath));

    request.headers.addAll({
      'ngrok-skip-browser-warning': 'true',
    });
    final response = await request.send();
    return response;
  }

  Future<http.Response> getUserByID(String userId) async {
    var functionUrl = 'contractors/$userId';
    final response = await http.get(Uri.parse(baseurl + functionUrl),
      headers: {
        "Content-Type": "application/json",
        'ngrok-skip-browser-warning': 'true',
      },
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final userData = GetUserById.fromJson(json).data;
      debugPrint('User data: $userData');

      if (userData != null) {
        Get.find<UserController>().setUser(userData);
        debugPrint('User loaded and stored in session');
      }
    } else {
      // handle error
    }
    return response;
  }

  static const String imageBaseUrl = 'http://148.66.158.113:3006/';

  static String? fullImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return null;
    return '$imageBaseUrl$imagePath';
  }

  Future<http.Response> addBankDetails(String bankName, String accountTitle, String accountNumber, String iban, String expiryDate, String userId) async {
    var functionUrl = 'contractorBankDetails';
    final response = await http.post(
      Uri.parse(baseurl + functionUrl),
      headers: {
        "Content-Type": "application/json",
        'ngrok-skip-browser-warning': 'true',
      },
      body: jsonEncode({
        "bankName": bankName,
        "accountTitle": accountTitle,
        "accountNumber": accountNumber,
        "IBAN": iban,
        "entityDate": expiryDate,
        "userId": userId,
      }),
    );
    return response;
  }

  Future<http.Response> getBankDetails(String userId) async {
    var functionUrl = 'userBankDetails/$userId';
    final response = await http.get(Uri.parse(baseurl + functionUrl),
      headers: {
        "Content-Type": "application/json",
        'ngrok-skip-browser-warning': 'true',
      },
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final userData = GetUserById.fromJson(json).data;
      debugPrint('User data: $userData');

      if (userData != null) {
        Get.find<UserController>().setUser(userData);
        debugPrint('User bank details loaded and stored in session');
      }
    } else {
      // handle error
    }
    return response;
  }

  Future<http.Response> getBankDetailsWithParams(Map<String, String> queryParams) async {
    var functionUrl = 'contractorBankDetails/';
    final uri = Uri.parse(baseurl+ functionUrl).replace(queryParameters: queryParams);

    final response = await http.get(
      uri,
      headers: {
        "Content-Type": "application/json",
        'ngrok-skip-browser-warning': 'true',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final dataList = json['data'];

    } else {
      debugPrint('Error: ${response.statusCode} - ${response.body}');
    }
    return response;
  }

  Future<http.Response> deleteBankDetails(String userId) async {
    var functionUrl = 'contractorBankDetails/$userId';
    final response = await http.delete(Uri.parse(baseurl + functionUrl),
      headers: {
        "Content-Type": "application/json",
        'ngrok-skip-browser-warning': 'true',
      },
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final userData = GetUserById.fromJson(json).data;
      debugPrint('User data: $userData');

      if (userData != null) {
        Get.find<UserController>().setUser(userData);
        debugPrint('User bank details loaded and stored in session');
      }
    } else {
      // handle error
    }
    return response;
  }

  Future<http.Response> addDispute(CreateDisputeModel createDisputeModel) async {
    var functionUrl = 'contractorDispute';

    final response = await http.post(
      Uri.parse(baseurl + functionUrl),
      headers: {
        "Content-Type": "application/json",
        'ngrok-skip-browser-warning': 'true',
      },
      body: jsonEncode(createDisputeModel.toJson()), // Encode body as JSON string
    );
    if (response.statusCode == 201) {
      final jsonData = jsonDecode(response.body);
      debugPrint('Dispute response: $jsonData');
    } else {
      debugPrint('inside dispute method call: ${response.statusCode}');
    }
    return response;
  }

  // Future<http.Response> updatePersonalInfo(
  //     String? userId,
  //     String? fullName,
  //     String? email,
  //     String? phone,
  //     String? postalAddress,
  //     String? masterSecurityLicense,
  //     String? password,
  //     String? role,
  //     String? dob,
  //     String? gender,
  //     String? fcmToken,
  //     String? appleId,
  //     int? yearsOfExperience,
  //     String? licenseNumber,
  //     String? abn,
  //     List<String>? preferredLocationAddresses,
  //     ) async {
  //   var functionUrl = 'users/$userId';
  //
  //   Map<String, dynamic> body = {};
  //
  //   if (fullName != null) body['fullName'] = fullName;
  //   if (email != null) body['email'] = email;
  //   if (phone != null) body['phone'] = phone;
  //   if (postalAddress != null) body['postalAddress'] = postalAddress;
  //   if (masterSecurityLicense != null) body['masterSecurityLicense'] = masterSecurityLicense;
  //   if (password != null) body['password'] = password;
  //   if (role != null) body['role'] = role;
  //   if (dob != null) body['dob'] = dob;
  //   if (gender != null) body['gender'] = gender;
  //   if (fcmToken != null) body['fcmToken'] = fcmToken;
  //   if (appleId != null) body['appleId'] = appleId;
  //
  //   Map<String, dynamic> personalDetails = {};
  //   if (yearsOfExperience != null) personalDetails['yearsOfExperience'] = yearsOfExperience;
  //   if (licenseNumber != null) personalDetails['licenseNumber'] = licenseNumber;
  //   if (abn != null) personalDetails['abn'] = abn;
  //   if (preferredLocationAddresses != null) personalDetails['preferredLocationAddresses'] = preferredLocationAddresses;
  //
  //   if (personalDetails.isNotEmpty) body['personalDetails'] = personalDetails;
  //
  //   final response = await http.patch(
  //     Uri.parse(baseurl + functionUrl),
  //     headers: {
  //       "Content-Type": "application/json",
  //       'ngrok-skip-browser-warning': 'true',
  //     },
  //     body: jsonEncode(body),
  //   );
  //
  //   if (response.statusCode == 200) {
  //     final json = jsonDecode(response.body);
  //     final userData = GetUserById.fromJson(json).data;
  //
  //     if (userData != null) {
  //       Get.find<UserController>().setUser(userData);
  //       debugPrint('User loaded and stored in session');
  //     }
  //   } else {
  //     debugPrint('Error updating user: ${response.statusCode}');
  //   }
  //
  //   return response;
  // }

  Future<http.Response> updatePersonalInfo(
      String userId, UserUpdateModel userModel) async {
    final functionUrl = 'contractors/$userId';
    final response = await http.put(
      Uri.parse(baseurl + functionUrl),
      headers: {
        "Content-Type": "application/json",
        'ngrok-skip-browser-warning': 'true',
      },
      body: jsonEncode(userModel.toJson()),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      // final userData = GetUserById.fromJson(json).data;
      // if (userData != null) {
      //   Get.find<UserController>().setUser(userData);
      //   debugPrint('User loaded and stored in session');
      // }
      debugPrint('Response in updatePersonalInfo: $json');
    } else {
      debugPrint('Error updating user: ${response.statusCode}');
    }

    return response;
  }

  Future<http.Response> deleteAccount(String userId) async {
    var functionUrl = 'users/$userId';
    final response = await http.delete(Uri.parse(baseurl + functionUrl),
      headers: {
        "Content-Type": "application/json",
        'ngrok-skip-browser-warning': 'true',
      },
    );
    if (response.statusCode == 200) {
      debugPrint('User account deleted successfully');
      }
    else {
      debugPrint('Error deleting user: ${response.statusCode}');
    }
    return response;
  }

  Future<http.Response> getAllLicense() async {
    var functionUrl = 'license/';
    final response = await http.get(Uri.parse(baseurl + functionUrl),
      headers: {
        "Content-Type": "application/json",
        'ngrok-skip-browser-warning': 'true',
      },
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      debugPrint('Response in getAllLicense: $json');

    } else {
      // handle error
    }
    return response;
  }

  Future<http.Response> postJobFeedback(
    String guardId,
    String jobId,
    int rating,
    String review,
) async {
  var functionUrl = 'jobFeedback/';
  final response = await http.post(
    Uri.parse(baseurl + functionUrl),
    headers: {
      "Content-Type": "application/json",
      'ngrok-skip-browser-warning': 'true',
    },
    body: jsonEncode({
      "guardId": guardId,
      "jobId": jobId,
      "rating": rating,
      "review": review,
    }),
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    debugPrint('Job feedback submitted successfully');
    final json = jsonDecode(response.body);
    debugPrint('Response in addJobFeedback: $json');
  } else {
    debugPrint('Error submitting job feedback: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');
  }

  return response;
}

  Future<http.Response> addSecurityLicense(String licenseNumber, String expiryDate, String licenseTypeId,
      String userId, String licenseDocumentPath) async {
    var functionUrl = 'userLicenses/';
    final response = await http.post(
      Uri.parse(baseurl + functionUrl),
      headers: {
        "Content-Type": "application/json",
        'ngrok-skip-browser-warning': 'true',
      },
      body: jsonEncode({
        "licenseNumber": licenseNumber,
        "expiryDate": expiryDate,
        "licenseTypeId": licenseTypeId,
        "userId": userId,
        "licenseDocumentPath": licenseDocumentPath,
      }),
    );
    if (response.statusCode == 201) {
      debugPrint('User security license added successfully');
      final json = jsonDecode(response.body);
      debugPrint('Response in addSecurityLicense: $json');
    }
    else {
      debugPrint('Error adding user security license: ${response.statusCode}');
    }
    return response;
  }

  Future<http.Response> getUserSecurityLicenses(String userId) async {
    var functionUrl = 'userLicenses/user/$userId';

    final response = await http.get(Uri.parse(baseurl + functionUrl),
      headers: {
        "Content-Type": "application/json",
        'ngrok-skip-browser-warning': 'true',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final dataList = json['data'];

    } else {
      debugPrint('Error: ${response.statusCode} - ${response.body}');
    }
    return response;
  }

  Future<NearbyJobsResponse?> fetchJobsLocations(String latitude, String longitude) async {
    var functionUrl = 'jobs/findNearBy';
    try {
      final response = await http.post(
        Uri.parse(baseurl + functionUrl),
        headers: {
          "Content-Type": "application/json",
          'ngrok-skip-browser-warning': 'true',
        },
        body: jsonEncode({
          "latitude": latitude,
          "longitude": longitude,
        }),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final jobsResponse = NearbyJobsResponse.fromJson(jsonData);
        return jobsResponse;
      } else {
        print('Failed to load jobs. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching jobs: $e');
      return null;
    }
  }

  Future<http.Response> getJobsList() async {
    var functionUrl = 'jobs';

    final response = await http.get(Uri.parse(baseurl + functionUrl),
      headers: {
        "Content-Type": "application/json",
        'ngrok-skip-browser-warning': 'true',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final dataList = json['data'];
      
    } else {
      debugPrint('Error: ${response.statusCode} - ${response.body}');
    }
    return response;
  }

  Future<http.Response> applyJob(String userId, String jobId, List<String?> shiftId) async {
    var functionUrl = 'jobApplication/apply';
    final response = await http.post(
      Uri.parse(baseurl + functionUrl),
      headers: {
        "Content-Type": "application/json",
        'ngrok-skip-browser-warning': 'true',
      },
      body: jsonEncode({
        "userId": userId,
        "jobId": jobId,
        "shiftId": shiftId,
      }),
    );
    if (response.statusCode == 201) {
      final jsonData = jsonDecode(response.body);
      debugPrint('Job application response: $jsonData');
    } else {
      debugPrint('inside job Apply method call: ${response.statusCode}');
    }
    return response;
  }

  Future<http.Response> getJobApplicationStatus(String userId, String jobId, List<String> shiftId) async {
    var functionUrl = 'jobApplication/apply';
    final response = await http.post(
      Uri.parse(baseurl + functionUrl),
      headers: {
        "Content-Type": "application/json",
        'ngrok-skip-browser-warning': 'true',
      },
      body: jsonEncode({
        "userId": userId,
        "jobId": jobId,
        "shiftId": shiftId,
      }),
    );
    if (response.statusCode == 201) {
      final jsonData = jsonDecode(response.body);
      debugPrint('Job application response: $jsonData');
    } else {
      debugPrint('inside job Apply method call: ${response.statusCode}');
    }
    return response;
  }

  

  Future<http.Response> addReportAnIssue(
      ReportAnIssueModel reportAnIssueModel,
      ) async {
    var functionUrl = 'contractorReportAnIssue/';

    // // Prepare the request body
    // final Map<String, dynamic> requestBody = {
    //   "subject": subject,
    //   "contractorId": userId,
    //   "issueDate": issueDate,
    //   "description": description,
    // };
    //
    // // Add supportDocuments only if provided
    // if (supportDocumentPath != null && supportDocumentPath.isNotEmpty) {
    //   requestBody["supportDocuments"] = [
    //     supportDocumentPath
    //   ];
    // }

    final response = await http.post(
      Uri.parse(baseurl + functionUrl),
      headers: {
        "Content-Type": "application/json",
        'ngrok-skip-browser-warning': 'true',
      },
      body: jsonEncode(reportAnIssueModel.toJson()), // Encode body as JSON string
    );

    if (response.statusCode == 201) {
      debugPrint('User report issue added successfully');
      final json = jsonDecode(response.body);
      debugPrint('Response in add report: $json');
    } else {
      debugPrint('Error adding user report issue: ${response.statusCode}');
    }

    return response;
  }

  Future<http.Response> getUserDocuments(String userId) async {
    var functionUrl = 'contractorDocuments/contractor/$userId';

    final response = await http.get(Uri.parse(baseurl + functionUrl),
      headers: {
        "Content-Type": "application/json",
        'ngrok-skip-browser-warning': 'true',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final dataList = json['data'];
      debugPrint('User documents: $dataList');
    } else {
      debugPrint('Error: ${response.statusCode} - ${response.body}');
    }
    return response;
  }

  Future<http.Response> getJobCategories(String userId) async {
    var functionUrl = 'jobCategory';

    final response = await http.get(Uri.parse(baseurl + functionUrl),
      headers: {
        "Content-Type": "application/json",
        'ngrok-skip-browser-warning': 'true',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
    } else {
      debugPrint('Error: ${response.statusCode} - ${response.body}');
    }
    return response;
  }

  Future<http.Response> getJobPremises(String userId) async {
    var functionUrl = 'jobPremises';

    final response = await http.get(Uri.parse(baseurl + functionUrl),
      headers: {
        "Content-Type": "application/json",
        'ngrok-skip-browser-warning': 'true',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
    } else {
      debugPrint('Error: ${response.statusCode} - ${response.body}');
    }
    return response;
  }

  Future<http.Response> createJob(CreateJobModel createJobModel) async {
    var functionUrl = 'jobs';
    final response = await http.post(
      Uri.parse(baseurl + functionUrl),
      headers: {
        "Content-Type": "application/json",
        'ngrok-skip-browser-warning': 'true',
      },
      body: jsonEncode(createJobModel.toJson()), // Encode body as JSON string
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint('job created successfully');
      final json = jsonDecode(response.body);
      debugPrint('Response in job created: $json');
    } else {
      debugPrint('inside job creating issue method call: ${response.body}');
      debugPrint('Error job creating issue: ${response.statusCode}');
    }

    return response;
  }

  Future<http.Response> getRequiredSkills() async {
    var functionUrl = 'requiredSkills/';
    final response = await http.get(Uri.parse(baseurl + functionUrl),
      headers: {
        "Content-Type": "application/json",
        'ngrok-skip-browser-warning': 'true',
      },
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      debugPrint('Response in getAllLicense: $json');

    } else {
      // handle error
    }
    return response;
  }

  Future<List<MyjobsModel>> getMyJobs(String contractorId) async {
    var functionUrl = 'jobs/';
    final uri = Uri.parse(baseurl + functionUrl).replace(queryParameters: {
      'contractorId': contractorId,
    });

    final response = await http.get(
      uri,
      headers: {
        "Content-Type": "application/json",
        'ngrok-skip-browser-warning': 'true',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List data = json is List ? json : json['data'];
      return data.map((e) => MyjobsModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load jobs');
    }
  }

  Future<List<JobApplicationModel>> getJobApplications(String contractorId) async {
    var functionUrl = 'jobApplication/applications/contractor/$contractorId';
    final uri = Uri.parse(baseurl + functionUrl);

    final response = await http.get(
      uri,
      headers: {
        "Content-Type": "application/json",
        'ngrok-skip-browser-warning': 'true',
      },
    );

    if (response.statusCode == 200) {
      // Decode with utf8 to handle any special characters
      final json = jsonDecode(response.body);
      debugPrint('Response in getJobApplications: $json');
      // Handle both direct list and wrapped in 'data'
      final List data = json is List ? json : json['data'];
      return data.map((e) => JobApplicationModel.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  Future<http.Response> updateJobStatus(String jobApplicationId, String userId, String jobId, String status) async {
    var functionUrl = 'jobApplication/$jobApplicationId/status';
    final response = await http.patch(
      Uri.parse(baseurl + functionUrl),
      headers: {
        "Content-Type": "application/json",
        'ngrok-skip-browser-warning': 'true',
      },
      body: jsonEncode({
        "userId": userId,
        "jobId": jobId,
        "status": status,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      debugPrint('Job status updated successfully');
      final json = jsonDecode(response.body);
    } else {
      debugPrint('Error updating job status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
    }

    return response;
  }

  Future<http.Response> getAllGuardsList() async {
    var functionUrl = 'users';

    final response = await http.get(Uri.parse(baseurl + functionUrl),
      headers: {
        "Content-Type": "application/json",
        'ngrok-skip-browser-warning': 'true',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final dataList = json['data'];
      debugPrint('Users list: $dataList');
    } else {
      debugPrint('Error: ${response.statusCode} - ${response.body}');
    }
    return response;
  }

  Future<http.Response> googleLogin(String token, String fcmToken) async {
    var functionUrl = 'contractorAuth/google-login';
    final response = await http.post(
      Uri.parse(baseurl + functionUrl),
      headers: {
        "Content-Type": "application/json",
        'ngrok-skip-browser-warning': 'true',
      },
      body: jsonEncode({
        "token": token,
        "fcmToken": fcmToken,
      }),
    );
    return response;
  }





// Future<http.Response> getData(String url, {String? controllerName}) async {
  //   String mainUrl =
  //       controllerName != null ? "$controllerBase/$controllerName/" : baseurl;
  //   var token = await getToken();
  //   debugPrint('Inside getData: Token:  $token');
  //   var response = await http.get(
  //     Uri.parse(mainUrl + url),
  //     headers: {
  //       "Accept": "application/json",
  //       "Content-Type": "application/json",
  //       "Authorization": "Bearer $token",
  //     },
  //   );
  //   debugPrint(mainUrl + url + token);
  //   debugPrint('Inside getData (api_service): ${response.body}');
  //   return response;
  // }

  // send data to api
  // Future<bool> sendData(int latitude, int longitude) async {
  //   try {
  //     var url = Uri.parse(
  //         'http://192.168.5.171/testammar/api/EmployeeData/?latitude=29&longitude=60');
  //     var client = http.Client();
  //     var response = await client.get(url);
  //     if (response.statusCode == 200) {
  //       var result = response.body == 'true' ? true : false;
  //       return result;
  //     } else {
  //       return false;
  //     }
  //   } catch (e) {
  //     throw Exception('Failed to load album');
  //   }
  // }

  ///useless:
  // Future<http.Response> verifyAgencyCode(String agencycode) async {
  //   var functionurl = 'gettenantname?agencycode=$agencycode';
  //   final response = await http.post(
  //     Uri.parse(baseurl + functionurl),
  //   );
  //   debugPrint(response.body);
  //   return response;
  // }

//esjbpk+8p@gmail.com
  /// Post data as a param:
  // Future<http.Response> postdata(String url, {String? controllerName}) async {
  //   String mainUrl =
  //       controllerName != null ? "$controllerBase/$controllerName/" : baseurl;
  //   var token = await getToken();
  //   debugPrint('Inside postdata: Token:  $token');
  //   debugPrint(mainUrl + url);
  //   final response = await http.post(
  //     Uri.parse(mainUrl + url),
  //     headers: {
  //       "Content-Type": "application/json",
  //       "Accept": "application/json",
  //       "Authorization": "Bearer $token",
  //     },
  //   );
  //   debugPrint(response.body);
  //   return response;
  // }

  /// Post JSON data:
  // Future<http.Response> postJsonData(
  //     {required String url,
  //     required String jsonString,
  //     String? controllerName}) async {
  //   String mainUrl =
  //       controllerName != null ? "$controllerBase/$controllerName/" : baseurl;
  //   var token = await getToken();
  //   debugPrint('Inside postdata: Token:  $token');
  //   debugPrint(mainUrl + url);
  //   final response = await http.post(
  //     Uri.parse(mainUrl + url),
  //     headers: {
  //       "Authorization": "Bearer $token",
  //     },
  //     body: jsonString,
  //   );
  //   debugPrint('Inside new post: ${response.body}');
  //   return response;
  // }

  // static Future<void> checkcookie() async {
  //   String cookie =
  //       'ENa5x1zJH1uleyV8TNYzSOXaXlDIPO0-ZkQhV5hvvudqGGfINE8uRUeJih3u4OIKn_MEi4EkPI5Xvne1KzBREvVpSLj23ocQhQ8Qb4NAcZJOpXuicwiu9FQal775txaKTHMV-yM5SSTjN3iYD7L43HzQ40Xo0c3dQmgsPVe-BKzDJuoVHC5DHP0LJdtQ-Mg7j2NpUKr8vAlINIUVOxp3r1HrUh7WC1a1aVxcsVGl1TSoCS3UlauCwiM5JaGnGsNDuVmKnq-KEEA6Cnf76qlxQQaLh5adbJlH8ceALhLLVmv0V-oZm7C-RZAgOrJk9I_Jm2Jeil7o5ELZPVxyzyhbReJHToXr2hKhLf0LNpK9TJsdjez8Z30mcG7L9yA0fbPyPqUzB7JhZ_Nq_OA3TZh7LHNaj-u0yHZxSgXMBbe6tFYXdQ7XHiUnUU8OURtQctziiCLyiAVQ-6hMeT6ehCEyc4rOfxPqCKvt_GY-O53L866EnYJ_GuQ_9QRcMkq5v9Rwp8cf9TvCzLaDje2wVnUbbA';
  //
  //   String token =
  //       'PZ_m8o-wZzB9-QhVdfOIQE5alY2BN6ZmaSFlkIPTVP1X4dR65kI3Qa9166_B6idxyyG5VtJGzMKVmTUPn0GJleV4oVFm2SbSCQpBI6pgxVg1';
  //   var response = await http.get(
  //     Uri.parse(
  //         'https://recruitzi.com/portal/Client/GetClientsList?searchText=a'),
  //     headers: {
  //       "Content-Type": "application/json",
  //       "Accept": "application/json",
  //       "set-Cookie": cookie,
  //       "Authorization": "Bearer $token",
  //     },
  //   );
  //
  //   var responsebody = response.body;
  //   debugPrint(responsebody);
  // }

  // Future<bool> checkTokenAuthorization(String token) async {
  //   var response = await http.get(
  //     Uri.parse('http://192.168.5.171/recruitzi/api/mobile/TestMethod'),
  //     headers: {
  //       "Content-Type": "application/json",
  //       "Accept": "application/json",
  //       "Authorization": "Bearer $token",
  //     },
  //   );
  //   if (response.statusCode == 200) {
  //     debugPrint(response.body);
  //     return true;
  //   }
  //   return false;
  // }

// Email Registration
//   Future<http.Response> registerEmail(
//       String email, String password, String agencycode) async {
//     var functionurl = 'register';
//     final response = await http.post(
//       Uri.parse(baseurl + functionurl),
//       encoding: Encoding.getByName('utf-8'),
//       body: {"email": email, "password": password, "agencycode": agencycode},
//     );
//     debugPrint(response.body);
//     return response;
//     //recruitzi_test5/users/activiationcode
//   }

  // Future<http.Response> pinCodeVerifcation(
  //     String email, String password, String activationCode) async {
  //   var functionurl = 'register/pincode';
  //   final response = await http.post(
  //     Uri.parse(baseurl + functionurl),
  //     encoding: Encoding.getByName('utf-8'),
  //     body: {
  //       "email": email,
  //       "password": password,
  //       "ActivationCode": activationCode
  //     },
  //   );
  //   return response;
  //   //recruitzi_test5/users/activiationcode
  // }

  // Future<http.Response> getRegisterationDataService() async {
  //   var token = await getToken();
  //   debugPrint('Inside getRegistrationDataService: Token:  $token');
  //   var functionurl = 'getregistrationdata';
  //   var response = await http.get(
  //     Uri.parse(baseurl + functionurl),
  //     headers: {
  //       "Content-Type": "application/json",
  //       "Accept": "application/json",
  //       "Authorization": "Bearer $token",
  //     },
  //   );
  //   debugPrint('Inside getRegistrationDataService ${response.body}');
  //   return response;
  // }

  ///Post: Upload file and fields:
  // Future<http.StreamedResponse?> uploadFileWithFields(
  //     Map<String, String> body, String url) async {
  //   String? filepath = body['File'];
  //   var token = await getToken();
  //
  //   ///Add fields:
  //   var request = http.MultipartRequest(
  //     'POST',
  //     Uri.parse(baseurl + url),
  //   )..fields.addAll(body);
  //
  //   ///Set header:
  //   Map<String, String> headers = {
  //     // "Content-Type":'application/x-www-form-urlencoded',
  //     "Authorization": "Bearer $token",
  //   };
  //
  //   ///Add header:
  //   request.headers.addAll(headers);
  //
  //   /// Add file:
  //   if (filepath != null && filepath != '') {
  //     debugPrint('File path: $filepath');
  //     request.files.add(
  //       await http.MultipartFile.fromPath(
  //         'File',
  //         filepath,
  //       ),
  //     );
  //   }
  //
  //   request.headers.addAll({
  //     'Content-Length': request.contentLength.toString(),
  //   });
  //
  //   debugPrint(baseurl + url);
  //
  //   /// Send request:
  //   var response = await request.send();
  //   if (response.statusCode == 200) {
  //     debugPrint('$response');
  //     // final Xml2Json xml2Json = Xml2Json();
  //     // var respStr = await response1.stream.bytesToString();
  //     // xml2Json.parse(respStr);
  //     // var jsonString = xml2Json.toParker();
  //     // // {"tut": {"id": "123", "author": "bezKoder", "title": "Programming Tut#123", "publish_date": "2020-3-16", "description": "Description for Tut#123"}}
  //
  //     // var json = jsonDecode(jsonString);
  //
  //     // (respStr);
  //     return response;
  //   }
  //   return null;
  // }

// Get Location
/* Disabled for now:
  Future<void> requestPermission(context, Function fn) async {
    const Permission locationPermission = Permission.location;
    bool ispermanetelydenied = await locationPermission.isPermanentlyDenied;
    if (ispermanetelydenied) {
      await openAppSettings();
    } else {
      var checkLocationStatus = await locationPermission.request();
      checkLocationStatus.isGranted;
    }
  }
*/

/*
Issue with filepath. Solve it:
  Future<http.StreamedResponse?> saveFormData(
      Map<String, String> body, String url) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(baseurl + url),
    )..fields.addAll(body);

    Map<String, String> headers = {
      "Authorization": "Bearer $getToken()",
    };
    if (filepath.toString().isNotEmpty) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          filepath!,
        ),
      );
    }
    request.headers.addAll(headers);
    var response1 = await request.send();
    if (response1.statusCode == 200) {
      // final Xml2Json xml2Json = Xml2Json();
      // var respStr = await response1.stream.bytesToString();
      // xml2Json.parse(respStr);
      // var jsonString = xml2Json.toParker();
      // // {"tut": {"id": "123", "author": "bezKoder", "title": "Programming Tut#123", "publish_date": "2020-3-16", "description": "Description for Tut#123"}}

      // var json = jsonDecode(jsonString);

      // (respStr);
      return response1;
    }
    return null;
  }

 */

  // Future<bool> save(String url, var json) async {
  //   final response = await http.post(
  //     Uri.parse(baseurl + url),
  //     headers: {
  //       "Content-Type": "application/json",
  //       'Accept': 'application/json',
  //       "Authorization": "Bearer $getToken()",
  //     },
  //     encoding: Encoding.getByName('utf-8'),
  //     body: jsonEncode(json),
  //   );
  //   debugPrint(response.body);
  //   if (response.statusCode == 200) {
  //     return true;
  //   }
  //   return false;
  // }

  // Future<bool> saveIdentificationfiles(
  //     List<IdentitficationProvider> filelist, String token, String url) async {
  //   var request = http.MultipartRequest(
  //     'POST',
  //     Uri.parse(baseurl + url),
  //   );
  //
  //   Map<String, String> headers = {
  //     "Authorization": "Bearer $token",
  //   };
  //   if (filelist.isNotEmpty) {
  //     for (var item in filelist) {
  //       if (item.filepath.isNotEmpty) {
  //         request.files.add(
  //           await http.MultipartFile.fromPath(
  //             item.label,
  //             item.filepath,
  //           ),
  //         );
  //       }
  //     }
  //   }
  //   request.headers.addAll(headers);
  //   var response = await request.send();
  //   if (response.statusCode == 200) {
  //     debugPrint("Files Save");
  //     return true;
  //   }
  //   return false;
  // }

/* Disabled for now:
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
  */


  //  Future<List<ContractorNotification>> fetchNotifications(String contractorId) async {
  //   var functionUrl = 'notification/contractors/$contractorId';

  //   final response = await http.get(Uri.parse(baseurl + functionUrl),
  //     headers: {
  //       "Content-Type": "application/json",
  //       'ngrok-skip-browser-warning': 'true',
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     final jsonData = jsonDecode(response.body);
    
  //     final List<dynamic> dataList = jsonData['data'];
  //     return dataList.map((item) => ContractorNotification.fromJson(item)).toList();
  //   } else {
  //     throw Exception('Failed to load notifications');
  //   }
  // }

 Future<List<ContractorNotification>> fetchNotifications(String contractorId) async {
    final uri = Uri.parse("${baseurl}notification/contractor/$contractorId");

    final response = await http.get(
      uri,
      headers: {
        "Content-Type": "application/json",
        "ngrok-skip-browser-warning": "true",
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List<dynamic> dataList = jsonData['data'];
      return dataList.map((item) => ContractorNotification.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load notifications');
    }
  }


}

