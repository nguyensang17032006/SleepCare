import '../../../../main.dart'; // To access supabaseClient

class ScheduleSource {
  Future<Map<String, dynamic>?> getSchedule() async {
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) return null;

    final data = await supabaseClient
        .from('bedtime_schedules')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    return data;
  }

  Future<void> saveSchedule({
    required String bedtime, // "HH:mm" format
    required List<int> activeDays,
    required int reminderOffsetMinutes,
    required bool notificationsEnabled,
  }) async {
    final userId = supabaseClient.auth.currentUser?.id;
    if (userId == null) return;

    final existingSchedule = await getSchedule();

    final payload = {
      'user_id': userId,
      'bedtime': bedtime,
      'active_days': activeDays,
      'reminder_offset_minutes': reminderOffsetMinutes,
      'notifications_enabled': notificationsEnabled,
      'timezone': DateTime.now().timeZoneName,
      'updated_at': DateTime.now().toIso8601String(),
    };

    if (existingSchedule != null) {
      await supabaseClient
          .from('bedtime_schedules')
          .update(payload)
          .eq('user_id', userId);
    } else {
      payload['created_at'] = DateTime.now().toIso8601String();
      await supabaseClient.from('bedtime_schedules').insert(payload);
    }
  }
}
