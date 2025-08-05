import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:planner/models/user.dart';

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
              errorMessage = 'Signup failed: ${responseData['error']['message']}';
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
              errorMessage = 'Login failed: ${responseData['error']['message']}';
          }
        }
        throw Exception(errorMessage);
      }
      
      // Fetch user profile to get username
      String? username;
      try {
        final userInfoResponse = await http.post(
          Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:lookup?key=AIzaSyCwA05SgEDJ2SRgFiehPZzAC4sm7w2x_eM'),
          body: json.encode({
            'idToken': responseData['idToken'],
          }),
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
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
