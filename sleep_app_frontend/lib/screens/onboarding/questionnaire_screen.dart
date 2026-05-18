import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../widgets/primary_button.dart';
import 'quality_checklist_screen.dart';

class QuestionnaireScreen extends StatefulWidget {
  const QuestionnaireScreen({Key? key}) : super(key: key);

  @override
  State<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  Widget _buildQuestion(String title, String inputHint, bool isTime) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: AppTheme.textLight, fontSize: 13, height: 1.5, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: AppTheme.cardLightColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(inputHint, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              Icon(isTime ? Icons.access_time : Icons.edit, color: AppTheme.textMuted, size: 20),
            ],
          ),
        ),
        const SizedBox(height: 24),
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
        title: const Text('STEP 1 OF 2 | Q1-Q4', style: TextStyle(color: AppTheme.textMuted, fontSize: 12, letterSpacing: 1.2)),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Save Questionnaire', style: TextStyle(color: AppTheme.textMuted, fontSize: 12)),
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
                Text('Hi, welcome to\nSleepCare', style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 28)),
                const SizedBox(height: 12),
                Text(
                  "Let's start by understanding your sleep\npatterns over the last month.",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
                ),
                const SizedBox(height: 30),
                
                const Text('QUESTION 01', style: TextStyle(color: AppTheme.primaryColor, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                const SizedBox(height: 8),
                _buildQuestion('Trong tháng vừa rồi, bạn thường bắt đầu\nđi ngủ lúc mấy giờ?', '10:30 PM', true),

                const Text('QUESTION 02', style: TextStyle(color: AppTheme.primaryColor, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                const SizedBox(height: 8),
                _buildQuestion('Trong tháng vừa rồi, mỗi đêm bạn\nthường mất khoảng bao nhiêu phút để\nngủ được?', '15 phút', false),

                const Text('QUESTION 03', style: TextStyle(color: AppTheme.primaryColor, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                const SizedBox(height: 8),
                _buildQuestion('Trong tháng vừa rồi, bạn thường thức\ndậy lúc mấy giờ?', '06:30 AM', true),

                const Text('QUESTION 04', style: TextStyle(color: AppTheme.primaryColor, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                const SizedBox(height: 8),
                _buildQuestion('Trong tháng vừa rồi, mỗi đêm bạn\nthường ngủ được khoảng bao tiếng?', '7.5 tiếng', false),

                const SizedBox(height: 20),
                PrimaryButton(
                  text: 'Next Step ->',
                  onPressed: () {
                     Navigator.push(context, MaterialPageRoute(builder: (_) => const QualityChecklistScreen()));
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
