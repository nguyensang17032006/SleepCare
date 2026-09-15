import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sleep_app_frontend/features/onboarding/domain/entities/questionnaire_question.dart';
import 'package:sleep_app_frontend/features/onboarding/presentation/bloc/daily_short/daily_short_bloc.dart';
import 'package:sleep_app_frontend/features/onboarding/presentation/bloc/daily_short/daily_short_event.dart';
import 'package:sleep_app_frontend/features/onboarding/presentation/bloc/daily_short/daily_short_state.dart';

class DailyShortSurveyScreen extends StatefulWidget {
  const DailyShortSurveyScreen({super.key});

  @override
  State<DailyShortSurveyScreen> createState() => _DailyShortSurveyScreenState();
}

class _DailyShortSurveyScreenState extends State<DailyShortSurveyScreen> {
  @override
  void initState() {
    super.initState();

    context.read<DailyShortBloc>().add(const DailyShortStarted());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DailyShortBloc, DailyShortState>(
      listener: (context, state) {
        if (state.status == DailyShortStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã lưu khảo sát thành công')),
          );

          Navigator.pop(context, true);
        }

        if (state.status == DailyShortStatus.failure &&
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
          appBar: AppBar(title: const Text('Khảo sát giấc ngủ hằng ngày')),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, DailyShortState state) {
    if (state.status == DailyShortStatus.initial ||
        state.status == DailyShortStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == DailyShortStatus.failure && state.questions.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              state.errorMessage ?? 'Không thể tải câu hỏi',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                context.read<DailyShortBloc>().add(const DailyShortStarted());
              },
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    if (state.questions.isEmpty) {
      return const Center(child: Text('Chưa có câu hỏi'));
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Hãy trả lời các câu hỏi dựa trên giấc ngủ gần nhất của bạn.',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 20),

        ...state.questions.asMap().entries.map((entry) {
          final index = entry.key;
          final question = entry.value;

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildQuestion(
              index: index,
              question: question,
              state: state,
            ),
          );
        }),

        const SizedBox(height: 8),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: state.status == DailyShortStatus.submitting
                ? null
                : () => _submit(context, state),
            child: state.status == DailyShortStatus.submitting
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Lưu khảo sát'),
          ),
        ),

        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildQuestion({
    required int index,
    required QuestionnaireQuestion question,
    required DailyShortState state,
  }) {
    final answer = state.answers[question.id];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${index + 1}. ${question.questionText}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 16),

            if (question.questionType == 'time')
              _buildTimeAnswer(question, answer)
            else if (question.questionType == 'number')
              _buildNumberAnswer(question, answer)
            else if (question.questionType == 'single_choice')
              _buildChoiceAnswer(question, answer)
            else if (question.questionType == 'duration_minutes')
              _buildNumberAnswer(question, answer)
            else
              Text(
                'Chưa hỗ trợ loại câu hỏi: ${question.questionType}',
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeAnswer(QuestionnaireQuestion question, Object? answer) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => _selectTime(question, answer),
      child: InputDecorator(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.access_time),
        ),
        child: Text(answer?.toString() ?? 'Chọn thời gian'),
      ),
    );
  }

  Widget _buildNumberAnswer(QuestionnaireQuestion question, Object? answer) {
    return TextFormField(
      key: ValueKey(question.id),
      initialValue: answer?.toString(),
      keyboardType: TextInputType.numberWithOptions(
        decimal: question.questionCode == 'SLEEP_DURATION',
      ),
      decoration: const InputDecoration(
        hintText: 'Nhập câu trả lời',
        border: OutlineInputBorder(),
      ),
      onChanged: (text) {
        final value = _parseNumber(
          questionCode: question.questionCode,
          text: text,
        );

        _changeAnswer(questionId: question.id, value: value);
      },
    );
  }

  Widget _buildChoiceAnswer(QuestionnaireQuestion question, Object? answer) {
    if (question.options.isEmpty) {
      return const Text('Câu hỏi chưa có lựa chọn');
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: question.options.map((option) {
        final selected = answer == option.value;

        return ChoiceChip(
          label: Text(option.label),
          selected: selected,
          onSelected: (_) {
            _changeAnswer(questionId: question.id, value: option.value);
          },
        );
      }).toList(),
    );
  }

  Future<void> _selectTime(
    QuestionnaireQuestion question,
    Object? currentAnswer,
  ) async {
    final initialTime = _parseTime(currentAnswer) ?? TimeOfDay.now();

    final selectedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
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

  Object? _parseNumber({required String questionCode, required String text}) {
    if (text.trim().isEmpty) {
      return null;
    }

    if (questionCode == 'SLEEP_LATENCY' || questionCode == 'AWAKENINGS_COUNT') {
      return int.tryParse(text);
    }

    return double.tryParse(text);
  }

  void _changeAnswer({required String questionId, required Object? value}) {
    context.read<DailyShortBloc>().add(
      DailyShortAnswerChanged(questionId: questionId, value: value),
    );
  }

  void _submit(BuildContext context, DailyShortState state) {
    if (!state.isComplete) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng trả lời đầy đủ câu hỏi')),
      );
      return;
    }

    context.read<DailyShortBloc>().add(const DailyShortSubmitted());
  }
}
