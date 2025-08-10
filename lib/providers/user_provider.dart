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
        refreshToken: responseData['refreshToken'], // <-- Add this line
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
        refreshToken: responseData['refreshToken'], // Store refresh token
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
    await prefs.remove('userRefreshToken'); // Add this line

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
      // Save refresh token
      if (_currentUser!.refreshToken != null) {
        await prefs.setString('userRefreshToken', _currentUser!.refreshToken!);
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
    final refreshToken = prefs.getString('userRefreshToken'); // <-- Add this line

    if (token != null && userId != null && email != null && password != null) {
      _currentUser = User(
        id: userId,
        email: email,
        password: password,
        username: username,
        token: token,
        refreshToken: refreshToken, // <-- Add this line
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
        refreshToken: responseData['refreshToken'] ?? _currentUser!.refreshToken, // <-- Add this line
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
        refreshToken: responseData['refreshToken'] ?? _currentUser!.refreshToken, // <-- Add this line
        createdAt: _currentUser!.createdAt,
      );

      // Save updated data
      await _saveUserData();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> refreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('userRefreshToken');
    
    if (refreshToken == null || _currentUser == null) {
      return false;
    }
    
    final url = 'https://securetoken.googleapis.com/v1/token?key=AIzaSyCwA05SgEDJ2SRgFiehPZzAC4sm7w2x_eM';
    
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'grant_type': 'refresh_token',
          'refresh_token': refreshToken,
        }),
      );
      
      final responseData = json.decode(response.body);
      
      if (response.statusCode != 200) {
        // If refresh token is invalid, force logout
        if (responseData['error'] != null && 
            (responseData['error']['message'] == 'TOKEN_EXPIRED' || 
            responseData['error']['message'] == 'INVALID_REFRESH_TOKEN')) {
          await signOut();
        }
        return false;
      }
      
      // Update user with new token
      _currentUser = User(
        id: _currentUser!.id,
        email: _currentUser!.email,
        password: _currentUser!.password,
        username: _currentUser!.username,
        token: responseData['id_token'],
        refreshToken: responseData['refresh_token'],
        createdAt: _currentUser!.createdAt,
      );
      
      // Save updated tokens
      await prefs.setString('userToken', responseData['id_token']);
      await prefs.setString('userRefreshToken', responseData['refresh_token']);
      
      print('New token: ${responseData['id_token']}'); // Print token
      
      notifyListeners();
      return true;
    } catch (error) {
      print('Token refresh failed: $error');
      return false;
    }
  }

  Future<String?> getValidToken() async {
    if (_currentUser == null || _currentUser!.token == null) {
      return null;
    }
    
    // For simplicity, we'll refresh the token before every API call
    // In production, you might want to check if the token is actually close to expiring
    final refreshed = await refreshToken();
    if (refreshed) {
      return _currentUser!.token;
    }
    
    // If refresh failed but we still have a token, return it
    // (it might still be valid)
    return _currentUser!.token;
  }

  // Example of using the valid token in an API call
  Future<void> fetchUserData() async {
    final token = await getValidToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }
    
    final response = await http.get(
      Uri.parse('https://your-api-endpoint.com'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch user data');
    }
    
    // Process response...
  }
}
