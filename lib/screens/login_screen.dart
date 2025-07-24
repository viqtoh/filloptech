import 'package:flutter/material.dart';
import '../widgets/app_widgets.dart'; // Import our reusable widgets

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _passcodeController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _passcodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingOverlay(
        isLoading: _isLoading,
        message: 'Logging in...',
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.lightBlue[100]!,
                Colors.white,
              ],
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                // Top bar
                AppTopBar(
                  title: 'FILLOP TECH (HANDS-ON CBT)',
                  showBackButton: true,
                ),
                
                // Logo in top right
                Positioned(
                  top: 70,
                  right: 20,
                  child: AppLogo(size: 80),
                ),
                
                // Background decoration
                _buildBackgroundElements(),
                
                // Main content
                Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 100), // Space for top bar
                        
                        // Main title
                        Text(
                          'FILLOP TECH',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w300,
                            color: Colors.blue[300],
                            letterSpacing: 2,
                          ),
                        ),
                        
                        SizedBox(height: 40),
                        
                        // Login card
                        _buildLoginCard(),
                        
                        SizedBox(height: 40),
                        
                        // Footer
                        _buildFooter(),
                      ],
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

  Widget _buildBackgroundElements() {
    return Positioned(
      bottom: 0,
      right: 0,
      child: Opacity(
        opacity: 0.1,
        child: Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            Icons.person_outline,
            size: 150,
            color: Colors.grey[400],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginCard() {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(maxWidth: 500),
      child: Card(
        elevation: 20,
        shadowColor: Colors.blue.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue[700]!,
                Colors.blue[800]!,
              ],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.all(40),
          child: Column(
            children: [
              // Welcome text
              Text(
                'WELCOME!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              
              SizedBox(height: 10),
              
              Text(
                'CBT - EXPERIENCE IT PROPER',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  letterSpacing: 1,
                ),
              ),
              
              SizedBox(height: 40),
              
              // Passcode label
              Text(
                'Passcode:',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              
              SizedBox(height: 15),
              
              // Passcode input - using our custom widget concept but styled for this specific case
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _passcodeController,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 8,
                  ),
                  decoration: InputDecoration(
                    hintText: '0 1 5 2 0 9',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      letterSpacing: 8,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
                ),
              ),
              
              SizedBox(height: 30),
              
              // Using our custom AppButton
              AppButton(
                text: 'USER LOG IN',
                onPressed: _handleLogin,
                isLoading: _isLoading,
                backgroundColor: Colors.black,
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Text(
          '2025 © FILLOP TECH',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        SizedBox(height: 10),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/register');
          },
          child: Text(
            'Don\'t have an account? Register here',
            style: TextStyle(
              color: Colors.blue[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  void _handleLogin() async {
    if (_passcodeController.text.trim().isEmpty) {
      _showMessage('Please enter your passcode');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call delay
    await Future.delayed(Duration(seconds: 2));

    // Validate passcode
    if (_validatePasscode(_passcodeController.text.trim())) {
      // Navigate to exam interface (when created)
      // Navigator.pushReplacementNamed(context, '/exam');
      _showMessage('Login successful! (Exam interface not yet created)');
    } else {
      _showMessage('Invalid passcode. Please try again.');
    }

    setState(() {
      _isLoading = false;
    });
  }

  bool _validatePasscode(String passcode) {
    return passcode == '015209';
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: message.contains('successful') ? Colors.green[600] : Colors.red[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}