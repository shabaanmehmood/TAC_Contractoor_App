// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// //import '../../presenation/screens/personal_info.dart';
// import '../../provider/code_verfication_provider.dart';
// import '../../provider/identification_provider.dart';
// import '../../provider/work_history_provider.dart';
// import '../../recruitzi_view_models/user_viewmodel.dart';
// import '../models/add_skill_model.dart';
// import '../models/fields_model.dart';
// import '../models/user_registeration_data.dart';
// import '../repositories/user_repo.dart';
//
// mixin userRegisterationTabs {
//   var viewmodel = UserViewModel(repo: UserRepository());
//   var registerationFeildsModel = RegisterationFields();
//   var personalInfoFieldsList = <RegisterationFields>[];
//   var addressInfoFieldsList = <RegisterationFields>[];
//   var skillInfoFieldsList = <RegisterationFields>[];
//   var workhistoryInfoFieldsList = <RegisterationFields>[];
//   var identificationInfoFieldsList = <RegisterationFields>[];
//   var registerationFieldsModelList = <RegisterationFields>[];
//   RegisterationFields getFieldsInformation(ScreenField item) {
//     var fieldsmodel = RegisterationFields();
//     fieldsmodel.name = item.name;
//     fieldsmodel.iD = item.id;
//     fieldsmodel.defaultValue = item.defaultValue;
//     fieldsmodel.isActive = item.isActive;
//     fieldsmodel.isRequire = item.isRequire;
//     fieldsmodel.screenID = item.screenType;
//     fieldsmodel.tenantID = item.tenantId;
//     fieldsmodel.orderIndex = item.orderIndex;
//     fieldsmodel.isVisible = item.isVisible;
//     return fieldsmodel;
//   }
//
//
//   void getdata(context) async {
//     var model = await viewmodel.getData();
//     var codeVerifiedProvider =
//         Provider.of<CodeVerified>(context, listen: false);
//     var addSkillProvider = Provider.of<AddSkill>(context, listen: false);
//     var workhistoryprovider =
//         Provider.of<WorkHistoryProvider>(context, listen: false);
//     var identificationprovider =
//         Provider.of<IdentitficationProvider>(context, listen: false);
//     addSkillProvider.addNewSkilList.clear();
//     personalInfoFieldsList.clear();
//     addressInfoFieldsList.clear();
//     skillInfoFieldsList.clear();
//     workhistoryInfoFieldsList.clear();
//     identificationInfoFieldsList.clear();
//     workhistoryprovider.workHistoryProviderList.clear();
//     identificationprovider.identificationFileList.clear();
//     codeVerifiedProvider.profilePictureurl = '';
//
//     if (model != null) {
//       codeVerifiedProvider.firstName = model.personalInfo.firstName;
//       codeVerifiedProvider.lastName = model.personalInfo.lastName;
//       codeVerifiedProvider.cellPhone = model.personalInfo.cellNo;
//       codeVerifiedProvider.dateofBirth = model.personalInfo.dob;
//       codeVerifiedProvider.ssn = model.personalInfo.ssn;
//       codeVerifiedProvider.address1 = model.address.address1;
//       codeVerifiedProvider.address2 = model.address.address2;
//       codeVerifiedProvider.zip = model.address.zipCode;
//       codeVerifiedProvider.city = model.address.city;
//       codeVerifiedProvider.state = model.address.state;
//
//       if (model.skillData.isNotEmpty) {
//         for (var item in model.skillData) {
//           var addskillModel = AddSkill();
//            //var mymodel = SkillData.fromjson(item);
//           addskillModel.id = item.id;
//           addskillModel.experience = item.experience.toString();
//           addskillModel.skill = item.name.toString();
//           addSkillProvider.addnewSkill(addskillModel);
//         }
//       }
//       if (model.workHistoryData.isNotEmpty) {
//         for (var item in model.workHistoryData) {
//           var mymodel = WorkHistoryProvider();
//           mymodel.companyName = item.companyName;
//           mymodel.companyAddress = item.companyAddress;
//           mymodel.phoneNumber = item.companyPhone;
//           mymodel.startDate = item.startDate;
//           mymodel.endDate = item.endDate;
//           mymodel.zip = item.zip;
//           mymodel.jobTitle = item.jobTitle;
//           mymodel.superVisorName = item.supervisorName;
//           mymodel.salary = item.salary.toString();
//           mymodel.reasonForLeaving = item.reasonForLeaving;
//           workhistoryprovider.addWorkHistoryModel(mymodel);
//         }
//       }
//       if (model.screenFields.isNotEmpty) {
//         for (var item in model.screenFields) {
//           if (item.screenType == 1) {
//             var personalInfo = RegisterationFields();
//             personalInfo = getFieldsInformation(item);
//             personalInfoFieldsList.add(personalInfo);
//           }
//           if (item.screenType == 2) {
//             var addressfields = RegisterationFields();
//             addressfields = getFieldsInformation(item);
//             addressInfoFieldsList.add(addressfields);
//           }
//           if (item.screenType == 3) {
//             var skillfields = RegisterationFields();
//             skillfields = getFieldsInformation(item);
//             skillInfoFieldsList.add(skillfields);
//           }
//           if (item.screenType == 4) {
//             var workHistoryfields = RegisterationFields();
//             workHistoryfields = getFieldsInformation(item);
//             workhistoryInfoFieldsList.add(workHistoryfields);
//           }
//           if (item.screenType == 5) {
//             var identificationfieldlist = RegisterationFields();
//             identificationfieldlist = getFieldsInformation(item);
//             identificationInfoFieldsList.add(identificationfieldlist);
//           }
//         }
//       }
//
//       /*
//      Uncomment it and  Navigate to PersonalInfoTabs:
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) {
//             return PersonalInfoTabs(
//               tabindex: 0,
//               model: model,
//               personalinfofields: personalInfoFieldsList,
//               addressfiels: addressInfoFieldsList,
//               skillfiels: skillInfoFieldsList,
//               workhistoryfields: workhistoryInfoFieldsList,
//               identificationfields: identificationInfoFieldsList,
//             );
//           },
//         ),
//       );
//       */
//     }
//   }
//
// }
