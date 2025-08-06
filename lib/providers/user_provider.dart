import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:planner/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  User? _currentUser;
  User? get currentUser => _currentUser;
  set currentUser(User? user) {
    _currentUser = user;
    notifyListeners();
  }

  Future<void> signUp(String email, String password, String username) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyCwA05SgEDJ2SRgFiehPZzAC4sm7w2x_eM';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
          'displayName': username,
        }),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode != 200) {
        String errorMessage = 'Authentication failed';
        if (responseData['error'] != null) {
          switch (responseData['error']['message']) {
            case 'EMAIL_EXISTS':
              errorMessage = 'This email is already in use';
              break;
            case 'INVALID_EMAIL':
              errorMessage = 'This is not a valid email address';
              break;
            case 'WEAK_PASSWORD':
              errorMessage = 'Password is too weak';
              break;
            default:
              errorMessage =
                  'Signup failed: ${responseData['error']['message']}';
          }
        }
        throw Exception(errorMessage);
      }

      _currentUser = User(
        id: responseData['localId'],
        email: email,
        password: password,
        username: username,
        token: responseData['idToken'],
      );

      // Save user data for auto-login
      await _saveUserData();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signIn(String email, String password) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyCwA05SgEDJ2SRgFiehPZzAC4sm7w2x_eM';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode != 200) {
        String errorMessage = 'Authentication failed';
        if (responseData['error'] != null) {
          switch (responseData['error']['message']) {
            case 'EMAIL_NOT_FOUND':
              errorMessage = 'Email not found';
              break;
            case 'INVALID_PASSWORD':
              errorMessage = 'Invalid password';
              break;
            case 'INVALID_EMAIL':
              errorMessage = 'Invalid email format';
              break;
            case 'USER_DISABLED':
              errorMessage = 'User has been disabled';
              break;
            default:
              errorMessage =
                  'Login failed: ${responseData['error']['message']}';
          }
        }
        throw Exception(errorMessage);
      }

      // Fetch user profile to get username
      String? username;
      try {
        final userInfoResponse = await http.post(
          Uri.parse(
            'https://identitytoolkit.googleapis.com/v1/accounts:lookup?key=AIzaSyCwA05SgEDJ2SRgFiehPZzAC4sm7w2x_eM',
          ),
          body: json.encode({'idToken': responseData['idToken']}),
        );

        final userInfoData = json.decode(userInfoResponse.body);
        if (userInfoResponse.statusCode == 200 &&
            userInfoData['users'] != null &&
            userInfoData['users'].length > 0) {
          username = userInfoData['users'][0]['displayName'];
        }
      } catch (e) {
        print('Error fetching user profile: $e');
        // Continue anyway, username is optional
      }

      _currentUser = User(
        id: responseData['localId'],
        email: email,
        password: password,
        username: username,
        token: responseData['idToken'],
      );

      // Save user data for auto-login
      await _saveUserData();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    _currentUser = null;

    // Clear saved user data
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userToken');
    await prefs.remove('userId');
    await prefs.remove('userEmail');
    await prefs.remove('userPassword');
    await prefs.remove('username');

    notifyListeners();
  }

  // Save user data to SharedPreferences for auto-login
  Future<void> _saveUserData() async {
    if (_currentUser != null && _currentUser!.id != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userToken', _currentUser!.token!);
      await prefs.setString('userId', _currentUser!.id!);
      await prefs.setString('userEmail', _currentUser!.email);
      await prefs.setString('userPassword', _currentUser!.password);
      if (_currentUser!.username != null) {
        await prefs.setString('username', _currentUser!.username!);
      }
    }
  }

  Future<void> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken');
    final userId = prefs.getString('userId');
    final email = prefs.getString('userEmail');
    final password = prefs.getString('userPassword');
    final username = prefs.getString('username');

    if (token != null && userId != null && email != null && password != null) {
      _currentUser = User(
        id: userId,
        email: email,
        password: password,
        username: username,
        token: token,
      );
    }
    notifyListeners();
  }

  // Update user profile (username and email)
  Future<void> updateProfile({required String username, required String email}) async {
    if (_currentUser == null) {
      throw Exception('No user logged in');
    }

    try {
      // Update Firebase display name
      final updateProfileUrl = 
          'https://identitytoolkit.googleapis.com/v1/accounts:update?key=AIzaSyCwA05SgEDJ2SRgFiehPZzAC4sm7w2x_eM';
      
      final response = await http.post(
        Uri.parse(updateProfileUrl),
        body: json.encode({
          'idToken': _currentUser!.token,
          'displayName': username,
          'email': email,
          'returnSecureToken': true,
        }),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode != 200) {
        String errorMessage = 'Profile update failed';
        if (responseData['error'] != null) {
          switch (responseData['error']['message']) {
            case 'EMAIL_EXISTS':
              errorMessage = 'This email is already in use';
              break;
            case 'INVALID_EMAIL':
              errorMessage = 'Invalid email address';
              break;
            default:
              errorMessage = 'Update failed: ${responseData['error']['message']}';
          }
        }
        throw Exception(errorMessage);
      }

      // Update local user data
      _currentUser = User(
        id: _currentUser!.id,
        email: email,
        password: _currentUser!.password,
        username: username,
        token: responseData['idToken'] ?? _currentUser!.token,
        createdAt: _currentUser!.createdAt,
      );

      // Save updated data
      await _saveUserData();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  // Change user password
  Future<void> changePassword({required String currentPassword, required String newPassword}) async {
    if (_currentUser == null) {
      throw Exception('No user logged in');
    }

    try {
      // First verify current password by signing in
      final signInUrl = 
          'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyCwA05SgEDJ2SRgFiehPZzAC4sm7w2x_eM';
      
      final verifyResponse = await http.post(
        Uri.parse(signInUrl),
        body: json.encode({
          'email': _currentUser!.email,
          'password': currentPassword,
          'returnSecureToken': true,
        }),
      );

      if (verifyResponse.statusCode != 200) {
        throw Exception('Current password is incorrect');
      }

      // Change password
      final changePasswordUrl = 
          'https://identitytoolkit.googleapis.com/v1/accounts:update?key=AIzaSyCwA05SgEDJ2SRgFiehPZzAC4sm7w2x_eM';
      
      final response = await http.post(
        Uri.parse(changePasswordUrl),
        body: json.encode({
          'idToken': _currentUser!.token,
          'password': newPassword,
          'returnSecureToken': true,
        }),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode != 200) {
        String errorMessage = 'Password change failed';
        if (responseData['error'] != null) {
          switch (responseData['error']['message']) {
            case 'WEAK_PASSWORD':
              errorMessage = 'Password is too weak';
              break;
            default:
              errorMessage = 'Password change failed: ${responseData['error']['message']}';
          }
        }
        throw Exception(errorMessage);
      }

      // Update local user data
      _currentUser = User(
        id: _currentUser!.id,
        email: _currentUser!.email,
        password: newPassword,
        username: _currentUser!.username,
        token: responseData['idToken'] ?? _currentUser!.token,
        createdAt: _currentUser!.createdAt,
      );

      // Save updated data
      await _saveUserData();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  // Change user email
  Future<void> changeEmail({required String newEmail, required String currentPassword}) async {
    if (_currentUser == null) {
      throw Exception('No user logged in');
    }

    try {
      // First verify current password by signing in
      final signInUrl = 
          'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyCwA05SgEDJ2SRgFiehPZzAC4sm7w2x_eM';
      
      final verifyResponse = await http.post(
        Uri.parse(signInUrl),
        body: json.encode({
          'email': _currentUser!.email,
          'password': currentPassword,
          'returnSecureToken': true,
        }),
      );

      if (verifyResponse.statusCode != 200) {
        throw Exception('Current password is incorrect');
      }

      // Change email
      final changeEmailUrl = 
          'https://identitytoolkit.googleapis.com/v1/accounts:update?key=AIzaSyCwA05SgEDJ2SRgFiehPZzAC4sm7w2x_eM';
      
      final response = await http.post(
        Uri.parse(changeEmailUrl),
        body: json.encode({
          'idToken': _currentUser!.token,
          'email': newEmail,
          'returnSecureToken': true,
        }),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode != 200) {
        String errorMessage = 'Email change failed';
        if (responseData['error'] != null) {
          switch (responseData['error']['message']) {
            case 'EMAIL_EXISTS':
              errorMessage = 'This email is already in use';
              break;
            case 'INVALID_EMAIL':
              errorMessage = 'Invalid email address';
              break;
            default:
              errorMessage = 'Email change failed: ${responseData['error']['message']}';
          }
        }
        throw Exception(errorMessage);
      }

      // Update local user data
      _currentUser = User(
        id: _currentUser!.id,
        email: newEmail,
        password: _currentUser!.password,
        username: _currentUser!.username,
        token: responseData['idToken'] ?? _currentUser!.token,
        createdAt: _currentUser!.createdAt,
      );

      // Save updated data
      await _saveUserData();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
