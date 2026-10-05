import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sleep_app_frontend/core/app/main_layout.dart';
import 'package:sleep_app_frontend/core/theme/theme.dart';

import 'package:sleep_app_frontend/features/onboarding/domain/entities/assessment_requirement.dart';
import 'package:sleep_app_frontend/features/onboarding/domain/entities/questionnaire_question.dart';
import 'package:sleep_app_frontend/features/onboarding/presentation/bloc/questionnaire/questionnaire_bloc.dart';
import 'package:sleep_app_frontend/features/onboarding/presentation/bloc/questionnaire/questionnaire_event.dart';
import 'package:sleep_app_frontend/features/onboarding/presentation/bloc/questionnaire/questionnaire_state.dart';

class QuestionnaireScreen extends StatefulWidget {
  const QuestionnaireScreen({super.key});

  @override
  State<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  @override
  void initState() {
    super.initState();

    context.read<QuestionnaireBloc>().add(const QuestionnaireStarted());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QuestionnaireBloc, QuestionnaireState>(
      listener: (context, state) {
        if (state.status == QuestionnaireStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã lưu khảo sát thành công')),
          );

          // Sau khi hoàn thành khảo sát -> vào MainAppScreen
          // để giữ Bottom Navigation Bar.
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const MainAppScreen()),
            (route) => false,
          );
        }

        if (state.status == QuestionnaireStatus.failure &&
            state.questions.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Không thể lưu khảo sát'),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Khảo sát giấc ngủ đầy đủ')),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, QuestionnaireState state) {
    if (state.status == QuestionnaireStatus.initial ||
        state.status == QuestionnaireStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == QuestionnaireStatus.failure &&
        state.questions.isEmpty) {
      return _buildError(context, state);
    }

    if (state.questions.isEmpty) {
      return const Center(child: Text('Chưa có câu hỏi cho khảo sát này'));
    }

    final requiredQuestions = state.questions
        .where((question) => question.isRequired)
        .toList();

    final answeredCount = requiredQuestions.where((question) {
      final answer = state.answers[question.id];

      return answer != null && !(answer is String && answer.trim().isEmpty);
    }).length;

    final progress = requiredQuestions.isEmpty
        ? 0.0
        : answeredCount / requiredQuestions.length;

    return Column(
      children: [
        _buildHeader(state, answeredCount, requiredQuestions.length, progress),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.questions.length + 1,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              if (index == state.questions.length) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: state.status == QuestionnaireStatus.submitting
                          ? null
                          : () {
                              if (!state.isComplete) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Vui lòng trả lời đầy đủ các câu bắt buộc',
                                    ),
                                  ),
                                );

                                return;
                              }

                              context.read<QuestionnaireBloc>().add(
                                const QuestionnaireSubmitted(),
                              );
                            },
                      child: state.status == QuestionnaireStatus.submitting
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Hoàn thành khảo sát'),
                    ),
                  ),
                );
              }

              final question = state.questions[index];

              return _buildQuestionCard(
                index: index,
                question: question,
                answer: state.answers[question.id],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(
    QuestionnaireState state,
    int answeredCount,
    int requiredCount,
    double progress,
  ) {
    final assessmentName =
        state.requirement == AssessmentRequirement.baselineFull
        ? 'Khảo sát lần đầu'
        : 'Đánh giá lại sau 30 ngày';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            assessmentName,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text('Đã trả lời $answeredCount/$requiredCount câu bắt buộc'),
          const SizedBox(height: 10),
          LinearProgressIndicator(value: progress),
        ],
      ),
    );
  }

  Widget _buildQuestionCard({
    required int index,
    required QuestionnaireQuestion question,
    required Object? answer,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    '${index + 1}. ${question.questionText}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                ),
                if (question.isRequired)
                  const Text(
                    ' *',
                    style: TextStyle(color: Colors.redAccent, fontSize: 18),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            _buildAnswerInput(question: question, answer: answer),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerInput({
    required QuestionnaireQuestion question,
    required Object? answer,
  }) {
    if (question.options.isNotEmpty) {
      return _buildOptions(question: question, answer: answer);
    }

    switch (question.questionType) {
      case 'time':
        return _buildTimeInput(question: question, answer: answer);

      case 'number':
      case 'integer':
      case 'duration_minutes':
        return _buildNumberInput(question: question, answer: answer);

      case 'text':
      default:
        return _buildTextInput(question: question, answer: answer);
    }
  }

  Widget _buildOptions({
    required QuestionnaireQuestion question,
    required Object? answer,
  }) {
    return Column(
      children: question.options.map((option) {
        final selected = answer == option.value;

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              _changeAnswer(questionId: question.id, value: option.value);
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: selected
                    ? AppTheme.primaryColor.withValues(alpha: 0.20)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: selected ? AppTheme.primaryColor : AppTheme.textMuted,
                  width: selected ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    selected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    color: selected
                        ? AppTheme.primaryColor
                        : AppTheme.textMuted,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      option.label,
                      style: TextStyle(
                        color: selected ? Colors.white : AppTheme.textMuted,
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTimeInput({
    required QuestionnaireQuestion question,
    required Object? answer,
  }) {
    return InkWell(
      onTap: () => _selectTime(question, answer),
      borderRadius: BorderRadius.circular(8),
      child: InputDecorator(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.access_time),
        ),
        child: Text(answer?.toString() ?? 'Chọn thời gian'),
      ),
    );
  }

  Widget _buildNumberInput({
    required QuestionnaireQuestion question,
    required Object? answer,
  }) {
    return TextFormField(
      key: ValueKey(question.id),
      initialValue: answer?.toString(),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: const InputDecoration(
        hintText: 'Nhập giá trị',
        border: OutlineInputBorder(),
      ),
      onChanged: (value) {
        _changeAnswer(questionId: question.id, value: num.tryParse(value));
      },
    );
  }

  Widget _buildTextInput({
    required QuestionnaireQuestion question,
    required Object? answer,
  }) {
    return TextFormField(
      key: ValueKey(question.id),
      initialValue: answer?.toString(),
      maxLines: question.questionType == 'text' ? 3 : 1,
      decoration: const InputDecoration(
        hintText: 'Nhập câu trả lời',
        border: OutlineInputBorder(),
      ),
      onChanged: (value) {
        _changeAnswer(questionId: question.id, value: value);
      },
    );
  }

  Future<void> _selectTime(
    QuestionnaireQuestion question,
    Object? answer,
  ) async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: _parseTime(answer) ?? TimeOfDay.now(),
    );

    if (selectedTime == null || !mounted) {
      return;
    }

    final hour = selectedTime.hour.toString().padLeft(2, '0');
    final minute = selectedTime.minute.toString().padLeft(2, '0');

    _changeAnswer(questionId: question.id, value: '$hour:$minute');
  }

  TimeOfDay? _parseTime(Object? value) {
    if (value is! String) {
      return null;
    }

    final parts = value.split(':');

    if (parts.length != 2) {
      return null;
    }

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);

    if (hour == null || minute == null) {
      return null;
    }

    return TimeOfDay(hour: hour, minute: minute);
  }

  void _changeAnswer({required String questionId, required Object? value}) {
    context.read<QuestionnaireBloc>().add(
      QuestionnaireAnswerChanged(questionId: questionId, value: value),
    );
  }

  Widget _buildError(BuildContext context, QuestionnaireState state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
            const SizedBox(height: 12),
            Text(
              state.errorMessage ?? 'Không thể tải khảo sát',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<QuestionnaireBloc>().add(
                  const QuestionnaireStarted(),
                );
              },
              child: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }
}
