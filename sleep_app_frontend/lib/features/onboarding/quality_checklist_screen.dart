import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sleep_app_frontend/l10n/app_localizations.dart';
import '../../core/theme/theme.dart';
import '../../core/app/widget/primary_button.dart';
import 'viewmodels/questionnaire_vm.dart';
import 'questionnaire_screen3.dart';

class QualityChecklistScreen extends StatefulWidget {
  const QualityChecklistScreen({super.key});

  @override
  State<QualityChecklistScreen> createState() => _QualityChecklistScreenState();
}

class _QualityChecklistScreenState extends State<QualityChecklistScreen> {
  Widget _buildChecklistItem(
    String title,
    String mapKey,
    QuestionnaireViewModel vm,
  ) {
    int? groupValue = vm.q5[mapKey];

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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildRadioColumn(
              AppLocalizations.of(context)!.qFreq0,
              0,
              groupValue,
              (v) => vm.updateQ5(mapKey, v),
            ),
            _buildRadioColumn(
              AppLocalizations.of(context)!.qFreq1,
              1,
              groupValue,
              (v) => vm.updateQ5(mapKey, v),
            ),
            _buildRadioColumn(
              AppLocalizations.of(context)!.qFreq2,
              2,
              groupValue,
              (v) => vm.updateQ5(mapKey, v),
            ),
            _buildRadioColumn(
              AppLocalizations.of(context)!.qFreq3,
              3,
              groupValue,
              (v) => vm.updateQ5(mapKey, v),
            ),
          ],
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
    return Column(
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
                color: isSelected ? AppTheme.primaryColor : AppTheme.textMuted,
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
          l10n.qStep2,
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
                const SizedBox(height: 8),
                Text(
                  l10n.qQuestion5,
                  style: Theme.of(
                    context,
                  ).textTheme.displayMedium?.copyWith(fontSize: 24),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.q5Desc,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),

                _buildChecklistItem(l10n.q5a, 'a', vm),
                _buildChecklistItem(l10n.q5b, 'b', vm),
                _buildChecklistItem(l10n.q5c, 'c', vm),
                _buildChecklistItem(l10n.q5d, 'd', vm),
                _buildChecklistItem(l10n.q5e, 'e', vm),
                _buildChecklistItem(l10n.q5f, 'f', vm),
                _buildChecklistItem(l10n.q5g, 'g', vm),
                _buildChecklistItem(l10n.q5h, 'h', vm),
                _buildChecklistItem(l10n.q5i, 'i', vm),

                Text(
                  l10n.q5jTitle,
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
                    onChanged: (val) => vm.updateQ5jReason(val),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: l10n.q5jHint,
                      hintStyle: const TextStyle(color: AppTheme.textMuted),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                if (vm.q5jOtherReason.trim().isNotEmpty) ...[
                  const SizedBox(height: 20),
                  _buildChecklistItem(l10n.q5jFreq, 'j', vm),
                ],

                const SizedBox(height: 40),
                PrimaryButton(
                  text: l10n.qContinue,
                  onPressed: () {
                    if (!vm.validateQ5()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.qErrorFillAll)),
                      );
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const QuestionnaireScreen3(),
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
