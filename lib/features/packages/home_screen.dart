import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hajj_umrah_app/features/packages/package_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packagesAsync = ref.watch(packageProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hajj & Umrah Packages', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      body: packagesAsync.when(
        data: (packages) {
          if (packages.isEmpty) {
            return const Center(child: Text('No packages available at the moment.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: packages.length,
            itemBuilder: (context, index) {
              final pkg = packages[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: InkWell(
                  onTap: () => context.push('/package_detail', extra: pkg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (pkg.images.isNotEmpty)
                        Image.network(
                          pkg.images.first,
                          height: 150,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 150,
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.image, size: 50, color: Colors.grey),
                          ),
                        )
                      else
                        Container(
                          height: 150,
                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                          child: Icon(Icons.flight_takeoff, size: 50, color: Theme.of(context).primaryColor),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(pkg.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Text('\$${pkg.price.toStringAsFixed(2)} | ${pkg.durationDays} Days', 
                                style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
