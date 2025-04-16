import 'package:get/get.dart';
import '../models/userdata_model.dart';

class UserController extends GetxController {
  Rxn<Data> userData = Rxn<Data>();

  void setUser(Data data) {
    userData.value = data;
  }

  void clearUser() {
    userData.value = null;
  }

  bool get isLoggedIn => userData.value != null;

}
