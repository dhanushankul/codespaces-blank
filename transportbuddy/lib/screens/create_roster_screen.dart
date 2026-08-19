import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// STEP 4 - "Create Rosters" form.
/// Lets the user pick Login/Logout/Both, office location, weekly-off days,
/// a date range, times, and pickup/drop points, then Save.
class CreateRosterScreen extends StatefulWidget {
  const CreateRosterScreen({super.key});

  @override
  State<CreateRosterScreen> createState() => _CreateRosterScreenState();
}

class _CreateRosterScreenState extends State<CreateRosterScreen> {
  String _rosterType = 'Both'; // Login | Logout | Both
  final Set<String> _weeklyOff = {'Sat', 'Sun'};
  DateTime _fromDate = DateTime(2024, 8, 21);
  DateTime _toDate = DateTime(2024, 8, 30);
  TimeOfDay _loginTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _logoutTime = const TimeOfDay(hour: 18, minute: 0);

  final List<String> _days = const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  Future<void> _pickDate({required bool isFrom}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isFrom ? _fromDate : _toDate,
      firstDate: DateTime(2024, 1, 1),
      lastDate: DateTime(2030, 12, 31),
    );
    if (picked != null) {
      setState(() {
        if (isFrom) {
          _fromDate = picked;
        } else {
          _toDate = picked;
        }
      });
    }
  }

  Future<void> _pickTime({required bool isLogin}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isLogin ? _loginTime : _logoutTime,
    );
    if (picked != null) {
      setState(() {
        if (isLogin) {
          _loginTime = picked;
        } else {
          _logoutTime = picked;
        }
      });
    }
  }

  String _formatDate(DateTime d) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${d.day} ${months[d.month - 1]} ${d.year}\n${weekdays[d.weekday - 1]}';
  }

  String _formatTime(TimeOfDay t) => t.format(context);

  void _onSave() {
    // TODO: Send roster payload (type, office, weeklyOff, dates, times,
    // pickup/drop) to your backend API.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Roster saved')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primaryBlue),
        title: const Text('Create Rosters',
            style: TextStyle(color: AppColors.textDark, fontSize: 18)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildTypeSelector(),
          const Divider(height: 32),
          _buildOfficeLocation(),
          const Divider(height: 32),
          _buildWeeklyOff(),
          const Divider(height: 32),
          Row(
            children: [
              Expanded(child: _buildDatePicker('From Date', _fromDate, () => _pickDate(isFrom: true))),
              const SizedBox(width: 16),
              Expanded(child: _buildDatePicker('To Date', _toDate, () => _pickDate(isFrom: false))),
            ],
          ),
          const Divider(height: 32),
          Row(
            children: [
              Expanded(child: _buildTimePicker('Login Time', _loginTime, () => _pickTime(isLogin: true))),
              Expanded(child: _buildTimePicker('Logout Time', _logoutTime, () => _pickTime(isLogin: false))),
            ],
          ),
          const Divider(height: 32),
          Row(
            children: const [
              Expanded(child: _LocationTile(label: 'Login Pickup Location', value: 'Home')),
              Expanded(child: _LocationTile(label: 'Logout Drop Location', value: 'Home')),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
              child: const Text('Save', style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: ['Login', 'Logout', 'Both'].map((type) {
        final bool selected = _rosterType == type;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: ChoiceChip(
            label: Text(type),
            selected: selected,
            onSelected: (_) => setState(() => _rosterType = type),
            selectedColor: AppColors.primaryBlue,
            labelStyle: TextStyle(color: selected ? Colors.white : AppColors.textDark),
            avatar: selected ? const Icon(Icons.check_circle, color: Colors.white, size: 18) : null,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildOfficeLocation() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Office Location', style: TextStyle(color: AppColors.textGrey)),
        SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.business_center, color: AppColors.textDark),
            SizedBox(width: 8),
            Text('Nivaata System', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }

  Widget _buildWeeklyOff() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Weekly Off', style: TextStyle(color: AppColors.textGrey)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _days.map((day) {
            final bool selected = _weeklyOff.contains(day);
            return ChoiceChip(
              label: Text(day),
              selected: selected,
              onSelected: (val) {
                setState(() {
                  if (val) {
                    _weeklyOff.add(day);
                  } else {
                    _weeklyOff.remove(day);
                  }
                });
              },
              selectedColor: AppColors.primaryBlue,
              labelStyle: TextStyle(color: selected ? Colors.white : AppColors.textDark),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDatePicker(String label, DateTime date, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textGrey)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 18, color: AppColors.textDark),
              const SizedBox(width: 6),
              Text(_formatDate(date), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimePicker(String label, TimeOfDay time, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textGrey)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.access_time, size: 18, color: AppColors.textDark),
              const SizedBox(width: 6),
              Text(_formatTime(time), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}

class _LocationTile extends StatelessWidget {
  final String label;
  final String value;
  const _LocationTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textGrey)),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.location_on, size: 18, color: AppColors.textDark),
            const SizedBox(width: 6),
            Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }
}
