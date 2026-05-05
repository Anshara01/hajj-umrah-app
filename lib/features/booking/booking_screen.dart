import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hajj_umrah_app/features/auth/auth_provider.dart';
import 'package:hajj_umrah_app/features/booking/booking_model.dart';
import 'package:hajj_umrah_app/features/booking/booking_provider.dart';
import 'package:hajj_umrah_app/features/packages/package_model.dart';

class BookingScreen extends ConsumerStatefulWidget {
  final PackageModel package;
  const BookingScreen({super.key, required this.package});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  int _passengersCount = 1;
  bool _isLoading = false;

  void _confirmBooking() async {
    final user = ref.read(authStateProvider).value;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User not signed in.')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final totalAmount = widget.package.price * _passengersCount;
      final booking = BookingModel(
        id: '', // Will be assigned by Firestore
        userId: user.uid,
        packageId: widget.package.id,
        passengersCount: _passengersCount,
        totalAmount: totalAmount,
        bookingDate: DateTime.now(),
        status: 'pending',
        paymentStatus: 'pending',
      );

      await ref.read(bookingServiceProvider).createBooking(booking);

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('Booking Confirmed!'),
            content: const Text('Your booking has been placed successfully.'),
            actions: [
              TextButton(
                onPressed: () {
                  context.pop(); // Close dialog
                  context.go('/'); // Navigate back to home
                },
                child: const Text('OK'),
              )
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalAmount = widget.package.price * _passengersCount;

    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Booking')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Package: ${widget.package.title}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Passengers:', style: TextStyle(fontSize: 18)),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () {
                        if (_passengersCount > 1) setState(() => _passengersCount--);
                      },
                    ),
                    Text('$_passengersCount', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () => setState(() => _passengersCount++),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Amount:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text('\$${totalAmount.toStringAsFixed(2)}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _isLoading ? null : _confirmBooking,
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
              child: _isLoading 
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Confirm & Book', style: TextStyle(fontSize: 18)),
            )
          ],
        ),
      ),
    );
  }
}
