import 'package:flutter/material.dart';

/// Shown after tapping "Adhoc" on the home screen.
/// Unlike Roster (which repeats daily), Adhoc is a single one-off trip:
/// pick Login or Logout, a date, a time, and pickup/drop stops, then Book.
class AdhocBookingScreen extends StatefulWidget {
  const AdhocBookingScreen({super.key});

  @override
  State<AdhocBookingScreen> createState() => _AdhocBookingScreenState();
}

class _AdhocBookingScreenState extends State<AdhocBookingScreen> {
  static const primaryBlue = Color(0xFF1E6FBA);

  // TODO: replace with stops loaded from your API / roster office locations.
  final List<String> _stops = const [
    'Nivaata System - Main Gate',
    'Indira Nagar Metro',
    'Domlur Signal',
    'Marathahalli Bridge',
    'Whitefield Tech Park',
  ];

  String _tripType = 'Login'; // Login | Logout
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  String? _pickup;
  String? _drop;

  bool get _canBook =>
      _pickup != null && _drop != null && _pickup != _drop;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _time);
    if (picked != null) setState(() => _time = picked);
  }

  String _formatDate(DateTime d) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  void _onBook() {
    if (!_canBook) return;

    // TODO: call your booking API here with
    // (_tripType, _date, _time, _pickup, _drop).
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Adhoc $_tripType booked: $_pickup -> $_drop on '
          '${_formatDate(_date)} at ${_time.format(context)}',
        ),
      ),
    );

    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: primaryBlue),
        title: const Text('Book Adhoc Trip', style: TextStyle(color: Colors.black87)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Trip Type', style: TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 8),
            Row(
              children: ['Login', 'Logout'].map((type) {
                final bool selected = _tripType == type;
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: ChoiceChip(
                    label: Text(type),
                    selected: selected,
                    onSelected: (_) => setState(() => _tripType = type),
                    selectedColor: primaryBlue,
                    labelStyle: TextStyle(color: selected ? Colors.white : Colors.black87),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(child: _buildDatePicker()),
                const SizedBox(width: 16),
                Expanded(child: _buildTimePicker()),
              ],
            ),

            const SizedBox(height: 24),

            const Text('Pickup Location', style: TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 8),
            _buildDropdown(
              hint: 'Select pickup stop',
              value: _pickup,
              onChanged: (val) => setState(() => _pickup = val),
            ),

            const SizedBox(height: 24),

            const Text('Drop Location', style: TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 8),
            _buildDropdown(
              hint: 'Select drop stop',
              value: _drop,
              onChanged: (val) => setState(() => _drop = val),
            ),

            if (_pickup != null && _pickup == _drop) ...[
              const SizedBox(height: 8),
              const Text(
                'Pickup and drop cannot be the same',
                style: TextStyle(color: Colors.red, fontSize: 13),
              ),
            ],

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _canBook ? _onBook : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  disabledBackgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                child: const Text(
                  'Book Trip',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: _pickDate,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Date', style: TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, size: 18, color: Colors.black87),
                const SizedBox(width: 8),
                Text(_formatDate(_date)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimePicker() {
    return GestureDetector(
      onTap: _pickTime,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Time', style: TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.access_time, size: 18, color: Colors.black87),
                const SizedBox(width: 8),
                Text(_time.format(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String hint,
    required String? value,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          hint: Text(hint),
          icon: const Icon(Icons.keyboard_arrow_down),
          items: _stops
              .map((stop) => DropdownMenuItem(value: stop, child: Text(stop)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}