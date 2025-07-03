import 'package:flutter/material.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate() && _agreeToTerms) {
      setState(() {
        _isLoading = true;
      });

      // Simulasi proses registrasi
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      // Show success message and navigate back to login
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registrasi berhasil! Silakan login.'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } else if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap setujui syarat dan ketentuan'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildInputField(
    String label,
    String hint,
    TextEditingController controller,
    IconData icon,
    double maxWidth,
    double maxHeight, {
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: (maxWidth * 0.04).clamp(14.0, 18.0),
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2d3748),
          ),
        ),
        SizedBox(height: maxHeight * 0.008),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyle(fontSize: (maxWidth * 0.035).clamp(12.0, 16.0)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: (maxWidth * 0.035).clamp(12.0, 16.0)),
            prefixIcon: Icon(icon),
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
              vertical: maxHeight * 0.012,
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildPasswordField(
    String label,
    String hint,
    TextEditingController controller,
    bool obscure,
    VoidCallback onToggle,
    double maxWidth,
    double maxHeight, {
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: (maxWidth * 0.04).clamp(14.0, 18.0),
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2d3748),
          ),
        ),
        SizedBox(height: maxHeight * 0.008),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          style: TextStyle(fontSize: (maxWidth * 0.035).clamp(12.0, 16.0)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: (maxWidth * 0.035).clamp(12.0, 16.0)),
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                obscure ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: onToggle,
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
              vertical: maxHeight * 0.012,
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
                      vertical: maxHeight * 0.01,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Header Section
                          Row(
                            children: [
                              IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          
                          SizedBox(height: maxHeight * 0.01),
                          
                          // Logo
                          Container(
                            width: maxWidth * 0.15,
                            height: maxWidth * 0.15,
                            constraints: const BoxConstraints(
                              maxWidth: 80,
                              maxHeight: 80,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'assets/images/logo.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          
                          SizedBox(height: maxHeight * 0.015),
                          
                          // Title
                          Text(
                            'Daftar Akun',
                            style: TextStyle(
                              fontSize: (maxWidth * 0.06).clamp(20.0, 26.0),
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          
                          SizedBox(height: maxHeight * 0.005),
                          
                          Text(
                            'Buat akun baru untuk melanjutkan',
                            style: TextStyle(
                              fontSize: (maxWidth * 0.035).clamp(12.0, 16.0),
                              color: Colors.white.withOpacity(0.8),
                              fontWeight: FontWeight.w300,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          
                          SizedBox(height: maxHeight * 0.025),
                          
                          // Form Card
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
                                // Nama Field
                                _buildInputField(
                                  'Nama Lengkap',
                                  'Masukkan nama lengkap',
                                  _namaController,
                                  Icons.person_outline,
                                  maxWidth,
                                  maxHeight,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Nama tidak boleh kosong';
                                    }
                                    return null;
                                  },
                                ),
                                
                                SizedBox(height: maxHeight * 0.015),
                                
                                // Email Field
                                _buildInputField(
                                  'Email',
                                  'Masukkan email',
                                  _emailController,
                                  Icons.email_outlined,
                                  maxWidth,
                                  maxHeight,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Email tidak boleh kosong';
                                    }
                                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                      return 'Format email tidak valid';
                                    }
                                    return null;
                                  },
                                ),
                                
                                SizedBox(height: maxHeight * 0.015),
                                
                                // Username Field
                                _buildInputField(
                                  'Username',
                                  'Masukkan username',
                                  _usernameController,
                                  Icons.account_circle_outlined,
                                  maxWidth,
                                  maxHeight,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Username tidak boleh kosong';
                                    }
                                    if (value.length < 3) {
                                      return 'Username minimal 3 karakter';
                                    }
                                    return null;
                                  },
                                ),
                                
                                SizedBox(height: maxHeight * 0.015),
                                
                                // Password Field
                                _buildPasswordField(
                                  'Password',
                                  'Masukkan password',
                                  _passwordController,
                                  _obscurePassword,
                                  () => setState(() => _obscurePassword = !_obscurePassword),
                                  maxWidth,
                                  maxHeight,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Password tidak boleh kosong';
                                    }
                                    if (value.length < 6) {
                                      return 'Password minimal 6 karakter';
                                    }
                                    return null;
                                  },
                                ),
                                
                                SizedBox(height: maxHeight * 0.015),
                                
                                // Confirm Password Field
                                _buildPasswordField(
                                  'Konfirmasi Password',
                                  'Konfirmasi password',
                                  _confirmPasswordController,
                                  _obscureConfirmPassword,
                                  () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                                  maxWidth,
                                  maxHeight,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Konfirmasi password tidak boleh kosong';
                                    }
                                    if (value != _passwordController.text) {
                                      return 'Password tidak cocok';
                                    }
                                    return null;
                                  },
                                ),
                                
                                SizedBox(height: maxHeight * 0.01),
                                
                                // Terms Checkbox
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Transform.scale(
                                      scale: (maxWidth * 0.002).clamp(0.8, 1.0),
                                      child: Checkbox(
                                        value: _agreeToTerms,
                                        onChanged: (value) {
                                          setState(() {
                                            _agreeToTerms = value ?? false;
                                          });
                                        },
                                        activeColor: const Color(0xFF2a5298),
                                      ),
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _agreeToTerms = !_agreeToTerms;
                                          });
                                        },
                                        child: Text(
                                          'Saya setuju dengan syarat dan ketentuan yang berlaku',
                                          style: TextStyle(
                                            color: const Color(0xFF4a5568),
                                            fontSize: (maxWidth * 0.035).clamp(12.0, 16.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                
                                SizedBox(height: maxHeight * 0.02),
                                
                                // Register Button
                                SizedBox(
                                  width: double.infinity,
                                  height: (maxHeight * 0.06).clamp(45.0, 55.0),
                                  child: ElevatedButton(
                                    onPressed: _isLoading ? null : _handleRegister,
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
                                            'Daftar',
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
                          
                          SizedBox(height: maxHeight * 0.02),
                          
                          // Footer Section
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: maxWidth * 0.04),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Sudah punya akun? ',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: (maxWidth * 0.035).clamp(12.0, 16.0),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Text(
                                    'Login',
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
                          
                          
                          SizedBox(height: maxHeight * 0.02),
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
}