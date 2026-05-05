import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hajj_umrah_app/features/packages/package_model.dart';

class PackageDetailScreen extends StatelessWidget {
  final PackageModel package;

  const PackageDetailScreen({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(package.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (package.images.isNotEmpty)
              SizedBox(
                height: 250,
                child: PageView.builder(
                  itemCount: package.images.length,
                  itemBuilder: (context, index) {
                    return Image.network(
                      package.images[index],
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade300),
                    );
                  },
                ),
              )
            else
              Container(
                height: 250,
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                child: Icon(Icons.mosque, size: 80, color: Theme.of(context).primaryColor),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('\$${package.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
                      Chip(label: Text('${package.durationDays} Days')),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(package.description, style: const TextStyle(height: 1.5)),
                  const SizedBox(height: 16),
                  const Text('Amenities', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: package.amenities.map((amenity) => Chip(
                      label: Text(amenity), 
                      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                    )).toList(),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => context.push('/book_package', extra: package),
                      child: const Text('Book Now'),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
