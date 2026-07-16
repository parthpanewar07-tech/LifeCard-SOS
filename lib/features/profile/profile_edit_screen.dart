import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/extensions/context_extensions.dart';
import '../../models/user_profile.dart';
import '../../shared/providers.dart';

class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _nicknameController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _nationalityController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _districtController;
  late TextEditingController _stateController;
  late TextEditingController _countryController;
  late TextEditingController _pinController;
  late TextEditingController _occupationController;
  late TextEditingController _aadhaarController;
  late TextEditingController _notesController;

  DateTime? _dob;
  String _gender = 'Male';
  String _bloodGroup = 'Unknown';
  String _language = 'en';
  String _photoPath = '';

  @override
  void initState() {
    super.initState();
    final profile = ref.read(profileProvider).value ?? const UserProfile();
    _photoPath = profile.photoPath;

    _nameController = TextEditingController(text: profile.fullName);
    _nicknameController = TextEditingController(text: profile.nickname);
    _heightController = TextEditingController(text: profile.height > 0 ? profile.height.toString() : '');
    _weightController = TextEditingController(text: profile.weight > 0 ? profile.weight.toString() : '');
    _nationalityController = TextEditingController(text: profile.nationality);
    _addressController = TextEditingController(text: profile.address);
    _cityController = TextEditingController(text: profile.city);
    _districtController = TextEditingController(text: profile.district);
    _stateController = TextEditingController(text: profile.state);
    _countryController = TextEditingController(text: profile.country);
    _pinController = TextEditingController(text: profile.pinCode);
    _occupationController = TextEditingController(text: profile.occupation);
    _aadhaarController = TextEditingController(text: profile.aadhaar ?? '');
    _notesController = TextEditingController(text: profile.emergencyNotes);

    _dob = profile.dateOfBirth;
    if (profile.gender.isNotEmpty) _gender = profile.gender;
    if (profile.bloodGroup.isNotEmpty) {
      _bloodGroup = profile.bloodGroup;
    } else {
      _bloodGroup = 'Unknown';
    }
    if (profile.language.isNotEmpty) _language = profile.language;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nicknameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _nationalityController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _pinController.dispose();
    _occupationController.dispose();
    _aadhaarController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dob = picked;
      });
    }
  }

  int _calculateAge() {
    if (_dob == null) return 0;
    final today = DateTime.now();
    int age = today.year - _dob!.year;
    if (today.month < _dob!.month || (today.month == _dob!.month && today.day < _dob!.day)) {
      age--;
    }
    return age;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final updated = UserProfile(
      photoPath: _photoPath,
      fullName: _nameController.text.trim(),
      nickname: _nicknameController.text.trim(),
      dateOfBirth: _dob,
      gender: _gender,
      bloodGroup: _bloodGroup == 'Unknown' ? '' : _bloodGroup,
      height: double.tryParse(_heightController.text) ?? 0.0,
      weight: double.tryParse(_weightController.text) ?? 0.0,
      nationality: _nationalityController.text.trim(),
      address: _addressController.text.trim(),
      city: _cityController.text.trim(),
      district: _districtController.text.trim(),
      state: _stateController.text.trim(),
      country: _countryController.text.trim(),
      pinCode: _pinController.text.trim(),
      occupation: _occupationController.text.trim(),
      language: _language,
      aadhaar: _aadhaarController.text.trim().isNotEmpty ? _aadhaarController.text.trim() : null,
      emergencyNotes: _notesController.text.trim(),
    );

    await ref.read(profileProvider.notifier).updateProfile(updated);
    if (mounted) {
      context.showSnackBar('User Profile saved successfully.');
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Edit Personal Profile'),
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
            // Profile Photo Uploader
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: context.colorScheme.surface,
                    backgroundImage: _photoPath.isNotEmpty && File(_photoPath).existsSync()
                        ? FileImage(File(_photoPath))
                        : null,
                    child: _photoPath.isEmpty || !File(_photoPath).existsSync()
                        ? const Icon(Icons.person, size: 50, color: Colors.grey)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Material(
                      color: AppColors.primaryRed,
                      shape: const CircleBorder(),
                      elevation: 4,
                      child: InkWell(
                        onTap: _showPhotoPickerOptions,
                        customBorder: const CircleBorder(),
                        child: const Padding(
                          padding: EdgeInsets.all(6.0),
                          child: Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Core Identity
            _buildSectionTitle('Core Identity'),
            _buildTextField(_nameController, 'Full Name *', validator: (v) => v!.isEmpty ? 'Name is required' : null),
            const SizedBox(height: 12),
            _buildTextField(_nicknameController, 'Nickname'),
            const SizedBox(height: 12),

            // Date of birth row
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Date of Birth', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey)),
              subtitle: Text(
                _dob == null ? 'Select Date' : DateFormat('dd MMM yyyy').format(_dob!),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
              ),
              trailing: const Icon(Icons.calendar_month, color: AppColors.primaryRed),
              onTap: () => _selectDate(context),
            ),
            if (_dob != null) ...[
              const SizedBox(height: 4),
              Text('Calculated Age: ${_calculateAge()} years', style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold)),
            ],
            const Divider(height: 24),

            // Dropdowns row
            Row(
              children: [
                Expanded(
                  child: _buildDropdownField(
                    label: 'Gender',
                    value: _gender,
                    items: ['Male', 'Female', 'Other'],
                    onChanged: (val) => setState(() => _gender = val!),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDropdownField(
                    label: 'Blood Group',
                    value: _bloodGroup,
                    items: ['Unknown', 'A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'],
                    onChanged: (val) => setState(() => _bloodGroup = val!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Height and Weight
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    _heightController,
                    'Height (cm)',
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    _weightController,
                    'Weight (kg)',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            _buildTextField(_nationalityController, 'Nationality'),
            const SizedBox(height: 12),
            _buildTextField(_aadhaarController, 'Aadhaar (Optional)', keyboardType: TextInputType.number),

            // Address Details
            const SizedBox(height: 16),
            _buildSectionTitle('Address Details'),
            _buildTextField(_addressController, 'Address Line'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildTextField(_cityController, 'City')),
                const SizedBox(width: 12),
                Expanded(child: _buildTextField(_districtController, 'District')),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildTextField(_stateController, 'State')),
                const SizedBox(width: 12),
                Expanded(child: _buildTextField(_pinController, 'PIN Code', keyboardType: TextInputType.number)),
              ],
            ),
            const SizedBox(height: 12),
            _buildTextField(_countryController, 'Country'),

            // Extra notes
            const SizedBox(height: 16),
            _buildSectionTitle('Emergency Notes'),
            _buildTextField(_notesController, 'Add extra details for responders', maxLines: 4),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, top: 4.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1),
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

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
      onChanged: onChanged,
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Future<void> _showPhotoPickerOptions() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Profile Photo',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_rounded, color: Colors.cyan),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_rounded, color: Colors.cyan),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              if (_photoPath.isNotEmpty)
                ListTile(
                  leading: const Icon(Icons.delete_rounded, color: AppColors.primaryRed),
                  title: const Text('Remove Photo'),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _photoPath = '';
                    });
                  },
                ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        final appDir = await getApplicationDocumentsDirectory();
        final fileName = 'profile_avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final savedFile = await File(pickedFile.path).copy('${appDir.path}/$fileName');

        setState(() {
          _photoPath = savedFile.path;
        });
      }
    } catch (e) {
      if (mounted) {
        context.showSnackBar('Error picking image: $e');
      }
    }
  }
}
