import 'package:flutter/material.dart';
import 'package:planner/providers/user_provider.dart';
import 'package:provider/provider.dart';

enum AuthMode { signIn, signUp }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthMode _authMode = AuthMode.signIn;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  void _switchAuthMode() {
    setState(() {
      if (_authMode == AuthMode.signIn) {
        _authMode = AuthMode.signUp;
      } else {
        _authMode = AuthMode.signIn;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final deviceSize = mediaQuery.size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary.withOpacity(0.5),
              theme.colorScheme.secondary.withOpacity(0.9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              top: deviceSize.height * 0.10,
              left: deviceSize.width * 0.04,
              right: deviceSize.width * 0.04,
              bottom: deviceSize.height * 0.20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.fitness_center,
                  size: 70,
                  color: theme.colorScheme.onPrimary,
                ),
                SizedBox(
                  height: _authMode == AuthMode.signIn
                      ? deviceSize.height * 0.06
                      : deviceSize.height * 0.04,
                ),
                Text(
                  'FITNESS PLANNER',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                  ),
                ),
                SizedBox(
                  height: _authMode == AuthMode.signIn
                      ? deviceSize.height * 0.04
                      : deviceSize.height * 0.02,
                ),

                // ✅ Scrollable Auth Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: mediaQuery.size.height * 0.7,
                      ),
                      child: Container(
                        width: deviceSize.width * 0.9,
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _authMode == AuthMode.signIn
                                    ? 'Sign In'
                                    : 'Create Account',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              SizedBox(height: deviceSize.height * 0.03),
                              TextField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon: Icon(Icons.email_outlined),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              SizedBox(height: deviceSize.height * 0.02),
                              _authMode == AuthMode.signUp
                                  ? TextField(
                                      controller: _usernameController,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                        labelText: 'Username',
                                        prefixIcon: Icon(Icons.person_outline),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                    )
                                  : TextField(
                                      controller: _passwordController,
                                      obscureText: true,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                        labelText: 'Password',
                                        prefixIcon: Icon(Icons.lock_outline),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                    ),
                              SizedBox(
                                height: _authMode == AuthMode.signIn
                                    ? deviceSize.height * 0.03
                                    : deviceSize.height * 0.02,
                              ),
                              if (_authMode == AuthMode.signUp) ...[
                                Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: TextField(
                                    controller: _passwordController,
                                    obscureText: true,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      labelText: 'Password',
                                      prefixIcon: Icon(Icons.lock_outline),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: TextField(
                                    controller: _confirmPasswordController,
                                    obscureText: true,
                                    textInputAction: TextInputAction.done,
                                    decoration: InputDecoration(
                                      labelText: 'Confirm Password',
                                      prefixIcon: Icon(Icons.lock),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              SizedBox(
                                height: _authMode == AuthMode.signIn
                                    ? deviceSize.height * 0.02
                                    : deviceSize.height * 0.01,
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  bool isValid = true;
                                  String errorMessage = '';

                                  if (_emailController.text.isEmpty ||
                                      !_emailController.text.contains('@')) {
                                    isValid = false;
                                    errorMessage =
                                        'Please enter a valid email address';
                                  } else if (_usernameController.text.isEmpty &&
                                      _authMode == AuthMode.signUp) {
                                    isValid = false;
                                    errorMessage = 'Username cannot be empty';
                                  } else if (_passwordController.text.isEmpty &&
                                      _authMode == AuthMode.signIn) {
                                    isValid = false;
                                    errorMessage = 'Password cannot be empty';
                                  } else if (_authMode == AuthMode.signUp) {
                                    if (_passwordController.text.length < 8) {
                                      isValid = false;
                                      errorMessage =
                                          'Password must be at least 8 characters long';
                                    } else if (_passwordController.text !=
                                        _confirmPasswordController.text) {
                                      isValid = false;
                                      errorMessage = 'Passwords do not match!';
                                    }
                                  }

                                  if (!isValid) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(errorMessage),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return;
                                  }

                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );

                                  try {
                                    if (_authMode == AuthMode.signUp) {
                                      await Provider.of<UserProvider>(
                                        context,
                                        listen: false,
                                      ).signUp(
                                        _emailController.text,
                                        _passwordController.text,
                                        _usernameController.text,
                                      );
                                    } else {
                                      await Provider.of<UserProvider>(
                                        context,
                                        listen: false,
                                      ).signIn(
                                        _emailController.text,
                                        _passwordController.text,
                                      );
                                    }
                                    
                                    // Check if the context is still valid before proceeding
                                    if (!mounted) return;
                                    
                                    // Safely dismiss the dialog with a check
                                    if (Navigator.canPop(context)) {
                                      Navigator.of(context).pop();
                                    }
                                    
                                    // Don't manually navigate to TabScreen - let HomeWrapper handle it
                                  } catch (e) {
                                    // Safely dismiss the dialog with a check
                                    if (mounted && Navigator.canPop(context)) {
                                      Navigator.of(context).pop();
                                    }
                                    
                                    if (mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Authentication failed: ${e.toString()}',
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.colorScheme.primary,
                                  foregroundColor: theme.colorScheme.onPrimary,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  elevation: theme.brightness == Brightness.dark
                                      ? 8
                                      : 4,
                                  shadowColor:
                                      theme.brightness == Brightness.dark
                                      ? theme.colorScheme.primary
                                      : null,
                                ),
                                child: Text(
                                  _authMode == AuthMode.signIn
                                      ? 'LOGIN'
                                      : 'SIGN UP',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: _authMode == AuthMode.signIn
                      ? deviceSize.height * 0.03
                      : deviceSize.height * 0.02,
                ),
                TextButton(
                  onPressed: _switchAuthMode,
                  child: Text(
                    _authMode == AuthMode.signIn
                        ? 'New user? Create an account'
                        : 'Already have an account? Sign in',
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: deviceSize.height * 0.01,
                    bottom: deviceSize.height * 0.005,
                  ),
                  child: Text(
                    '© ${DateTime.now().year} Fitness Planner',
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary.withOpacity(0.7),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
