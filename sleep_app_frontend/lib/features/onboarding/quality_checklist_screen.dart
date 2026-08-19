import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
            _buildRadioColumn('Không', 0, groupValue, (v) => vm.updateQ5(mapKey, v)),
            _buildRadioColumn('<1 lần\n/tuần', 1, groupValue, (v) => vm.updateQ5(mapKey, v)),
            _buildRadioColumn('1-2 lần\n/tuần', 2, groupValue, (v) => vm.updateQ5(mapKey, v)),
            _buildRadioColumn('>=3 lần\n/tuần', 3, groupValue, (v) => vm.updateQ5(mapKey, v)),
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

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textMuted),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'STEP 2 OF 3 | Q5',
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
                const SizedBox(height: 8),
                Text(
                  'CÂU HỎI 05',
                  style: Theme.of(
                    context,
                  ).textTheme.displayMedium?.copyWith(fontSize: 24),
                ),
                const SizedBox(height: 16),
                Text(
                  'Tần suất bạn gặp phải những hiện tượng gây khó ngủ trong tháng vừa qua?',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),

                _buildChecklistItem('a. Sau 30 phút nhắm mắt vẫn không thể ngủ được', 'a', vm),
                _buildChecklistItem('b. Tỉnh dậy lúc nửa đêm hoặc sáng sớm', 'b', vm),
                _buildChecklistItem('c. Phải dậy để đi vệ sinh', 'c', vm),
                _buildChecklistItem('d. Không thể hít thở bình thường', 'd', vm),
                _buildChecklistItem('e. Ho hoặc ngáy lớn tiếng khi ngủ', 'e', vm),
                _buildChecklistItem('f. Cảm thấy quá lạnh nên không ngủ được', 'f', vm),
                _buildChecklistItem('g. Cảm thấy quá nóng nên không ngủ được', 'g', vm),
                _buildChecklistItem('h. Gặp ác mộng khó ngủ trở lại', 'h', vm),
                _buildChecklistItem('i. Bị đau nên không ngủ được', 'i', vm),
                
                const Text(
                  'j. Lý do khác khiến bạn khó ngủ',
                  style: TextStyle(
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
                    onChanged: (val) => vm.updateQ5jReason(val),
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Nhập lý do của bạn...',
                      hintStyle: TextStyle(color: AppTheme.textMuted),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                if (vm.q5jOtherReason.trim().isNotEmpty) ...[
                  const SizedBox(height: 20),
                  _buildChecklistItem('Tần suất bạn mất ngủ vì lý do trên?', 'j', vm),
                ],

                const SizedBox(height: 40),
                PrimaryButton(
                  text: 'Tiếp tục ->',
                  onPressed: () {
                    if (!vm.validateQ5()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Vui lòng trả lời tất cả các câu hỏi')),
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
