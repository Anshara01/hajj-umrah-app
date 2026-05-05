import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:hajj_umrah_app/features/packages/package_model.dart';

class AddPackageScreen extends StatefulWidget {
  const AddPackageScreen({super.key});

  @override
  State<AddPackageScreen> createState() => _AddPackageScreenState();
}

class _AddPackageScreenState extends State<AddPackageScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _durationController = TextEditingController();
  final _amenitiesController = TextEditingController();
  final _imagesController = TextEditingController();

  bool _isLoading = false;
  bool _isActive = true;

  void _savePackage() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final amenitiesList = _amenitiesController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      final imagesList = _imagesController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

      final pkg = PackageModel(
        id: '',
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        price: double.parse(_priceController.text.trim()),
        durationDays: int.parse(_durationController.text.trim()),
        startDate: DateTime.now().add(const Duration(days: 30)),
        endDate: DateTime.now().add(Duration(days: 30 + int.parse(_durationController.text.trim()))),
        amenities: amenitiesList,
        images: imagesList,
        isActive: _isActive,
      );

      await FirebaseFirestore.instance.collection('packages').add(pkg.toMap());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Package added successfully')));
        context.pop();
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Package')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(controller: _titleController, decoration: const InputDecoration(labelText: 'Title'), validator: (v) => v!.isEmpty ? 'Required' : null),
              const SizedBox(height: 16),
              TextFormField(controller: _descController, maxLines: 3, decoration: const InputDecoration(labelText: 'Description'), validator: (v) => v!.isEmpty ? 'Required' : null),
              const SizedBox(height: 16),
              Row(
                children: [
                   Expanded(child: TextFormField(controller: _priceController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Price'), validator: (v) => v!.isEmpty ? 'Required' : null)),
                   const SizedBox(width: 16),
                   Expanded(child: TextFormField(controller: _durationController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Duration (Days)'), validator: (v) => v!.isEmpty ? 'Required' : null)),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(controller: _amenitiesController, decoration: const InputDecoration(labelText: 'Amenities (comma separated)')),
              const SizedBox(height: 16),
              TextFormField(controller: _imagesController, decoration: const InputDecoration(labelText: 'Image URLs (comma separated)')),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Active Status'),
                value: _isActive,
                onChanged: (val) => setState(() => _isActive = val),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _savePackage,
                child: _isLoading ? const CircularProgressIndicator() : const Text('Save Package'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
