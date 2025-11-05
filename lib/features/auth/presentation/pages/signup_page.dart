<<<<<<< Updated upstream
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
=======
import 'package:book_app/core/routing/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
>>>>>>> Stashed changes

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  State<SignupPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<SignupPage> {
<<<<<<< Updated upstream
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  String? error;

  Future<void> _register() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailCtrl.text.trim(),
        password: passCtrl.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() => error = e.message);
    }
=======
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? error;
  bool _obscurePassword = true; 
  bool _obscureConfirmPassword = true;

  Future<void> _register() async {
    if(_passwordController.text != _confirmPasswordController.text) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Mật khẩu xác nhận không khớp!"),
          backgroundColor: Colors.redAccent,
          duration: Duration(milliseconds: 1000),
        ),
      );
      return;
    }
    else {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
      } on FirebaseAuthException catch (e) {
        setState(() => error = e.message);
      }
    }
    
>>>>>>> Stashed changes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< Updated upstream
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (error != null)
              Text(error!, style: const TextStyle(color: Colors.red)),
            TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: passCtrl, decoration: const InputDecoration(labelText: "Password"), obscureText: true),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _register, child: const Text("Create Account")),
          ],
=======
      backgroundColor: const Color(0xFFF5F5F5),
      body: Center(
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Đăng ký",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),
              // Email field
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Email",
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: "Nhập email",
                  hintStyle: TextStyle(color: Colors.grey.withOpacity(0.7)),
                  prefixIcon: const Icon(Icons.email_outlined, color: Colors.pinkAccent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                ),
              ),

              const SizedBox(height: 16),

              // Password field
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Mật khẩu",
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: "Nhập mật khẩu",
                  hintStyle: TextStyle(color: Colors.grey.withOpacity(0.7)),
                  prefixIcon: const Icon(Icons.lock_outline, color: Colors.pinkAccent),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: Colors.pinkAccent,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                ),
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerLeft,
                child: Text (
                  "Xác nhận lại mật khẩu",
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w500,
                  ),
                )
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  hintText: "Nhập lại mật khẩu",
                  hintStyle: TextStyle(color: Colors.grey.withOpacity(0.7)),
                  prefixIcon: const Icon(Icons.lock_outline, color: Colors.pinkAccent),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: Colors.pinkAccent,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                ),
              ),
              const SizedBox(height: 24),

              // Register button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _register();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C8F8),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Đăng ký",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Sign up link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Đã có tài khoản? "),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child:
                      GestureDetector(
                      onTap: () {
                        context.go(AppRoutes.login);
                      },
                      child: const Text(
                        "Đăng nhập",
                        style: TextStyle(
                          color: Colors.lightBlueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
>>>>>>> Stashed changes
        ),
      ),
    );
  }
<<<<<<< Updated upstream
}
=======
}
>>>>>>> Stashed changes
