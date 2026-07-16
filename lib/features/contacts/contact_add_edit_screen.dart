import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/app_colors.dart';
import '../../core/extensions/context_extensions.dart';
import '../../models/emergency_contact.dart';
import '../../shared/providers.dart';

class ContactAddEditScreen extends ConsumerStatefulWidget {
  final String? contactId;
  const ContactAddEditScreen({super.key, this.contactId});

  @override
  ConsumerState<ContactAddEditScreen> createState() => _ContactAddEditScreenState();
}

class _ContactAddEditScreenState extends ConsumerState<ContactAddEditScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _relationshipController;
  late TextEditingController _primaryPhoneController;
  late TextEditingController _altPhoneController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _notesController;

  bool _isFavorite = false;
  bool _sendSms = true;
  int _priority = 0;

  @override
  void initState() {
    super.initState();
    EmergencyContact? contact;
    if (widget.contactId != null) {
      final contacts = ref.read(contactsProvider).value ?? [];
      contact = contacts.firstWhere((c) => c.id == widget.contactId);
    }

    _nameController = TextEditingController(text: contact?.name ?? '');
    _relationshipController = TextEditingController(text: contact?.relationship ?? '');
    _primaryPhoneController = TextEditingController(text: contact?.primaryPhone ?? '');
    _altPhoneController = TextEditingController(text: contact?.alternativePhone ?? '');
    _emailController = TextEditingController(text: contact?.email ?? '');
    _addressController = TextEditingController(text: contact?.address ?? '');
    _notesController = TextEditingController(text: contact?.notes ?? '');

    _isFavorite = contact?.isFavorite ?? false;
    _sendSms = contact?.sendSmsOnSos ?? true;
    _priority = contact?.priority ?? 0;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _relationshipController.dispose();
    _primaryPhoneController.dispose();
    _altPhoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final contact = EmergencyContact(
      id: widget.contactId ?? const Uuid().v4(),
      name: _nameController.text.trim(),
      relationship: _relationshipController.text.trim(),
      primaryPhone: _primaryPhoneController.text.trim(),
      alternativePhone: _altPhoneController.text.trim(),
      email: _emailController.text.trim(),
      address: _addressController.text.trim(),
      priority: _priority,
      isFavorite: _isFavorite,
      notes: _notesController.text.trim(),
      sendSmsOnSos: _sendSms,
    );

    await ref.read(contactsProvider.notifier).addContact(contact);
    if (mounted) {
      context.showSnackBar('Contact saved successfully.');
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.contactId != null;

    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Contact' : 'Add Emergency Contact'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: AppColors.primaryRed),
            onPressed: _save,
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Photo picker simulation
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: context.colorScheme.surface,
                      shape: BoxShape.circle,
                      border: Border.all(color: context.colorScheme.surface, width: 4),
                      boxShadow: const [
                        BoxShadow(color: Color(0x11000000), blurRadius: 10, offset: Offset(0, 4))
                      ],
                    ),
                    child: const Center(
                      child: Icon(Icons.person_add_alt_rounded, size: 40, color: Colors.grey),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: AppColors.primaryRed,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, size: 12, color: Colors.white),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Form inputs
            _buildTextField(
              _nameController,
              'Full Name *',
              validator: (v) => v!.isEmpty ? 'Name is required' : null,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              _relationshipController,
              'Relationship * (e.g. Spouse, Father, Doctor)',
              validator: (v) => v!.isEmpty ? 'Relationship is required' : null,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              _primaryPhoneController,
              'Primary Phone Number *',
              keyboardType: TextInputType.phone,
              validator: (v) => v!.isEmpty ? 'Phone number is required' : null,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              _altPhoneController,
              'Alternative Phone Number',
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              _emailController,
              'Email Address',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              _addressController,
              'Home Address',
            ),
            const SizedBox(height: 12),
            _buildTextField(
              _notesController,
              'Extra Notes (e.g. keyholder, works nearby)',
              maxLines: 3,
            ),

            // Preference switches
            const Divider(height: 32),
            SwitchListTile(
              title: Text('Send SOS Coordinates', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: context.colorScheme.onSurface)),
              subtitle: const Text('Automatically text location details when SOS is triggered', style: TextStyle(fontSize: 11, color: Colors.grey)),
              value: _sendSms,
              onChanged: (val) => setState(() => _sendSms = val),
              activeThumbColor: AppColors.primaryRed,
              contentPadding: EdgeInsets.zero,
            ),
            SwitchListTile(
              title: Text('Mark as Favorite', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: context.colorScheme.onSurface)),
              subtitle: const Text('Pin to dashboard shortcuts list', style: TextStyle(fontSize: 11, color: Colors.grey)),
              value: _isFavorite,
              onChanged: (val) => setState(() => _isFavorite = val),
              activeThumbColor: AppColors.primaryRed,
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
        filled: true,
        fillColor: context.colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: context.colorScheme.onSurface.withValues(alpha: 0.12)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryRed, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
