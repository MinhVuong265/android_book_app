import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

<<<<<<< Updated upstream
=======
import '/core/routing/app_routes.dart';
>>>>>>> Stashed changes

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
<<<<<<< Updated upstream
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  String? error;
=======
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? error;
  bool _obscurePassword = true;
>>>>>>> Stashed changes

  Future<void> _login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
<<<<<<< Updated upstream
        email: emailCtrl.text.trim(),
        password: passCtrl.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() => error = e.message);
=======
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
       ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Đăng nhập thất bại! Vui lòng kiểm tra lại email và mật khẩu.\n${e.message}"),
        backgroundColor: Colors.redAccent,
      ),
    );
>>>>>>> Stashed changes
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< Updated upstream
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (error != null)
              Text(error!, style: const TextStyle(color: Colors.red)),
            TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: passCtrl, decoration: const InputDecoration(labelText: "Password"), obscureText: true),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _login, child: const Text("Login")),
            TextButton(
              onPressed: () => context.go(AppRoutes.signup),
              child: const Text("No account? Register"),
            )
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
                "Đăng nhập",
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

              // Login button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _login();
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
                    "Đăng nhập",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Sign up link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Chưa có tài khoản? "),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child:
                      GestureDetector(
                      onTap: () {
                        context.go(AppRoutes.signup);
                      },
                      child: const Text(
                        "Đăng ký",
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
