import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String _selectedRole = 'operator';

  final List<Map<String, String>> _roles = [
    {'value': 'operator', 'label': 'Operatör'},
    {'value': 'technician', 'label': 'Teknisyen'},
    {'value': 'admin', 'label': 'Admin'},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    final success = await authProvider.register(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      role: _selectedRole,
    );

    if (success && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kayıt başarılı! Giriş yapabilirsiniz.'),
          backgroundColor: Colors.green,
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.error ?? 'Kayıt başarısız'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kayıt Ol'),
      ),
      body: SafeArea(
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Ad input
                      TextFormField(
                        controller: _nameController,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Ad Soyad',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Ad Soyad gerekli';
                          }
                          if (value.trim().length < 2) {
                            return 'Ad Soyad en az 2 karakter olmalı';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Email input
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'E-posta',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'E-posta gerekli';
                          }
                          if (!value.contains('@')) {
                            return 'Geçerli bir e-posta girin';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Rol seçimi
                      DropdownButtonFormField<String>(
                        value: _selectedRole,
                        decoration: const InputDecoration(
                          labelText: 'Rol',
                          prefixIcon: Icon(Icons.work),
                          border: OutlineInputBorder(),
                        ),
                        items: _roles.map((role) {
                          return DropdownMenuItem<String>(
                            value: role['value'],
                            child: Text(role['label']!),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedRole = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // Password input
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: 'Şifre',
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Şifre gerekli';
                          }
                          if (value.length < 6) {
                            return 'Şifre en az 6 karakter olmalı';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Confirm password input
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _register(),
                        decoration: InputDecoration(
                          labelText: 'Şifre Tekrar',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(_obscureConfirmPassword ? Icons.visibility : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword = !_obscureConfirmPassword;
                              });
                            },
                          ),
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Şifre tekrarı gerekli';
                          }
                          if (value != _passwordController.text) {
                            return 'Şifreler eşleşmiyor';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Kayıt butonu
                      ElevatedButton(
                        onPressed: authProvider.isLoading ? null : _register,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: authProvider.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text(
                                'Kayıt Ol',
                                style: TextStyle(fontSize: 16),
                              ),
                      ),
                      const SizedBox(height: 16),

                      // Giriş yap linki
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Hesabınız var mı? Giriş yapın'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
