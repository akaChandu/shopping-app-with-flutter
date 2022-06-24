import 'dart:convert';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/http_execption.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryTokenDate;
  String? _userId;
  Timer? _authTimer;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryTokenDate != null &&
        _expiryTokenDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String? get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlType) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/$urlType?key=AIzaSyBGx-sXYKq7FvPObzSs6ylfg4Lcot_RJ9Q';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpExecption(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryTokenDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryTokenDate?.toIso8601String(),
      });
      prefs.setString('userData', userData);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'accounts:signUp');
    // const url =
    //     'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyBGx-sXYKq7FvPObzSs6ylfg4Lcot_RJ9Q';
    // final response = await http.post(
    //   Uri.parse(url),
    //   body: json.encode(
    //     {
    //       'email': email,
    //       'password': password,
    //       'returnSecureToken': true, 
    //     },
    //   ),
    // );
    // print(json.decode(response.body));
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'accounts:signInWithPassword');
    // const url =
    //     'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyBGx-sXYKq7FvPObzSs6ylfg4Lcot_RJ9Q';
    // final response = await http.post(
    //   Uri.parse(url),
    //   body: json.encode(
    //     {
    //       'email': email,
    //       'password': password,
    //       'returnSecureToken': true,
    //     },
    //   ),
    // );
    // print(json.decode(response.body));
  }

  Future<bool> autoLogIn() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData = json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryTokenDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logOut() async {
    _token = null;
    _userId = null;
    _expiryTokenDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('userData');
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryTokenDate?.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry!), logOut);
  }
}
