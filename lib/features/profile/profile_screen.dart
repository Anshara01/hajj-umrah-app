import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/auth_provider.dart';
import '../../features/booking/booking_provider.dart';
import '../../features/auth/auth_service.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.value;
    final userBookings = ref.watch(userBookingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authServiceProvider).signOut();
              if (context.mounted) context.go('/login');
            },
          )
        ],
      ),
      body: user == null
          ? const Center(child: Text('Not logged in'))
          : Column(
              children: [
                Container(
                  color: Theme.of(context).primaryColor,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, size: 50, color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      Text(user.email ?? 'No email', style: const TextStyle(color: Colors.white, fontSize: 18)),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.admin_panel_settings),
                  title: const Text('Admin Panel'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/admin'),
                ),
                const Divider(),
                Expanded(
                  child: userBookings.when(
                    data: (bookings) {
                      if (bookings.isEmpty) {
                        return const Center(child: Text('No booking history found.'));
                      }
                      return ListView.builder(
                        itemCount: bookings.length,
                        itemBuilder: (context, index) {
                          final booking = bookings[index];
                          return ListTile(
                            leading: const Icon(Icons.flight_takeoff),
                            title: Text('Booking ID: ${booking.id.isNotEmpty ? booking.id : "Pending"}'),
                            subtitle: Text('Status: ${booking.status} | \$${booking.totalAmount.toStringAsFixed(2)}'),
                            trailing: Text('${booking.passengersCount} Pax'),
                          );
                        },
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (error, _) => Center(child: Text('Error loading history')),
                  ),
                ),
              ],
            ),
    );
  }
}
