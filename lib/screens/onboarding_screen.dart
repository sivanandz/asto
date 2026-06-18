import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../components/location_search_field.dart';
import '../models/location_model.dart';
import '../models/user_profile.dart';
import '../providers/app_provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  LocationModel? _selectedLocation;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(1990),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppTheme.primary,
              surface: AppTheme.surfaceContainerLow,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('MM/dd/yyyy').format(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? const TimeOfDay(hour: 12, minute: 0),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppTheme.primary,
              surface: AppTheme.surfaceContainerLow,
            ),
            timePickerTheme: const TimePickerThemeData(
              backgroundColor: AppTheme.surfaceContainerLow,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        final hour = picked.hourOfPeriod.toString().padLeft(2, '0');
        final minute = picked.minute.toString().padLeft(2, '0');
        final period = picked.period == DayPeriod.am ? 'AM' : 'PM';
        _timeController.text = '$hour:$minute $period';
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null ||
        _selectedTime == null ||
        _selectedLocation == null) {
      setState(() {
        _errorMessage = 'Please fill in all fields including location';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final timeString = _timeController.text;

      final userProfile = UserProfile(
        name: _nameController.text.trim(),
        birthDate: _selectedDate!,
        birthTime: timeString,
        birthLocation: _selectedLocation!.displayName,
        latitude: _selectedLocation!.latitude,
        longitude: _selectedLocation!.longitude,
      );

      final provider = context.read<AppProvider>();
      await provider.createUserProfile(userProfile);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile created successfully!'),
            backgroundColor: AppTheme.primary,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to create profile: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.6),
            radius: 1.0,
            colors: [Color(0xFF083250), Color(0xFF09090B)],
            stops: [0.0, 0.7],
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Initialize Your Soul Map',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontSize: 36,
                  letterSpacing: -1.0,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Precision is required for the celestial alignment. Enter your birth parameters below.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textMuted,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(height: 32),

              // Error message
              if (_errorMessage != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.error),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Symbols.error,
                        color: AppTheme.error,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: AppTheme.error),
                        ),
                      ),
                    ],
                  ),
                ),

              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1E201D).withOpacity(0.4),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppTheme.borderColor),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppTheme.primary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 48,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 48,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'STEP 1 OF 3',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(fontSize: 10, letterSpacing: 1.5),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Full Name
                    _buildInput(
                      controller: _nameController,
                      label: 'FULL NAME',
                      hint: 'e.g. Orion Vance',
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Date and Time
                    Row(
                      children: [
                        Expanded(child: _buildDateInput(context)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildTimeInput(context)),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Location Search
                    LocationSearchField(
                      initialLocation: _selectedLocation,
                      onLocationSelected: (location) {
                        setState(() {
                          _selectedLocation = location;
                          _errorMessage = null;
                        });
                      },
                    ),

                    const SizedBox(height: 32),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _submitForm,
                        icon: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.black,
                                  ),
                                ),
                              )
                            : const Icon(Symbols.arrow_forward),
                        label: Text(
                          _isLoading
                              ? 'Creating...'
                              : 'Generate Cosmic Profile',
                        ),
                        iconAlignment: IconAlignment.end,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Info Card
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1E201D).withOpacity(0.4),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppTheme.borderColor),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Symbols.info, color: AppTheme.primary),
                        const SizedBox(width: 12),
                        Text(
                          'Why We Need This Data',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Your birth chart is a snapshot of the sky at the moment you were born. The exact time and location determine your rising sign and house placements, which are essential for accurate astrological readings.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textMuted,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoItem(
                      'Your data is stored locally on your device',
                    ),
                    _buildInfoItem('We never share your birth information'),
                    _buildInfoItem('You can delete your data at any time'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String label,
    required String hint,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppTheme.textMuted,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          style: Theme.of(context).textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.textMuted.withOpacity(0.5),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildDateInput(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'BIRTH DATE',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppTheme.textMuted,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _dateController,
          style: Theme.of(context).textTheme.bodyLarge,
          readOnly: true,
          onTap: () => _selectDate(context),
          decoration: InputDecoration(
            hintText: 'MM/DD/YYYY',
            hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.textMuted.withOpacity(0.5),
            ),
            suffixIcon: const Icon(
              Symbols.calendar_today,
              color: AppTheme.textMuted,
            ),
          ),
          validator: (value) {
            if (_selectedDate == null) {
              return 'Please select date';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildTimeInput(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'EXACT TIME',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppTheme.textMuted,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _timeController,
          style: Theme.of(context).textTheme.bodyLarge,
          readOnly: true,
          onTap: () => _selectTime(context),
          decoration: InputDecoration(
            hintText: 'HH:MM AM',
            hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.textMuted.withOpacity(0.5),
            ),
            suffixIcon: const Icon(Symbols.schedule, color: AppTheme.textMuted),
          ),
          validator: (value) {
            if (_selectedTime == null) {
              return 'Please select time';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildInfoItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Symbols.check_circle, color: AppTheme.primary, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppTheme.textMuted),
            ),
          ),
        ],
      ),
    );
  }
}
