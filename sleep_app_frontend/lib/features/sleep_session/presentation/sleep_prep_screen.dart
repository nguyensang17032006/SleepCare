import 'package:flutter/material.dart';
import 'package:sleep_app_frontend/core/app/widget/primary_button.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sleep_app_frontend/core/theme/theme.dart';
import 'package:sleep_app_frontend/features/sleep_session/presentation/sleep_session_screen.dart';

class SleepPrepScreen extends StatefulWidget {
  const SleepPrepScreen({super.key});

  @override
  State<SleepPrepScreen> createState() => _SleepPrepScreenState();
}

class _SleepPrepScreenState extends State<SleepPrepScreen> {
  final _supabase = Supabase.instance.client;
  bool _isLoading = true;
  List<FileObject> _musicFiles = [];
  String? _selectedMusicUrl;
  String? _selectedMusicName;
  int _selectedDurationMins = 30; // Default 30 minutes

  final List<int> _durationOptions = [1, 15, 30, 45, 60, 90, 120];

  @override
  void initState() {
    super.initState();
    _fetchMusic();
  }

  Future<void> _fetchMusic() async {
    try {
      final List<FileObject> objects = await _supabase.storage
          .from('music-audio')
          .list();
      // Filter only files (not directories or empty objects)
      final files = objects
          .where((obj) => obj.name.isNotEmpty && !obj.name.startsWith('.'))
          .toList();

      setState(() {
        _musicFiles = files;
        if (files.isNotEmpty) {
          _selectedMusicName = files.first.name;
          _selectedMusicUrl = _supabase.storage
              .from('music-audio')
              .getPublicUrl(files.first.name);
        }
      });
    } catch (e) {
      debugPrint('Error fetching music: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showDurationPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.bgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Chọn thời lượng',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _durationOptions.map((mins) {
                  final isSelected = _selectedDurationMins == mins;
                  return ChoiceChip(
                    label: Text('${mins}m'),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedDurationMins = mins;
                        });
                        Navigator.pop(context);
                      }
                    },
                    selectedColor: AppTheme.primaryColor,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppTheme.textLight,
                    ),
                    backgroundColor: AppTheme.cardLightColor,
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Chuẩn bị ngủ',
          style: TextStyle(color: AppTheme.textLight),
        ),
        iconTheme: const IconThemeData(color: AppTheme.textLight),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryColor),
            )
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Chọn nhạc nền',
                    style: TextStyle(
                      color: AppTheme.textLight,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_musicFiles.isEmpty)
                    const Text(
                      'Không có bài nhạc nào.',
                      style: TextStyle(color: AppTheme.textMuted),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: _musicFiles.length,
                        itemBuilder: (context, index) {
                          final file = _musicFiles[index];
                          final isSelected = _selectedMusicName == file.name;
                          return ListTile(
                            onTap: () {
                              setState(() {
                                _selectedMusicName = file.name;
                                _selectedMusicUrl = _supabase.storage
                                    .from('music-audio')
                                    .getPublicUrl(file.name);
                              });
                            },
                            tileColor: isSelected
                                ? AppTheme.primaryColor.withValues(alpha: 0.2)
                                : null,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            leading: Icon(
                              Icons.music_note,
                              color: isSelected
                                  ? AppTheme.primaryColor
                                  : AppTheme.textMuted,
                            ),
                            title: Text(
                              file.name,
                              style: TextStyle(
                                color: isSelected
                                    ? AppTheme.primaryColor
                                    : AppTheme.textLight,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            trailing: isSelected
                                ? const Icon(
                                    Icons.check_circle,
                                    color: AppTheme.primaryColor,
                                  )
                                : null,
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 24),
                  InkWell(
                    onTap: () => _showDurationPicker(context),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.cardLightColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withValues(
                                alpha: 0.2,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.music_note,
                              color: AppTheme.primaryColor,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Phát nhạc',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Thời lượng',
                                  style: TextStyle(
                                    color: AppTheme.textMuted,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withValues(
                                alpha: 0.2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${_selectedDurationMins}m',
                              style: const TextStyle(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: PrimaryButton(
                      text: 'Bắt đầu',
                      isLoading: _isLoading,
                      onPressed: (_selectedMusicUrl == null)
                          ? () {}
                          : () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => SleepSessionScreen(
                                    musicUrl: _selectedMusicUrl!,
                                    musicName: _selectedMusicName!,
                                    durationMinutes: _selectedDurationMins,
                                  ),
                                ),
                              );
                            },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}
