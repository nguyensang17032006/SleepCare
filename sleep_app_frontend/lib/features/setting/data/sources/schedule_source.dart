import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ScheduleSource {
  final SupabaseClient supabase;

  ScheduleSource({SupabaseClient? supabase})
      : supabase = supabase ?? Supabase.instance.client;

  Future<Map<String, dynamic>?> getSchedule() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      throw Exception('Người dùng chưa đăng nhập');
    }

    try {
      final response = await supabase
          .from('bedtime_schedules')
          .select()
          .eq('user_id', user.id)
          .maybeSingle();

      debugPrint('BEDTIME SCHEDULE LOADED: $response');
      return response;
    } on PostgrestException catch (e) {
      debugPrint('LOAD SCHEDULE SUPABASE ERROR');
      debugPrint('message: ${e.message}');
      debugPrint('code: ${e.code}');
      debugPrint('details: ${e.details}');
      debugPrint('hint: ${e.hint}');
      rethrow;
    }
  }

  Future<void> saveSchedule({
    required String bedtime,
    required Set<int> activeDays,
    required int reminderOffsetMinutes,
    required bool notificationsEnabled,
  }) async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      throw Exception('Người dùng chưa đăng nhập');
    }

    final now = DateTime.now().toUtc().toIso8601String();
    final sortedDays = activeDays.toList()..sort();

    final payload = <String, dynamic>{
      'user_id': user.id,
      'bedtime': bedtime,
      'active_days': sortedDays,
      'reminder_offset_minutes': reminderOffsetMinutes,
      'notifications_enabled': notificationsEnabled,
      'timezone': DateTime.now().timeZoneName,
      'updated_at': now,
    };

    try {
      final existing = await supabase
          .from('bedtime_schedules')
          .select('id')
          .eq('user_id', user.id)
          .maybeSingle();

      if (existing == null) {
        await supabase.from('bedtime_schedules').insert({
          ...payload,
          'created_at': now,
        });
      } else {
        await supabase
            .from('bedtime_schedules')
            .update(payload)
            .eq('user_id', user.id);
      }
    } on PostgrestException catch (e) {
      debugPrint('SAVE SCHEDULE SUPABASE ERROR');
      debugPrint('message: ${e.message}');
      debugPrint('code: ${e.code}');
      debugPrint('details: ${e.details}');
      debugPrint('hint: ${e.hint}');
      rethrow;
    }
  }

  Future<int?> getSleepTimerMinutes() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      throw Exception('Người dùng chưa đăng nhập');
    }

    final response = await supabase
        .from('bedtime_schedules')
        .select('sleep_timer_minutes')
        .eq('user_id', user.id)
        .maybeSingle();

    final value = response?['sleep_timer_minutes'];
    return value == null ? null : (value as num).toInt();
  }

  Future<void> updateSleepTimerMinutes(int minutes) async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      throw Exception('Người dùng chưa đăng nhập');
    }

    final now = DateTime.now().toUtc().toIso8601String();

    try {
      final existing = await supabase
          .from('bedtime_schedules')
          .select('id')
          .eq('user_id', user.id)
          .maybeSingle();

      if (existing == null) {
        await supabase.from('bedtime_schedules').insert({
          'user_id': user.id,
          'sleep_timer_minutes': minutes,
          'snooze_minutes': 15,
          'timezone': DateTime.now().timeZoneName,
          'created_at': now,
          'updated_at': now,
        });
      } else {
        await supabase
            .from('bedtime_schedules')
            .update({
              'sleep_timer_minutes': minutes,
              'updated_at': now,
            })
            .eq('user_id', user.id);
      }

      debugPrint('SLEEP TIMER SAVED: $minutes phút');
    } on PostgrestException catch (e) {
      debugPrint('UPDATE SLEEP TIMER SUPABASE ERROR');
      debugPrint('message: ${e.message}');
      debugPrint('code: ${e.code}');
      debugPrint('details: ${e.details}');
      debugPrint('hint: ${e.hint}');
      rethrow;
    }
  }

  Future<void> clearSleepTimer() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      throw Exception('Người dùng chưa đăng nhập');
    }

    await supabase
        .from('bedtime_schedules')
        .update({
          'sleep_timer_minutes': null,
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        })
        .eq('user_id', user.id);

    debugPrint('SLEEP TIMER CLEARED');
  }

  Future<int> getSnoozeMinutes() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      throw Exception('Người dùng chưa đăng nhập');
    }

    final response = await supabase
        .from('bedtime_schedules')
        .select('snooze_minutes')
        .eq('user_id', user.id)
        .maybeSingle();

    final value = response?['snooze_minutes'];
    return value == null ? 15 : (value as num).toInt();
  }

  Future<void> updateSnoozeMinutes(int minutes) async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      throw Exception('Người dùng chưa đăng nhập');
    }

    final now = DateTime.now().toUtc().toIso8601String();

    try {
      final existing = await supabase
          .from('bedtime_schedules')
          .select('id')
          .eq('user_id', user.id)
          .maybeSingle();

      if (existing == null) {
        await supabase.from('bedtime_schedules').insert({
          'user_id': user.id,
          'snooze_minutes': minutes,
          'timezone': DateTime.now().timeZoneName,
          'created_at': now,
          'updated_at': now,
        });
      } else {
        await supabase
            .from('bedtime_schedules')
            .update({
              'snooze_minutes': minutes,
              'updated_at': now,
            })
            .eq('user_id', user.id);
      }

      debugPrint('SNOOZE MINUTES SAVED: $minutes phút');
    } on PostgrestException catch (e) {
      debugPrint('UPDATE SNOOZE SUPABASE ERROR');
      debugPrint('message: ${e.message}');
      debugPrint('code: ${e.code}');
      debugPrint('details: ${e.details}');
      debugPrint('hint: ${e.hint}');
      rethrow;
    }
  }
}
