import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// STEP 5 - "Schedule" calendar screen.
/// Shows a two-month calendar. Days that already have a roster are marked
/// blue; today is green. Tapping a marked day opens a bottom sheet with
/// Update Roster / Cancel Login / Cancel Logout / Cancel Both actions
/// (this mirrors the "Download and Manage your daily office commute" flow).
class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  // Days (in August 2024) that already have a roster scheduled.
  final Set<int> _rosteredAugustDays = {20, 21, 22, 23, 26, 27, 28, 29, 30};
  final int _today = 19;

  void _openDayActionsSheet(int day, String month) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              color: AppColors.primaryBlue,
              child: Text(
                '$day-${month.substring(0, 3)}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            _sheetAction('Update Roster', () {}),
            const Divider(height: 1),
            _sheetAction('Cancel Login', () {}),
            const Divider(height: 1),
            _sheetAction('Cancel Logout', () {}),
            const Divider(height: 1),
            _sheetAction('Cancel Both', () {}),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }

  Widget _sheetAction(String label, VoidCallback onTap) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(label, style: const TextStyle(fontSize: 16, color: AppColors.textDark)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primaryBlue),
        title: const Text('Schedule', style: TextStyle(color: AppColors.textDark)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildMonthCalendar('August 2024', 2024, 8),
          const SizedBox(height: 24),
          _buildMonthCalendar('September 2024', 2024, 9),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.danger,
        onPressed: () {
          // TODO: open create-roster / add-schedule flow.
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SizedBox(
            width: 140,
            height: 44,
            child: ElevatedButton(
              onPressed: () {
                // TODO: mark selected day as No Show.
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.danger,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
              child: const Text('No Show', style: TextStyle(color: Colors.white)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMonthCalendar(String title, int year, int month) {
    final int daysInMonth = DateTime(year, month + 1, 0).day;
    final int firstWeekday = DateTime(year, month, 1).weekday % 7; // 0 = Sun

    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _WeekdayLabel('Sun'), _WeekdayLabel('Mon'), _WeekdayLabel('Tue'),
            _WeekdayLabel('Wed'), _WeekdayLabel('Thu'), _WeekdayLabel('Fri'),
            _WeekdayLabel('Sat'),
          ],
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
          itemCount: firstWeekday + daysInMonth,
          itemBuilder: (context, index) {
            if (index < firstWeekday) return const SizedBox.shrink();
            final day = index - firstWeekday + 1;
            final bool isToday = month == 8 && day == _today;
            final bool isRostered = month == 8 && _rosteredAugustDays.contains(day);

            return GestureDetector(
              onTap: isRostered ? () => _openDayActionsSheet(day, title.split(' ')[0]) : null,
              child: Center(
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isToday
                        ? AppColors.success
                        : isRostered
                            ? AppColors.primaryBlue
                            : Colors.transparent,
                  ),
                  child: Center(
                    child: Text(
                      '$day',
                      style: TextStyle(
                        color: (isToday || isRostered) ? Colors.white : AppColors.textDark,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _WeekdayLabel extends StatelessWidget {
  final String label;
  const _WeekdayLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(label, style: const TextStyle(color: AppColors.textGrey, fontSize: 12));
  }
}
