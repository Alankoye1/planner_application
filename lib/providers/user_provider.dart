import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:planner/models/user.dart';
import 'package:planner/config/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  User? _currentUser;
  User? get currentUser => _currentUser;
  set currentUser(User? user) {
    _currentUser = user;
    notifyListeners();
  }

  // Sign Up with Email and Password
  Future<void> signUp(String email, String password, String username) async {
    final url = AppConfig.signUpUrl;
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

  // Sign In with Email and Password
  Future<void> signIn(String email, String password) async {
    final url = AppConfig.signInUrl;
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
          Uri.parse(AppConfig.lookupUrl),
          body: json.encode({'idToken': responseData['idToken']}),
        );

        final userInfoData = json.decode(userInfoResponse.body);
        if (userInfoResponse.statusCode == 200 &&
            userInfoData['users'] != null &&
            userInfoData['users'].length > 0) {
          username = userInfoData['users'][0]['displayName'];
        }
      } catch (e) {
        throw Exception('Error fetching user profile: $e');
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

  // Sign out user and clear saved data
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
      if (_currentUser!.profileBio != null) {
        await prefs.setString('userProfileBio', _currentUser!.profileBio!);
      }
      // Note: Profile image is saved separately as base64 in change methods
      // Save refresh token
      if (_currentUser!.refreshToken != null) {
        await prefs.setString('userRefreshToken', _currentUser!.refreshToken!);
      }
    }
  }

  // Save file to local storage and store its path in SharedPreferences
  static Future<File?> saveFile(File file) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final bytes = await file.readAsBytes();
      final base64String = base64Encode(bytes);
      await prefs.setString('userProfileImage', base64String);
      return file;
    } catch (e) {
      print('Error saving image file: $e');
      throw Exception('Failed to save profile image. Please try again.');
    }
  }

  // Retrieve File from SharedPreferences
  static Future<File?> loadFile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final base64String = prefs.getString('userProfileImage');
      if (base64String != null) {
        final bytes = base64Decode(base64String);
        final file = File('${Directory.systemTemp.path}/profile_image.png');
        await file.writeAsBytes(bytes);
        return file;
      }
    } catch (e) {
      print('Error loading image file: $e');
    }
    return null; // file not found
  }

  // Auto-login user if valid token exists
  Future<void> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken');
    final userId = prefs.getString('userId');
    final email = prefs.getString('userEmail');
    final password = prefs.getString('userPassword');
    final username = prefs.getString('username');
    final refreshToken = prefs.getString('userRefreshToken');
    final profileBio = prefs.getString('userProfileBio');
    final profileImage = await loadFile();

    if (token != null && userId != null && email != null) {
      _currentUser = User(
        id: userId,
        email: email,
        password: password ?? '',
        username: username,
        token: token,
        refreshToken: refreshToken,
        profileBio: profileBio,
        profileImage: profileImage,
      );

      // Determine authentication type and refresh accordingly
      if (password != null && password.isNotEmpty) {
        // Email/password account - use regular refresh token
        if (refreshToken != null) {
          await this.refreshToken();
        }
      } else {
        // Social login account (Google/Facebook) - use Google refresh if available
        if (email.isNotEmpty) {
          await refreshTokenGoogle();
        }
      }
    }
    notifyListeners();
  }

  // Update user profile (username and email)
  Future<void> updateProfile({
    required String username,
    required String email,
  }) async {
    if (_currentUser == null) {
      throw Exception('No user logged in');
    }

    try {
      // Update Firebase display name
      final updateProfileUrl = AppConfig.updateAccountUrl;

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
              errorMessage =
                  'Update failed: ${responseData['error']['message']}';
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
        refreshToken:
            responseData['refreshToken'] ??
            _currentUser!.refreshToken, // <-- Add this line
        createdAt: _currentUser!.createdAt,
      );

      // Save updated data
      await _saveUserData();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  // Change user Image with source selection
  Future<void> changeUserImage({ImageSource? source}) async {
    if (_currentUser == null) {
      throw Exception('No user logged in');
    }

    try {
      final ImagePicker picker = ImagePicker();

      // If no source specified, default to gallery
      final imageSource = source ?? ImageSource.gallery;

      final XFile? pickedImage = await picker.pickImage(
        source: imageSource,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedImage == null) {
        // User cancelled image selection
        print('Image selection cancelled by user');
        return;
      }

      // Convert XFile to File
      final File imageFile = File(pickedImage.path);

      // Read image as bytes
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      // Store image data in SharedPreferences for persistence
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userProfileImage', base64Image);

      // Update local user data (profileImage stays null, we use SharedPreferences)
      _currentUser = User(
        id: _currentUser!.id,
        email: _currentUser!.email,
        password: _currentUser!.password,
        username: _currentUser!.username,
        token: _currentUser!.token,
        refreshToken: _currentUser!.refreshToken,
        createdAt: _currentUser!.createdAt,
        profileImage: imageFile, // Store the File image in memory too
        profileBio: _currentUser!.profileBio,
      );

      // Save updated data
      await _saveUserData();
      notifyListeners();

    } catch (error) {
      print('Error changing user image: $error');

      // Handle specific image picker errors
      if (error.toString().contains('camera_access_denied')) {
        throw Exception(
          'Camera access denied. Please enable camera permissions in settings.',
        );
      } else if (error.toString().contains('photo_access_denied')) {
        throw Exception(
          'Photo access denied. Please enable photo library permissions in settings.',
        );
      } else if (error.toString().contains('file_not_found')) {
        throw Exception('Selected image file not found.');
      } else {
        throw Exception('Failed to update profile image. Please try again.');
      }
    }
  }

  // Convenience method for gallery selection
  Future<void> changeUserImageFromGallery() async {
    await changeUserImage(source: ImageSource.gallery);
  }

  // Helper method to get profile image from SharedPreferences
  Future<String?> getProfileImageBase64() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userProfileImage');
  }

  // Helper method to get profile image widget from base64 data
  Widget? getProfileImageWidget({double? width, double? height, BoxFit? fit}) {
    // First check if current user has profileImage in memory
    if (_currentUser?.profileImage != null) {
      try {
        if (_currentUser!.profileImage is File) {
          // If profileImage is a File, use it directly
          return Image.file(
            _currentUser!.profileImage as File,
            width: width,
            height: height,
            fit: fit ?? BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              print('Error loading profile image: $error');
              return Icon(Icons.person, size: width ?? height ?? 50);
            },
          );
        } else if (_currentUser!.profileImage is XFile) {
          // If profileImage is an XFile, convert to File
          final file = File((_currentUser!.profileImage as XFile).path);
          return Image.file(
            file,
            width: width,
            height: height,
            fit: fit ?? BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              print('Error loading profile image: $error');
              return Icon(Icons.person, size: width ?? height ?? 50);
            },
          );
        } else if (_currentUser!.profileImage is String &&
            (_currentUser!.profileImage as String).isNotEmpty) {
          // If profileImage is a String (base64), decode it
          final bytes = base64Decode(_currentUser!.profileImage as String);
          return Image.memory(
            bytes,
            width: width,
            height: height,
            fit: fit ?? BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              print('Error loading profile image: $error');
              return Icon(Icons.person, size: width ?? height ?? 50);
            },
          );
        }
      } catch (e) {
        print('Error handling profile image: $e');
        return Icon(Icons.person, size: width ?? height ?? 50);
      }
    }
    
    // Fallback: try to load from SharedPreferences
    return FutureBuilder<String?>(
      future: getProfileImageBase64(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
          try {
            final bytes = base64Decode(snapshot.data!);
            return Image.memory(
              bytes,
              width: width,
              height: height,
              fit: fit ?? BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                print('Error loading profile image from base64: $error');
                return Icon(Icons.person, size: width ?? height ?? 50);
              },
            );
          } catch (e) {
            print('Error decoding base64 image: $e');
            return Icon(Icons.person, size: width ?? height ?? 50);
          }
        }
        return Icon(Icons.person, size: width ?? height ?? 50);
      },
    );
  }

  Future<bool> hasProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('userProfileImage');
  }

  // Helper method to remove profile image
  Future<void> removeProfileImage() async {
    if (_currentUser == null) {
      throw Exception('No user logged in');
    }

    try {
      // Update user data to remove profile image
      _currentUser = User(
        id: _currentUser!.id,
        email: _currentUser!.email,
        password: _currentUser!.password,
        username: _currentUser!.username,
        token: _currentUser!.token,
        refreshToken: _currentUser!.refreshToken,
        createdAt: _currentUser!.createdAt,
        profileImage: null, // Remove the image
        profileBio: _currentUser!.profileBio,
      );

      // Save updated data (this will remove the image from SharedPreferences too)
      await _saveUserData();

      // Also explicitly remove from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('userProfileImage');

      notifyListeners();

      print('Profile image removed successfully');
    } catch (error) {
      print('Error removing profile image: $error');
      throw Exception('Failed to remove profile image. Please try again.');
    }
  }

  // Alternative method for camera
  Future<void> changeUserImageFromCamera() async {
    if (_currentUser == null) {
      throw Exception('No user logged in');
    }

    try {
      final ImagePicker picker = ImagePicker();

      final XFile? pickedImage = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedImage == null) {
        // User cancelled image capture
        print('Image capture cancelled by user');
        return;
      }

      // Convert XFile to File
      final File imageFile = File(pickedImage.path);

      // Read image as bytes
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      // Store image data in SharedPreferences for persistence
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userProfileImage', base64Image);
      // Update local user data with the image
      _currentUser = User(
        id: _currentUser!.id,
        email: _currentUser!.email,
        password: _currentUser!.password,
        username: _currentUser!.username,
        token: _currentUser!.token,
        refreshToken: _currentUser!.refreshToken,
        createdAt: _currentUser!.createdAt,
        profileImage: imageFile,
        profileBio: _currentUser!.profileBio,
      );

      // Save updated data (including profile image)
      await _saveUserData();
      notifyListeners();

      print('Profile image updated successfully from camera');
    } catch (error) {
      print('Error changing user image from camera: $error');

      // Handle specific image picker errors
      if (error.toString().contains('camera_access_denied')) {
        throw Exception(
          'Camera access denied. Please enable camera permissions in settings.',
        );
      } else if (error.toString().contains('file_not_found')) {
        throw Exception('Camera capture failed.');
      } else {
        throw Exception(
          'Failed to update profile image from camera. Please try again.',
        );
      }
    }
  }

  // FACEBOOK SIGN-IN (Firebase)
  Future<void> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;

        final credential = fb_auth.FacebookAuthProvider.credential(
          accessToken.token,
        );

        final userCredential = await fb_auth.FirebaseAuth.instance
            .signInWithCredential(credential);

        final fbUser = userCredential.user;
        if (fbUser == null) {
          throw Exception(
            'Firebase authentication failed after Facebook sign-in',
          );
        }

        // Use Firebase UID as user ID
        _currentUser = User(
          id: fbUser.uid,
          email: fbUser.email ?? '',
          password: '', // No password for Facebook accounts
          username: fbUser.displayName ?? 'Facebook User',
          token: await fbUser.getIdToken(),
          refreshToken:
              '', // Firebase handles refresh tokens internally for social logins
        );

        // Save user data for auto-login
        await _saveUserData();
        notifyListeners();
      } else {
        throw Exception('Facebook sign-in failed: ${result.status}');
      }
    } catch (error) {
      // More detailed error handling
      if (error.toString().contains('Application has been deleted')) {
        throw Exception(
          'Facebook App configuration is invalid. Please contact support or use alternative sign-in methods.',
        );
      } else if (error.toString().contains('MissingPluginException')) {
        throw Exception(
          'Facebook Auth not properly configured. Please use Google sign-in or email/password authentication.',
        );
      } else if (error.toString().contains('ERROR_CANCELED')) {
        throw Exception('Facebook sign-in was cancelled');
      } else if (error.toString().contains('ERROR_NETWORK')) {
        throw Exception(
          'Network error. Please check your internet connection.',
        );
      } else {
        print('Facebook sign-in failed: ${error.toString()}');
        throw Exception(
          'Facebook sign-in failed. Please try Google sign-in or email/password authentication.',
        );
      }
    }
  }

  // GOOGLE SIGN-IN (Firebase)
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
      );

      // Sign out of any previous Google account first
      await googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled the sign-in
        throw Exception('Google sign-in was cancelled');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        throw Exception('Failed to get Google authentication tokens');
      }

      final credential = fb_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await fb_auth.FirebaseAuth.instance
          .signInWithCredential(credential);

      final fbUser = userCredential.user;
      if (fbUser == null) {
        throw Exception('Firebase authentication failed after Google sign-in');
      }

      // Use Firebase UID as user ID
      _currentUser = User(
        id: fbUser.uid,
        email: fbUser.email ?? '',
        password: '', // No password for Google accounts
        username: fbUser.displayName ?? 'Google User',
        token: await fbUser.getIdToken(),
        refreshToken:
            '', // Firebase handles refresh tokens internally for social logins
      );

      // Save user data for auto-login
      await _saveUserData();
      notifyListeners();
    } catch (error) {
      // More detailed error handling
      if (error.toString().contains('DEVELOPER_ERROR')) {
        throw Exception(
          'Google Sign-In configuration error. Please check SHA-1 fingerprint in Firebase Console.',
        );
      } else if (error.toString().contains('SIGN_IN_REQUIRED')) {
        throw Exception(
          'Google Sign-In requires user interaction. Please try again.',
        );
      } else if (error.toString().contains('NETWORK_ERROR')) {
        throw Exception(
          'Network error. Please check your internet connection.',
        );
      } else {
        print('Google sign-in failed: ${error.toString()}');
        throw Exception('Google sign-in failed: ${error.toString()}');
      }
    }
  }

  // Change user password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (_currentUser == null) {
      throw Exception('No user logged in');
    }

    try {
      // First verify current password by signing in
      final signInUrl = AppConfig.signInUrl;

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
      final changePasswordUrl = AppConfig.updateAccountUrl;

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
              errorMessage =
                  'Password change failed: ${responseData['error']['message']}';
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
        refreshToken:
            responseData['refreshToken'] ??
            _currentUser!.refreshToken, // <-- Add this line
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
  Future<void> changeEmail({
    required String newEmail,
    required String currentPassword,
  }) async {
    if (_currentUser == null) {
      throw Exception('No user logged in');
    }

    try {
      // First verify current password by signing in
      final signInUrl = AppConfig.signInUrl;

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
      final changeEmailUrl = AppConfig.updateAccountUrl;

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
              errorMessage =
                  'Email change failed: ${responseData['error']['message']}';
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
        refreshToken:
            responseData['refreshToken'] ??
            _currentUser!.refreshToken, // <-- Add this line
        createdAt: _currentUser!.createdAt,
      );

      // Save updated data
      await _saveUserData();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  // Refresh the authentication token using the refresh token
  Future<bool> refreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('userRefreshToken');

    if (refreshToken == null || _currentUser == null) {
      return false;
    }

    final url = AppConfig.refreshTokenUrl;

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

      notifyListeners();
      return true;
    } catch (error) {
      throw Exception('Error refreshing token: $error');
    }
  }

  // Refresh the Google Sign-In token
  Future<void> refreshTokenGoogle() async {
    if (_currentUser == null) {
      print('No current user for Google token refresh');
      return;
    }

    try {
      // For Google Sign-In users, we need to refresh through Firebase Auth
      final firebaseUser = fb_auth.FirebaseAuth.instance.currentUser;

      if (firebaseUser != null) {
        // Force refresh the Firebase ID token
        final newToken = await firebaseUser.getIdToken(
          true,
        ); // true forces refresh

        if (newToken != null) {
          // Update user with new token
          _currentUser = User(
            id: _currentUser!.id,
            email: _currentUser!.email,
            password: _currentUser!.password,
            username: _currentUser!.username,
            token: newToken,
            refreshToken: '', // Firebase handles refresh tokens internally
            createdAt: _currentUser!.createdAt,
            profileBio: _currentUser!.profileBio,
            profileImage: _currentUser!.profileImage,
          );

          // Save updated token to SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('userToken', newToken);

          print('Google token refreshed successfully');
          notifyListeners();
        }
      } else {
        // Fallback: Try Google Sign-In silent authentication
        print('No Firebase user, trying Google Sign-In silent auth');
        final googleSignIn = GoogleSignIn();
        final googleUser = await googleSignIn.signInSilently();

        if (googleUser != null) {
          final googleAuth = await googleUser.authentication;

          if (googleAuth.idToken != null) {
            // Re-authenticate with Firebase using the new Google tokens
            final credential = fb_auth.GoogleAuthProvider.credential(
              accessToken: googleAuth.accessToken,
              idToken: googleAuth.idToken,
            );

            final userCredential = await fb_auth.FirebaseAuth.instance
                .signInWithCredential(credential);

            if (userCredential.user != null) {
              final newToken = await userCredential.user!.getIdToken();

              if (newToken != null) {
                // Update user with new token
                _currentUser = User(
                  id: _currentUser!.id,
                  email: _currentUser!.email,
                  password: _currentUser!.password,
                  username: _currentUser!.username,
                  token: newToken,
                  refreshToken: '',
                  createdAt: _currentUser!.createdAt,
                  profileBio: _currentUser!.profileBio,
                  profileImage: _currentUser!.profileImage,
                );

                // Save updated token
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('userToken', newToken);

                print('Google token refreshed via silent sign-in');
                notifyListeners();
              }
            }
          }
        } else {
          print(
            'Google silent sign-in failed - user may need to re-authenticate',
          );
        }
      }
    } catch (e) {
      print('Error refreshing Google token: $e');
      // Don't rethrow here as this is called during auto-login
    }
  }

  // Get a valid token, refreshing if necessary
  Future<String?> getValidToken() async {
    if (_currentUser == null || _currentUser!.token == null) {
      return null;
    }

    // Determine authentication type and refresh accordingly
    bool refreshed = false;

    if (_currentUser!.password.isNotEmpty) {
      // Email/password account - use regular refresh token
      refreshed = await refreshToken();
    } else {
      // Social login account (Google/Facebook) - use Google refresh
      await refreshTokenGoogle();
      refreshed =
          true; // Google refresh doesn't return bool, assume success if no exception
    }

    if (refreshed && _currentUser != null) {
      return _currentUser!.token;
    }

    // If refresh failed but we still have a token, return it
    // (it might still be valid)
    return _currentUser!.token;
  }

  /// Handles 401 authentication errors by attempting appropriate token refresh
  Future<bool> handle401Error() async {
    if (_currentUser == null) {
      print('No current user to refresh token for');
      return false;
    }

    try {
      // Determine authentication type and refresh accordingly
      if (_currentUser!.password.isNotEmpty) {
        // Email/password account - use regular refresh token
        print('Attempting regular token refresh for email/password account');
        return await refreshToken();
      } else {
        // Social login account (Google/Facebook) - use Google refresh
        print('Attempting Google token refresh for social login account');
        await refreshTokenGoogle();
        // Google refresh doesn't return bool, but if no exception was thrown, assume success
        return true;
      }
    } catch (e) {
      print('Error handling 401 authentication error: $e');
      return false;
    }
  }

  // Example of using the valid token in an API call
  Future<void> fetchUserData() async {
    String? token = await getValidToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.get(
      Uri.parse('https://your-api-endpoint.com'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 401) {
      // Try refreshing token using the smart handler
      final refreshed = await handle401Error();
      if (refreshed && _currentUser?.token != null) {
        // Always get the latest token after refresh!
        token = _currentUser!.token;
        final retryResponse = await http.get(
          Uri.parse('https://your-api-endpoint.com'),
          headers: {'Authorization': 'Bearer $token'},
        );
        if (retryResponse.statusCode == 401) {
          throw Exception(
            'Authentication failed even after token refresh. Please login again.',
          );
        }
        if (retryResponse.statusCode != 200) {
          throw Exception('Failed to fetch user data after token refresh');
        }
        // Process retryResponse...
        return;
      } else {
        throw Exception('Session expired. Please login again.');
      }
    }

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch user data');
    }

    // Process response...
  }
}
