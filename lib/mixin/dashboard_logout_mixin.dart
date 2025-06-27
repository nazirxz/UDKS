// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import '../screens/register_screen.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../models/user.dart';
import '../screens/admin_dashboard.dart';
import '../screens/sales_dashboard.dart';
import '../screens/pengecer_dashboard.dart';
import '../screens/manager_dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;
  bool _isCheckingAutoLogin = true;

  @override
  void initState() {
    super.initState();
    _checkAutoLogin();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Check if user should be automatically logged in
  Future<void> _checkAutoLogin() async {
    try {
      final isLoggedIn = await StorageService.isLoggedIn();
      final rememberMe = await StorageService.getRememberMe();
      
      if (isLoggedIn && rememberMe) {
        final savedUser = await StorageService.getSavedUserData();
        if (savedUser != null) {
          // Auto login user
          _navigateToUserDashboard(savedUser);
          return;
        }
      }
      
      // Load saved credentials if remember me was checked
      if (rememberMe) {
        final credentials = await StorageService.getSavedCredentials();
        if (credentials['username'] != null && credentials['password'] != null) {
          _usernameController.text = credentials['username']!;
          _passwordController.text = credentials['password']!;
          setState(() {
            _rememberMe = true;
          });
        }
      }
    } catch (e) {
      print('Error checking auto login: $e');
    } finally {
      setState(() {
        _isCheckingAutoLogin = false;
      });
    }
  }

  // Navigate to appropriate dashboard based on user role
  void _navigateToUserDashboard(User user) {
    Widget destination;
    switch (user.role) {
      case 'admin':
        destination = AdminDashboard(user: user);
        break;
      case 'sales':
        destination = SalesDashboard(user: user);
        break;
      case 'pengecer':
        destination = PengecerDashboard(user: user);
        break;
      case 'manager':
        destination = ManagerDashboard(user: user);
        break;
      default:
        destination = AdminDashboard(user: user);
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => destination),
    );
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final username = _usernameController.text.trim();
        final password = _passwordController.text.trim();
        
        // Authenticate user using AuthService
        final user = await AuthService.authenticate(username, password);

        if (user != null) {
          // Save login data if remember me is checked
          if (_rememberMe) {
            await StorageService.setRememberMe(true);
            await StorageService.saveCredentials(username, password);
            await StorageService.saveUserData(user);
          } else {
            await StorageService.setRememberMe(false);
            await StorageService.saveUserData(user);
          }

          setState(() {
            _isLoading = false;
          });

          // Navigate based on user role
          _navigateToUserDashboard(user);
        } else {
          setState(() {
            _isLoading = false;
          });
          
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Username atau password salah!'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Quick login with demo accounts
  Future<void> _quickLogin(String username, String password) async {
    _usernameController.text = username;
    _passwordController.text = password;
    await _handleLogin();
  }

  @override
  Widget build(BuildContext context) {
    // Show loading screen while checking auto login
    if (_isCheckingAutoLogin) {
      return Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1e3c72), // Deep Blue
                Color(0xFF2a5298), // Royal Blue
              ],
            ),
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                SizedBox(height: 20),
                Text(
                  'Memeriksa login otomatis...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1e3c72), // Deep Blue
              Color(0xFF2a5298), // Royal Blue
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final maxWidth = constraints.maxWidth;
              final maxHeight = constraints.maxHeight;
              
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: maxHeight,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: maxWidth * 0.08,
                      vertical: maxHeight * 0.02,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Header Section
                          Column(
                            children: [
                              // Logo
                              Container(
                                width: maxWidth * 0.2,
                                height: maxWidth * 0.2,
                                constraints: const BoxConstraints(
                                  maxWidth: 100,
                                  maxHeight: 100,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 15,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.asset(
                                    'assets/images/logo.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              
                              SizedBox(height: maxHeight * 0.02),
                              
                              // Welcome Text
                              Text(
                                'Selamat Datang',
                                style: TextStyle(
                                  fontSize: (maxWidth * 0.06).clamp(20.0, 28.0),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              
                              SizedBox(height: maxHeight * 0.005),
                              
                              Text(
                                'Masuk ke akun Anda',
                                style: TextStyle(
                                  fontSize: (maxWidth * 0.035).clamp(12.0, 16.0),
                                  color: Colors.white.withOpacity(0.8),
                                  fontWeight: FontWeight.w300,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          
                          // Form Section
                          Container(
                            width: double.infinity,
                            constraints: const BoxConstraints(maxWidth: 400),
                            padding: EdgeInsets.all(maxWidth * 0.06),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Demo Users Info
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  margin: const EdgeInsets.only(bottom: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.blue.shade200),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Demo Login:',
                                        style: TextStyle(
                                          fontSize: (maxWidth * 0.035).clamp(12.0, 14.0),
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue.shade700,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      // Quick login buttons
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 4,
                                        children: [
                                          _buildQuickLoginButton('Admin', 'admin', 'admin'),
                                          _buildQuickLoginButton('Sales', 'sales', 'sales'),
                                          _buildQuickLoginButton('Pengecer', 'pengecer', 'pengecer'),
                                          _buildQuickLoginButton('Manager', 'manager', 'manager'),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                
                                // Username Field
                                Text(
                                  'Username',
                                  style: TextStyle(
                                    fontSize: (maxWidth * 0.04).clamp(14.0, 18.0),
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF2d3748),
                                  ),
                                ),
                                SizedBox(height: maxHeight * 0.01),
                                TextFormField(
                                  controller: _usernameController,
                                  style: TextStyle(fontSize: (maxWidth * 0.035).clamp(12.0, 16.0)),
                                  decoration: InputDecoration(
                                    hintText: 'Masukkan username',
                                    hintStyle: TextStyle(fontSize: (maxWidth * 0.035).clamp(12.0, 16.0)),
                                    prefixIcon: const Icon(Icons.person_outline),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Colors.grey.shade300),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Colors.grey.shade300),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(color: Color(0xFF2a5298)),
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey.shade50,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: maxWidth * 0.04,
                                      vertical: maxHeight * 0.015,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Username tidak boleh kosong';
                                    }
                                    return null;
                                  },
                                ),
                                
                                SizedBox(height: maxHeight * 0.02),
                                
                                // Password Field
                                Text(
                                  'Password',
                                  style: TextStyle(
                                    fontSize: (maxWidth * 0.04).clamp(14.0, 18.0),
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF2d3748),
                                  ),
                                ),
                                SizedBox(height: maxHeight * 0.01),
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: _obscurePassword,
                                  style: TextStyle(fontSize: (maxWidth * 0.035).clamp(12.0, 16.0)),
                                  decoration: InputDecoration(
                                    hintText: 'Masukkan password',
                                    hintStyle: TextStyle(fontSize: (maxWidth * 0.035).clamp(12.0, 16.0)),
                                    prefixIcon: const Icon(Icons.lock_outline),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Colors.grey.shade300),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: Colors.grey.shade300),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(color: Color(0xFF2a5298)),
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey.shade50,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: maxWidth * 0.04,
                                      vertical: maxHeight * 0.015,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Password tidak boleh kosong';
                                    }
                                    return null;
                                  },
                                ),
                                
                                SizedBox(height: maxHeight * 0.015),
                                
                                // Remember Me Checkbox
                                Row(
                                  children: [
                                    Transform.scale(
                                      scale: (maxWidth * 0.002).clamp(0.8, 1.0),
                                      child: Checkbox(
                                        value: _rememberMe,
                                        onChanged: (value) {
                                          setState(() {
                                            _rememberMe = value ?? false;
                                          });
                                        },
                                        activeColor: const Color(0xFF2a5298),
                                      ),
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _rememberMe = !_rememberMe;
                                          });
                                        },
                                        child: Text(
                                          'Ingat saya (otomatis login)',
                                          style: TextStyle(
                                            color: const Color(0xFF4a5568),
                                            fontSize: (maxWidth * 0.035).clamp(12.0, 16.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                
                                SizedBox(height: maxHeight * 0.025),
                                
                                // Login Button
                                SizedBox(
                                  width: double.infinity,
                                  height: (maxHeight * 0.06).clamp(45.0, 55.0),
                                  child: ElevatedButton(
                                    onPressed: _isLoading ? null : _handleLogin,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF2a5298),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 2,
                                    ),
                                    child: _isLoading
                                        ? SizedBox(
                                            height: (maxHeight * 0.025).clamp(20.0, 25.0),
                                            width: (maxHeight * 0.025).clamp(20.0, 25.0),
                                            child: const CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                            ),
                                          )
                                        : Text(
                                            'Login',
                                            style: TextStyle(
                                              fontSize: (maxWidth * 0.04).clamp(14.0, 18.0),
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Footer Section
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: maxWidth * 0.04),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Belum punya akun? ',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: (maxWidth * 0.035).clamp(12.0, 16.0),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const RegisterScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Daftar',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: (maxWidth * 0.035).clamp(12.0, 16.0),
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildQuickLoginButton(String label, String username, String password) {
    return SizedBox(
      height: 28,
      child: ElevatedButton(
        onPressed: _isLoading ? null : () => _quickLogin(username, password),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade600,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}