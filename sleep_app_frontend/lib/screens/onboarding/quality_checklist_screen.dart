import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../widgets/primary_button.dart';
import '../main_app_screen.dart';

class QualityChecklistScreen extends StatefulWidget {
  const QualityChecklistScreen({Key? key}) : super(key: key);

  @override
  State<QualityChecklistScreen> createState() => _QualityChecklistScreenState();
}

class _QualityChecklistScreenState extends State<QualityChecklistScreen> {
  int _selectedOptionA = 0;
  int _selectedOptionB = 0;
  int _selectedOptionC = 0;
  int _selectedOptionD = 0;
  int _selectedOptionE = 0;

  Widget _buildChecklistItem(String title, bool showRadios, int groupValue, [ValueChanged<int>? onChanged]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: AppTheme.textLight, fontSize: 14, fontWeight: FontWeight.w500),
        ),
        if (showRadios) ...[
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildRadioColumn('Không', 0, groupValue, onChanged),
              _buildRadioColumn('Ít hơn\n1 lần', 1, groupValue, onChanged),
              _buildRadioColumn('1-2 lần', 2, groupValue, onChanged),
              _buildRadioColumn('>=3 lần', 3, groupValue, onChanged),
            ],
          ),
        ],
        const SizedBox(height: 20),
        Divider(color: Colors.white.withOpacity(0.05)),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildRadioColumn(String label, int value, int groupValue, ValueChanged<int>? onChanged) {
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
          onTap: () {
            if (onChanged != null) onChanged(value);
          },
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: isSelected ? AppTheme.primaryColor : AppTheme.textMuted, width: 2),
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textMuted),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            const Icon(Icons.pie_chart, color: AppTheme.textMuted, size: 16),
            const SizedBox(width: 8),
            const Text('Digital Pill', style: TextStyle(color: AppTheme.textMuted, fontSize: 14)),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: AppTheme.cardLightColor,
              radius: 16,
              child: Image.asset('assets/images/logo.png', width: 20, height: 20, errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 16)),
            ),
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('SURVEY | STEP 5 OF 5', style: TextStyle(color: AppTheme.primaryColor, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                    Text('50%', style: TextStyle(color: AppTheme.primaryColor.withOpacity(0.8), fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Chất lượng giấc ngủ', style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 24)),
                const SizedBox(height: 30),
                Text(
                  '5. Tần suất bạn gặp phải những hiện tượng gây khó ngủ trong tháng vừa qua?',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5, fontSize: 16, color: Colors.white),
                ),
                const SizedBox(height: 30),
                
                _buildChecklistItem('a. Sau 30 phút nhắm mắt vẫn không thể ngủ được', true, _selectedOptionA, (val) => setState(() => _selectedOptionA = val)),
                _buildChecklistItem('b. Tỉnh dậy lúc nửa đêm hoặc sáng sớm', true, _selectedOptionB, (val) => setState(() => _selectedOptionB = val)),
                _buildChecklistItem('c. Phải dậy để đi vệ sinh', true, _selectedOptionC, (val) => setState(() => _selectedOptionC = val)),
                _buildChecklistItem('d. Khó thở', true, _selectedOptionD, (val) => setState(() => _selectedOptionD = val)),
                _buildChecklistItem('e. Ác mộng', true, _selectedOptionE, (val) => setState(() => _selectedOptionE = val)),
                
                const Text('f. Lý do khác', style: TextStyle(color: AppTheme.textLight, fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.cardLightColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: const TextField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Nhập lý do của bạn...',
                      hintStyle: TextStyle(color: AppTheme.textMuted),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Hủy bỏ', style: TextStyle(color: AppTheme.textMuted, fontSize: 16)),
                    ),
                    Expanded(
                      flex: 2,
                      child: PrimaryButton(
                        text: 'Tiếp tục',
                        onPressed: () {
                           Navigator.pushAndRemoveUntil(
                             context, 
                             MaterialPageRoute(builder: (_) => const MainAppScreen()),
                             (route) => false,
                           );
                        },
                      ),
                    ),
                  ],
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
