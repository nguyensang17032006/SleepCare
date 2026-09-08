import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sleep_app_frontend/l10n/app_localizations.dart';
import '../../core/app/main_layout.dart';
import '../../core/theme/theme.dart';
import '../../core/app/widget/primary_button.dart';
import 'viewmodels/questionnaire_vm.dart';

class QuestionnaireScreen3 extends StatefulWidget {
  const QuestionnaireScreen3({super.key});

  @override
  State<QuestionnaireScreen3> createState() => _QuestionnaireScreen3State();
}

class _QuestionnaireScreen3State extends State<QuestionnaireScreen3> {
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
            return _buildRadioColumn(
              options[index],
              index,
              groupValue,
              onChanged,
            );
          }),
        ),
        const SizedBox(height: 20),
        Divider(color: Colors.white.withValues(alpha: 0.05)),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildRadioColumn(
    String label,
    int value,
    int? groupValue,
    ValueChanged<int> onChanged,
  ) {
    bool isSelected = value == groupValue;
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? AppTheme.primaryColor : AppTheme.textMuted,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => onChanged(value),
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
                color: isSelected ? AppTheme.primaryColor : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<QuestionnaireViewModel>();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textMuted),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.qStep3,
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
                const SizedBox(height: 30),

                _buildRadioGroup(
                  title: l10n.q6Title,
                  options: [l10n.qFreq0, l10n.qFreq1, l10n.qFreq2, l10n.qFreq3],
                  groupValue: vm.q6,
                  onChanged: vm.updateQ6,
                ),

                _buildRadioGroup(
                  title: l10n.q7Title,
                  options: [l10n.qFreq0, l10n.qFreq1, l10n.qFreq2, l10n.qFreq3],
                  groupValue: vm.q7,
                  onChanged: vm.updateQ7,
                ),

                _buildRadioGroup(
                  title: l10n.q8Title,
                  options: [l10n.q8Opt0, l10n.q8Opt1, l10n.q8Opt2, l10n.q8Opt3],
                  groupValue: vm.q8,
                  onChanged: vm.updateQ8,
                ),

                _buildRadioGroup(
                  title: l10n.q9Title,
                  options: [
                    l10n.dailySurveyVeryGood,
                    l10n.dailySurveyFairlyGood,
                    l10n.dailySurveyFairlyBad,
                    l10n.dailySurveyVeryBad,
                  ],
                  groupValue: vm.q9,
                  onChanged: vm.updateQ9,
                ),

                //10
                _buildRadioGroup(
                  title: l10n.q10Title,
                  options: [l10n.qYes, l10n.qNo],
                  groupValue: vm.q10HasPartner,
                  onChanged: vm.updateQ10HasPartner,
                ),
                if (vm.q10HasPartner == 0) ...[
                  Text(
                    l10n.q10SubTitle,
                    style: const TextStyle(
                      color: AppTheme.textLight,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildRadioGroup(
                    title: l10n.q10a,
                    options: [
                      l10n.qFreq0,
                      l10n.qFreq1,
                      l10n.qFreq2,
                      l10n.qFreq3,
                    ],
                    groupValue: vm.q10['a'],
                    onChanged: (v) => vm.updateQ10('a', v),
                  ),
                  _buildRadioGroup(
                    title: l10n.q10b,
                    options: [
                      l10n.qFreq0,
                      l10n.qFreq1,
                      l10n.qFreq2,
                      l10n.qFreq3,
                    ],
                    groupValue: vm.q10['b'],
                    onChanged: (v) => vm.updateQ10('b', v),
                  ),
                  _buildRadioGroup(
                    title: l10n.q10c,
                    options: [
                      l10n.qFreq0,
                      l10n.qFreq1,
                      l10n.qFreq2,
                      l10n.qFreq3,
                    ],
                    groupValue: vm.q10['c'],
                    onChanged: (v) => vm.updateQ10('c', v),
                  ),
                  _buildRadioGroup(
                    title: l10n.q10d,
                    options: [
                      l10n.qFreq0,
                      l10n.qFreq1,
                      l10n.qFreq2,
                      l10n.qFreq3,
                    ],
                    groupValue: vm.q10['d'],
                    onChanged: (v) => vm.updateQ10('d', v),
                  ),

                  Text(
                    l10n.q10eTitle,
                    style: const TextStyle(
                      color: AppTheme.textLight,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.cardLightColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: .05),
                      ),
                    ),
                    child: TextField(
                      onChanged: vm.updateQ10eReason,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: l10n.q10eHint,
                        hintStyle: const TextStyle(color: AppTheme.textMuted),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  if (vm.q10eOtherReason.trim().isNotEmpty) ...[
                    const SizedBox(height: 20),
                    _buildRadioGroup(
                      title: l10n.q10eFreq,
                      options: [
                        l10n.qFreq0,
                        l10n.qFreq1,
                        l10n.qFreq2,
                        l10n.qFreq3,
                      ],
                      groupValue: vm.q10['e'],
                      onChanged: (v) => vm.updateQ10('e', v),
                    ),
                  ],
                ],

                const SizedBox(height: 40),
                vm.isSubmitting
                    ? const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.primaryColor,
                          ),
                        ),
                      )
                    : PrimaryButton(
                        text: l10n.qFinish,
                        onPressed: () async {
                          final success = await vm.submitQuestionnaire();
                          if (!success) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(l10n.qErrorGeneric)),
                              );
                            }
                            return;
                          }

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${l10n.qPsqiResult(vm.finalPsqiScore ?? 0)}\n'
                                  '${vm.finalPsqiScore != null && vm.finalPsqiScore! > 5 ? l10n.qPsqiBad : l10n.qPsqiGood}',
                                ),
                                duration: const Duration(seconds: 4),
                              ),
                            );

                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const MainAppScreen(),
                              ),
                              (route) => false,
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
