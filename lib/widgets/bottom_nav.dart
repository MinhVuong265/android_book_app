import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/routing/app_routes.dart';

class CommonBottomNav extends StatelessWidget {
  final int currentIndex;
  const CommonBottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: Colors.brown,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        if (index == 0) context.push(AppRoutes.collection);
        if (index == 1) context.push(AppRoutes.home);
        if (index == 2) context.push(AppRoutes.profile);
        if (index == 3) context.push(AppRoutes.categories);
        if (index == 4) context.push(AppRoutes.users);
        if (index == 5) context.push(AppRoutes.accounts);
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.book), label: 'My Collection'),
        BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'Explore'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'My Profile'),
        BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Danh mục'),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Người dùng'),
        BottomNavigationBarItem(icon: Icon(Icons.admin_panel_settings), label: 'Tài khoản'),

      ],
    );
  }
}
