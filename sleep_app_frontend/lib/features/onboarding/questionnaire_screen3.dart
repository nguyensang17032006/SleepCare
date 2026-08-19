import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
            return _buildRadioColumn(options[index], index, groupValue, onChanged);
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
      ),
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
          'STEP 3 OF 3 | Q6-Q10',
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
                const SizedBox(height: 30),
                
                _buildRadioGroup(
                  title: '6. Bạn đánh giá chất lượng giấc ngủ trong tháng vừa qua như thế nào?',
                  options: ['Rất tốt', 'Khá tốt', 'Khá tệ', 'Rất tệ'],
                  groupValue: vm.q6,
                  onChanged: vm.updateQ6,
                ),
                
                _buildRadioGroup(
                  title: '7. Tần suất bạn uống thuốc (cả kê đơn và không) để dễ ngủ hơn?',
                  options: ['Không', '<1 lần\n/tuần', '1-2 lần\n/tuần', '>=3 lần\n/tuần'],
                  groupValue: vm.q7,
                  onChanged: vm.updateQ7,
                ),
                
                _buildRadioGroup(
                  title: '8. Tần suất bạn gặp khó khăn giữ tỉnh táo khi lái xe, ăn uống, xã hội?',
                  options: ['Không', '<1 lần\n/tuần', '1-2 lần\n/tuần', '>=3 lần\n/tuần'],
                  groupValue: vm.q8,
                  onChanged: vm.updateQ8,
                ),
                
                _buildRadioGroup(
                  title: '9. Bạn cảm thấy việc hăng hái thực hiện mọi việc khó khăn thế nào?',
                  options: ['Không vấn đề', 'Hơi vấn đề', 'Khá khó khăn', 'Rất khó khăn'],
                  groupValue: vm.q9,
                  onChanged: vm.updateQ9,
                ),
                
                const Text(
                  '10. Nếu bạn có bạn cùng phòng, họ có nhận thấy bạn:',
                  style: TextStyle(
                    color: AppTheme.textLight,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                _buildRadioGroup(
                  title: 'a. Ngáy to',
                  options: ['Không', '<1 lần\n/tuần', '1-2 lần\n/tuần', '>=3 lần\n/tuần'],
                  groupValue: vm.q10['a'],
                  onChanged: (v) => vm.updateQ10('a', v),
                ),
                _buildRadioGroup(
                  title: 'b. Ngưng thở một lúc khi ngủ',
                  options: ['Không', '<1 lần\n/tuần', '1-2 lần\n/tuần', '>=3 lần\n/tuần'],
                  groupValue: vm.q10['b'],
                  onChanged: (v) => vm.updateQ10('b', v),
                ),
                _buildRadioGroup(
                  title: 'c. Chân co giật khi ngủ',
                  options: ['Không', '<1 lần\n/tuần', '1-2 lần\n/tuần', '>=3 lần\n/tuần'],
                  groupValue: vm.q10['c'],
                  onChanged: (v) => vm.updateQ10('c', v),
                ),
                _buildRadioGroup(
                  title: 'd. Bị ngã khỏi giường',
                  options: ['Không', '<1 lần\n/tuần', '1-2 lần\n/tuần', '>=3 lần\n/tuần'],
                  groupValue: vm.q10['d'],
                  onChanged: (v) => vm.updateQ10('d', v),
                ),
                
                const Text(
                  'e. Tình trạng đặc biệt khác',
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
                    onChanged: vm.updateQ10eReason,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Nhập tình trạng khác...',
                      hintStyle: TextStyle(color: AppTheme.textMuted),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                if (vm.q10eOtherReason.trim().isNotEmpty) ...[
                  const SizedBox(height: 20),
                  _buildRadioGroup(
                    title: 'Tần suất xuất hiện?',
                    options: ['Không', '<1 lần\n/tuần', '1-2 lần\n/tuần', '>=3 lần\n/tuần'],
                    groupValue: vm.q10['e'],
                    onChanged: (v) => vm.updateQ10('e', v),
                  ),
                ],

                const SizedBox(height: 40),
                PrimaryButton(
                  text: 'Hoàn thành',
                  onPressed: () {
                    if (!vm.calculatePSQI()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Vui lòng trả lời tất cả các câu hỏi')),
                      );
                      return;
                    }
                    
                    // Hiển thị điểm số cho user thấy (có thể lưu DB sau này)
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Điểm chất lượng giấc ngủ (PSQI) của bạn: ${vm.finalPsqiScore}\n'
                            '${vm.finalPsqiScore != null && vm.finalPsqiScore! > 5 ? "Giấc ngủ của bạn có vẻ kém, cần cải thiện!" : "Giấc ngủ của bạn khá tốt!"}'),
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
