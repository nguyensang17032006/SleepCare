import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sleep_app_frontend/l10n/app_localizations.dart';
import '../../../core/theme/theme.dart';
import '../../../core/app/widget/primary_button.dart';
import 'viewmodels/daily_short_vm.dart';

class DailyShortSurveyScreen extends StatefulWidget {
  const DailyShortSurveyScreen({super.key});

  @override
  State<DailyShortSurveyScreen> createState() => _DailyShortSurveyScreenState();
}

class _DailyShortSurveyScreenState extends State<DailyShortSurveyScreen> {
  Future<void> _selectTime(
    BuildContext context,
    TimeOfDay? initialTime,
    ValueChanged<TimeOfDay> onTimeSelected,
  ) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppTheme.primaryColor,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      onTimeSelected(picked);
    }
  }

  Widget _buildTimeSelector({
    required String title,
    required TimeOfDay? time,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppTheme.textLight,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.cardLightColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 5)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  time != null
                      ? time.format(context)
                      : AppLocalizations.of(context)!.dailySurveySelectTime,
                  style: TextStyle(
                    color: time != null ? Colors.white : AppTheme.textMuted,
                    fontSize: 16,
                  ),
                ),
                const Icon(Icons.access_time, color: AppTheme.textMuted),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildInputField({
    required String title,
    required String hint,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppTheme.textLight,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.cardLightColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: .05)),
          ),
          child: TextField(
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: AppTheme.textMuted),
              border: InputBorder.none,
            ),
            onChanged: onChanged,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildRadioGroup({
    required String title,
    required List<String> options,
    required int? groupValue,
    required ValueChanged<int> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppTheme.textLight,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(options.length, (index) {
            bool isSelected = index == groupValue;
            return Expanded(
              child: Column(
                children: [
                  Text(
                    options[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isSelected
                          ? AppTheme.primaryColor
                          : AppTheme.textMuted,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => onChanged(index),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.primaryColor
                              : AppTheme.textMuted,
                          width: 2,
                        ),
                        color: isSelected
                            ? AppTheme.primaryColor
                            : Colors.transparent,
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DailyShortViewModel>();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppTheme.textMuted),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.dailySurveyTitle,
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
                const SizedBox(height: 10),
                Text(
                  l10n.dailySurveyGreeting,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),

                _buildTimeSelector(
                  title: l10n.dailySurveyQ1,
                  time: vm.bedtime,
                  onTap: () =>
                      _selectTime(context, vm.bedtime, vm.updateBedtime),
                ),

                _buildInputField(
                  title: l10n.dailySurveyQ2,
                  hint: l10n.dailySurveyExample15,
                  onChanged: (val) =>
                      vm.updateSleepLatency(int.tryParse(val) ?? 0),
                ),

                _buildTimeSelector(
                  title: l10n.dailySurveyQ3,
                  time: vm.wakeUpTime,
                  onTap: () =>
                      _selectTime(context, vm.wakeUpTime, vm.updateWakeUpTime),
                ),

                _buildInputField(
                  title: l10n.dailySurveyQ4,
                  hint: l10n.dailySurveyExample75,
                  onChanged: (val) =>
                      vm.updateHoursSlept(double.tryParse(val) ?? 0),
                ),

                _buildInputField(
                  title: l10n.dailySurveyQ5,
                  hint: l10n.dailySurveyExampleCount,
                  onChanged: (val) =>
                      vm.updateAwakeningsCount(int.tryParse(val) ?? 0),
                ),

                _buildRadioGroup(
                  title: l10n.dailySurveyQ6,
                  options: [
                    l10n.dailySurveyVeryGood,
                    l10n.dailySurveyFairlyGood,
                    l10n.dailySurveyFairlyBad,
                    l10n.dailySurveyVeryBad,
                  ],
                  groupValue: vm.sleepQuality,
                  onChanged: vm.updateSleepQuality,
                ),

                const SizedBox(height: 20),
                vm.isSubmitting
                    ? const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.primaryColor,
                          ),
                        ),
                      )
                    : PrimaryButton(
                        text: l10n.dailySurveySave,
                        onPressed: () async {
                          if (!vm.isValid()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.dailySurveyErrorFillAll),
                              ),
                            );
                            return;
                          }
                          final success = await vm.submitDailySurvey();
                          if (success && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l10n.dailySurveySuccess)),
                            );
                            Navigator.pop(context);
                          } else if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.dailySurveyErrorGeneric),
                              ),
                            );
                          }
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
