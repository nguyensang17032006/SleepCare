import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/theme.dart';
import '../../core/app/widget/primary_button.dart';
import 'quality_checklist_screen.dart';
import 'viewmodels/questionnaire_vm.dart';

class QuestionnaireScreen extends StatefulWidget {
  const QuestionnaireScreen({super.key});

  @override
  State<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  final TextEditingController _q2Controller = TextEditingController();
  final TextEditingController _q4Controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final vm = context.read<QuestionnaireViewModel>();
    if (vm.sleepLatencyMinutes != null) {
      _q2Controller.text = vm.sleepLatencyMinutes.toString();
    }
    if (vm.hoursSlept != null) {
      _q4Controller.text = vm.hoursSlept.toString();
    }
  }

  @override
  void dispose() {
    _q2Controller.dispose();
    _q4Controller.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context, bool isBedtime) async {
    final vm = context.read<QuestionnaireViewModel>();
    final initialTime = isBedtime 
        ? (vm.bedtime ?? const TimeOfDay(hour: 22, minute: 30)) 
        : (vm.wakeUpTime ?? const TimeOfDay(hour: 6, minute: 30));
        
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppTheme.primaryColor,
              onPrimary: Colors.white,
              surface: AppTheme.cardLightColor,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      if (isBedtime) {
        vm.updateBedtime(picked);
      } else {
        vm.updateWakeUpTime(picked);
      }
    }
  }

  Widget _buildTimeQuestion(String title, String? value, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppTheme.textLight,
            fontSize: 14,
            height: 1.5,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: AppTheme.cardLightColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value ?? 'Chọn thời gian',
                  style: TextStyle(
                    color: value != null ? Colors.white : AppTheme.textMuted,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(
                  Icons.access_time,
                  color: AppTheme.textMuted,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildInputQuestion(String title, String hint, TextEditingController controller, ValueChanged<String> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppTheme.textLight,
            fontSize: 14,
            height: 1.5,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.cardLightColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: AppTheme.textMuted, fontSize: 16, fontWeight: FontWeight.normal),
              border: InputBorder.none,
              suffixIcon: const Icon(Icons.edit, color: AppTheme.textMuted, size: 20),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<QuestionnaireViewModel>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'STEP 1 OF 3 | Q1-Q4',
          style: TextStyle(
            color: AppTheme.textMuted,
            fontSize: 12,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi, welcome to\nSleepCare',
                  style: Theme.of(
                    context,
                  ).textTheme.displayMedium?.copyWith(fontSize: 28),
                ),
                const SizedBox(height: 12),
                Text(
                  "Hãy cho chúng tôi biết về giấc ngủ của bạn\ntrong tháng vừa qua.",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(height: 1.5),
                ),
                const SizedBox(height: 30),

                const Text(
                  'CÂU HỎI 01',
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                _buildTimeQuestion(
                  'Trong tháng vừa rồi, bạn thường bắt đầu\nđi ngủ lúc mấy giờ?',
                  vm.bedtime?.format(context),
                  () => _selectTime(context, true),
                ),

                const Text(
                  'CÂU HỎI 02',
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                _buildInputQuestion(
                  'Mỗi đêm bạn thường mất khoảng bao\nnhiêu phút để ngủ được?',
                  'Ví dụ: 15',
                  _q2Controller,
                  (value) {
                    final mins = int.tryParse(value);
                    if (mins != null) {
                      vm.updateSleepLatency(mins);
                    }
                  },
                ),

                const Text(
                  'CÂU HỎI 03',
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                _buildTimeQuestion(
                  'Bạn thường thức dậy lúc mấy giờ?',
                  vm.wakeUpTime?.format(context),
                  () => _selectTime(context, false),
                ),

                const Text(
                  'CÂU HỎI 04',
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                _buildInputQuestion(
                  'Mỗi đêm bạn thường ngủ thực tế\nđược mấy tiếng?',
                  'Ví dụ: 7.5',
                  _q4Controller,
                  (value) {
                    final hours = double.tryParse(value);
                    if (hours != null) {
                      vm.updateHoursSlept(hours);
                    }
                  },
                ),

                const SizedBox(height: 20),
                PrimaryButton(
                  text: 'Tiếp tục ->',
                  onPressed: () {
                    if (vm.bedtime == null || vm.sleepLatencyMinutes == null || vm.wakeUpTime == null || vm.hoursSlept == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Vui lòng trả lời đầy đủ các câu hỏi')),
                      );
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const QualityChecklistScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
