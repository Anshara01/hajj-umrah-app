import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/auth_provider.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/register_screen.dart';
import '../../features/packages/home_screen.dart';
import '../../features/packages/package_detail_screen.dart';
import '../../features/packages/package_model.dart';
import '../../features/booking/booking_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/admin/admin_dashboard_screen.dart';
import '../../features/admin/add_package_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      if (authState.isLoading) return null;

      final isAuth = authState.value != null;
      final isLoggingIn = state.uri.path == '/login' || state.uri.path == '/register';

      if (!isAuth && !isLoggingIn) return '/login';
      if (isAuth && isLoggingIn) return '/';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/package_detail',
        builder: (context, state) {
          final pkg = state.extra as PackageModel;
          return PackageDetailScreen(package: pkg);
        },
      ),
      GoRoute(
        path: '/book_package',
        builder: (context, state) {
          final pkg = state.extra as PackageModel;
          return BookingScreen(package: pkg);
        },
      ),
      GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
      GoRoute(path: '/admin', builder: (context, state) => const AdminDashboardScreen()),
      GoRoute(path: '/admin/add_package', builder: (context, state) => const AddPackageScreen()),
    ],
  );
});
