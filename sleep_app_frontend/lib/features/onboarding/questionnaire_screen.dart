import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sleep_app_frontend/l10n/app_localizations.dart';
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
                  value ?? AppLocalizations.of(context)!.q1SelectTime,
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

  Widget _buildInputQuestion(
    String title,
    String hint,
    TextEditingController controller,
    ValueChanged<String> onChanged,
  ) {
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
              hintStyle: const TextStyle(
                color: AppTheme.textMuted,
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
              border: InputBorder.none,
              suffixIcon: const Icon(
                Icons.edit,
                color: AppTheme.textMuted,
                size: 20,
              ),
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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          l10n.qStep1,
          style: const TextStyle(
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
                  l10n.qWelcome,
                  style: Theme.of(
                    context,
                  ).textTheme.displayMedium?.copyWith(fontSize: 28),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.qIntro,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(height: 1.5),
                ),
                const SizedBox(height: 30),

                Text(
                  l10n.qQuestion1,
                  style: const TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                _buildTimeQuestion(
                  l10n.q1Desc,
                  vm.bedtime?.format(context),
                  () => _selectTime(context, true),
                ),

                Text(
                  l10n.qQuestion2,
                  style: const TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                _buildInputQuestion(l10n.q2Desc, l10n.q2Hint, _q2Controller, (
                  value,
                ) {
                  final mins = int.tryParse(value);
                  if (mins != null) {
                    vm.updateSleepLatency(mins);
                  }
                }),

                Text(
                  l10n.qQuestion3,
                  style: const TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                _buildTimeQuestion(
                  l10n.q3Desc,
                  vm.wakeUpTime?.format(context),
                  () => _selectTime(context, false),
                ),

                Text(
                  l10n.qQuestion4,
                  style: const TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                _buildInputQuestion(l10n.q4Desc, l10n.q4Hint, _q4Controller, (
                  value,
                ) {
                  final hours = double.tryParse(value);
                  if (hours != null) {
                    vm.updateHoursSlept(hours);
                  }
                }),

                const SizedBox(height: 20),
                PrimaryButton(
                  text: l10n.qContinue,
                  onPressed: () {
                    if (vm.bedtime == null ||
                        vm.sleepLatencyMinutes == null ||
                        vm.wakeUpTime == null ||
                        vm.hoursSlept == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.qErrorFillAll)),
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
