import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/extensions/context_extensions.dart';
import '../../models/medical_profile.dart';
import '../../shared/providers.dart';
import '../../shared/widgets/pin_dialog.dart';

class MedicalEditScreen extends ConsumerStatefulWidget {
  const MedicalEditScreen({super.key});

  @override
  ConsumerState<MedicalEditScreen> createState() => _MedicalEditScreenState();
}

class _MedicalEditScreenState extends ConsumerState<MedicalEditScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isPinVerified = false;

  late TextEditingController _conditionsController;
  late TextEditingController _allergiesController;
  late TextEditingController _foodAllergiesController;
  late TextEditingController _medAllergiesController;
  late TextEditingController _medicinesController;
  late TextEditingController _disabilitiesController;
  late TextEditingController _bloodPressureController;
  late TextEditingController _visionController;
  late TextEditingController _hearingController;
  late TextEditingController _mentalNotesController;
  late TextEditingController _healthNotesController;
  late TextEditingController _doctorNameController;
  late TextEditingController _doctorPhoneController;
  late TextEditingController _hospitalNameController;
  late TextEditingController _hospitalPhoneController;
  late TextEditingController _insuranceProviderController;
  late TextEditingController _insurancePolicyController;
  late TextEditingController _notesController;

  bool _organDonor = false;
  bool _diabetes = false;
  bool _asthma = false;
  bool _heartDisease = false;
  bool _kidneyDisease = false;
  bool _cancer = false;
  bool _epilepsy = false;
  bool _pregnancy = false;

  String _rhFactor = 'Positive';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkPinProtection());
    final med = ref.read(medicalProfileProvider).value ?? const MedicalProfile();

    _conditionsController = TextEditingController(text: med.medicalConditions.join(', '));
    _allergiesController = TextEditingController(text: med.allergies.join(', '));
    _foodAllergiesController = TextEditingController(text: med.foodAllergies.join(', '));
    _medAllergiesController = TextEditingController(text: med.medicineAllergies.join(', '));
    _medicinesController = TextEditingController(text: med.currentMedicines.join(', '));
    _disabilitiesController = TextEditingController(text: med.disabilities.join(', '));
    _bloodPressureController = TextEditingController(text: med.bloodPressure);
    _visionController = TextEditingController(text: med.vision);
    _hearingController = TextEditingController(text: med.hearing);
    _mentalNotesController = TextEditingController(text: med.mentalHealthNotes);
    _healthNotesController = TextEditingController(text: med.healthNotes);
    _doctorNameController = TextEditingController(text: med.doctorName);
    _doctorPhoneController = TextEditingController(text: med.doctorPhone);
    _hospitalNameController = TextEditingController(text: med.hospitalName);
    _hospitalPhoneController = TextEditingController(text: med.hospitalPhone);
    _insuranceProviderController = TextEditingController(text: med.insuranceProvider);
    _insurancePolicyController = TextEditingController(text: med.insurancePolicyNumber);
    _notesController = TextEditingController(text: med.emergencyNotes);

    _organDonor = med.organDonor;
    _diabetes = med.diabetes;
    _asthma = med.asthma;
    _heartDisease = med.heartDisease;
    _kidneyDisease = med.kidneyDisease;
    _cancer = med.cancer;
    _epilepsy = med.epilepsy;
    _pregnancy = med.pregnancy;

    if (med.rhFactor.isNotEmpty) _rhFactor = med.rhFactor;
  }

  Future<void> _checkPinProtection() async {
    final settings = ref.read(settingsProvider).value;
    final pin = settings?.pinCode ?? '';
    if (pin.isNotEmpty) {
      final verified = await PinDialog.verifyPin(
        context,
        pin,
        title: 'Security PIN Required',
        subtitle: 'Enter 4-digit PIN to edit Medical Profile',
      );
      if (!verified && mounted) {
        context.pop();
      } else {
        if (mounted) setState(() => _isPinVerified = true);
      }
    } else {
      if (mounted) setState(() => _isPinVerified = true);
    }
  }

  @override
  void dispose() {
    _conditionsController.dispose();
    _allergiesController.dispose();
    _foodAllergiesController.dispose();
    _medAllergiesController.dispose();
    _medicinesController.dispose();
    _disabilitiesController.dispose();
    _bloodPressureController.dispose();
    _visionController.dispose();
    _hearingController.dispose();
    _mentalNotesController.dispose();
    _healthNotesController.dispose();
    _doctorNameController.dispose();
    _doctorPhoneController.dispose();
    _hospitalNameController.dispose();
    _hospitalPhoneController.dispose();
    _insuranceProviderController.dispose();
    _insurancePolicyController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  List<String> _parseCsv(String text) {
    if (text.isEmpty) return [];
    return text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final updated = MedicalProfile(
      rhFactor: _rhFactor,
      medicalConditions: _parseCsv(_conditionsController.text),
      allergies: _parseCsv(_allergiesController.text),
      foodAllergies: _parseCsv(_foodAllergiesController.text),
      medicineAllergies: _parseCsv(_medAllergiesController.text),
      currentMedicines: _parseCsv(_medicinesController.text),
      disabilities: _parseCsv(_disabilitiesController.text),
      organDonor: _organDonor,
      bloodPressure: _bloodPressureController.text.trim(),
      diabetes: _diabetes,
      asthma: _asthma,
      heartDisease: _heartDisease,
      kidneyDisease: _kidneyDisease,
      cancer: _cancer,
      epilepsy: _epilepsy,
      pregnancy: _pregnancy,
      vision: _visionController.text.trim(),
      hearing: _hearingController.text.trim(),
      mentalHealthNotes: _mentalNotesController.text.trim(),
      healthNotes: _healthNotesController.text.trim(),
      doctorName: _doctorNameController.text.trim(),
      doctorPhone: _doctorPhoneController.text.trim(),
      hospitalName: _hospitalNameController.text.trim(),
      hospitalPhone: _hospitalPhoneController.text.trim(),
      insuranceProvider: _insuranceProviderController.text.trim(),
      insurancePolicyNumber: _insurancePolicyController.text.trim(),
      emergencyNotes: _notesController.text.trim(),
    );

    await ref.read(medicalProfileProvider.notifier).updateMedicalProfile(updated);
    if (mounted) {
      context.showSnackBar('Medical Profile saved successfully.');
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider).value;
    final hasPin = settings?.pinCode.isNotEmpty ?? false;

    if (hasPin && !_isPinVerified) {
      return Scaffold(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        appBar: AppBar(title: const Text('Edit Medical Profile')),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Edit Medical Profile'),
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
            // General Information
            _buildSectionTitle('General Health Parameters'),
            _buildDropdownField(
              label: 'RH Factor',
              value: _rhFactor,
              items: ['Positive', 'Negative','Not Specified'],
              onChanged: (val) => setState(() => _rhFactor = val!),
            ),
            const SizedBox(height: 12),
            _buildTextField(_conditionsController, 'Medical Conditions (separated by commas)', maxLines: 2),
            const SizedBox(height: 12),
            _buildTextField(_allergiesController, 'Allergies (separated by commas)', maxLines: 2),
            const SizedBox(height: 12),
            _buildTextField(_medicinesController, 'Current Medications (separated by commas)', maxLines: 2),
            const SizedBox(height: 12),
            _buildTextField(_disabilitiesController, 'Disabilities (separated by commas)'),
            const SizedBox(height: 12),
            _buildTextField(_bloodPressureController, 'Usual Blood Pressure (e.g. 120/80)'),

            // Diagnostic switches
            const Divider(height: 32),
            _buildSectionTitle('Known Illnesses / Statuses'),
            _buildSwitchTile('Asthma', _asthma, (val) => setState(() => _asthma = val)),
            _buildSwitchTile('Cancer', _cancer, (val) => setState(() => _cancer = val)),
            _buildSwitchTile('Diabetes', _diabetes, (val) => setState(() => _diabetes = val)),
            _buildSwitchTile('Epilepsy', _epilepsy, (val) => setState(() => _epilepsy = val)),
            _buildSwitchTile('Heart Disease', _heartDisease, (val) => setState(() => _heartDisease = val)),
            _buildSwitchTile('Kidney Disease', _kidneyDisease, (val) => setState(() => _kidneyDisease = val)),
            _buildSwitchTile('Pregnancy', _pregnancy, (val) => setState(() => _pregnancy = val)),
            _buildSwitchTile('Organ Donor', _organDonor, (val) => setState(() => _organDonor = val)),

            // Primary Care details
            const Divider(height: 32),
            _buildSectionTitle('Preferred Doctor & Hospital'),
            _buildTextField(_doctorNameController, 'Doctor Full Name'),
            const SizedBox(height: 12),
            _buildTextField(_doctorPhoneController, 'Doctor Direct Phone', keyboardType: TextInputType.phone),
            const SizedBox(height: 12),
            _buildTextField(_hospitalNameController, 'Hospital Name'),
            const SizedBox(height: 12),
            _buildTextField(_hospitalPhoneController, 'Hospital Emergency Phone', keyboardType: TextInputType.phone),

            // Insurance details
            const Divider(height: 32),
            _buildSectionTitle('Medical Insurance'),
            _buildTextField(_insuranceProviderController, 'Insurance Provider'),
            const SizedBox(height: 12),
            _buildTextField(_insurancePolicyController, 'Policy Number'),

            // Extra notes
            const Divider(height: 32),
            _buildSectionTitle('Critical Emergency Note'),
            _buildTextField(_notesController, 'E.g. Requires inhaler in bag at all times.', maxLines: 3),
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
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
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

  Widget _buildSwitchTile(String label, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: context.colorScheme.onSurface)),
      value: value,
      onChanged: onChanged,
      activeThumbColor: AppColors.primaryRed,
      contentPadding: EdgeInsets.zero,
    );
  }
}
