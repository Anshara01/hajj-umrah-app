import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hajj_umrah_app/features/packages/package_provider.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packagesAsync = ref.watch(packageProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add Package',
            onPressed: () => context.push('/admin/add_package'),
          )
        ],
      ),
      body: packagesAsync.when(
        data: (packages) {
          if (packages.isEmpty) {
            return const Center(child: Text('No packages available. Add one.'));
          }
          return ListView.builder(
            itemCount: packages.length,
            itemBuilder: (context, index) {
              final pkg = packages[index];
              return ListTile(
                leading: const Icon(Icons.mosque),
                title: Text(pkg.title),
                subtitle: Text('\$${pkg.price.toStringAsFixed(2)} | Status: ${pkg.isActive ? "Active" : "Inactive"}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete Package?'),
                            content: const Text('Are you sure you want to delete this?'),
                            actions: [
                              TextButton(onPressed: () => context.pop(false), child: const Text('Cancel')),
                              TextButton(onPressed: () => context.pop(true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
                            ],
                          ),
                        );
                        if (confirm == true) {
                           await FirebaseFirestore.instance.collection('packages').doc(pkg.id).delete();
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
