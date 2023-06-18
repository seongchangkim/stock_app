import 'package:get/get_state_manager/get_state_manager.dart';

class UserStore extends GetxController {
  // 회원 정보
  final _user = {};
  // 로그인 여부
  bool _isAuth = false;

  dynamic get user => _user;
  bool get isAuth => _isAuth;

  void setUserInfo(dynamic user) {
    _user.addAll(user);
    update();
  }

  void loginCheck(bool check) {
    _isAuth = check;
    update();
  }
}
