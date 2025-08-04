import 'package:flutter/material.dart';
import 'package:planner/screens/category_screen.dart';
import 'package:planner/screens/tab_screen.dart';
import 'package:planner/widgets/animated_input_field.dart';

enum AuthMode { signIn, signUp }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  AuthMode _authMode = AuthMode.signIn;
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Initialize with sign in mode (no extra fields)
    _controller.value = 0.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _switchAuthMode() {
    setState(() {
      if (_authMode == AuthMode.signIn) {
        _authMode = AuthMode.signUp;
        _controller.forward();
      } else {
        _authMode = AuthMode.signIn;
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final deviceSize = mediaQuery.size;

    return Scaffold(
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
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: deviceSize.height * 0.01),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // App Logo or Icon
                Icon(
                  Icons.fitness_center,
                  size: 70,
                  color: theme.colorScheme.onPrimary,
                ),

                SizedBox(
                  height: _authMode == AuthMode.signIn
                      ? deviceSize.height * 0.08
                      : deviceSize.height * 0.04,
                ),

                // App Title
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
                      ? deviceSize.height * 0.03
                      : deviceSize.height * 0.02,
                ),

                // Tagline
                Text(
                  'Your personal workout companion',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onPrimary.withOpacity(0.8),
                    fontStyle: FontStyle.italic,
                  ),
                ),

                SizedBox(
                  height: _authMode == AuthMode.signIn
                      ? deviceSize.height * 0.08
                      : deviceSize.height * 0.04,
                ),

                // Auth Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                      constraints: BoxConstraints(
                        minHeight: _authMode == AuthMode.signUp ? 360 : 240,
                      ),
                      width: deviceSize.width * 0.9,
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Title
                            Text(
                              _authMode == AuthMode.signIn
                                  ? 'Sign In'
                                  : 'Create Account',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),

                            SizedBox(height: deviceSize.height * 0.04),

                            // Email field
                            AnimatedInputField(
                              label: 'Email',
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                            ),

                            SizedBox(height: deviceSize.height * 0.04),

                            // Password field
                            AnimatedInputField(
                              label: 'Password',
                              icon: Icons.lock_outline,
                              obscureText: true,
                            ),

                            SizedBox(
                              height: _authMode == AuthMode.signIn
                                  ? deviceSize.height * 0.04
                                  : deviceSize.height * 0.02,
                            ),

                            // Sign up additional fields
                            AnimatedContainer(
                              constraints: BoxConstraints(
                                minHeight: 0,
                                maxHeight: _authMode == AuthMode.signUp
                                    ? 80
                                    : 0,
                              ),
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                              child: FadeTransition(
                                opacity: _fadeAnimation,
                                child: SlideTransition(
                                  position: _slideAnimation,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 16.0),
                                    child: AnimatedInputField(
                                      label: 'Confirm Password',
                                      icon: Icons.lock,
                                      obscureText: true,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: _authMode == AuthMode.signIn
                                  ? null
                                  : deviceSize.height * 0.02,
                            ),

                            // Login/Sign Up Button
                            ElevatedButton(
                              onPressed: () {
                                // TODO: Implement authentication logic
                                Navigator.push(context, MaterialPageRoute(builder: (context) => TabScreen()));
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
                                shadowColor: theme.brightness == Brightness.dark
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
                SizedBox(
                  height: _authMode == AuthMode.signIn
                      ? deviceSize.height * 0.03
                      : deviceSize.height * 0.02,
                ),

                // Switch Auth Mode
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

                // Footer
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
