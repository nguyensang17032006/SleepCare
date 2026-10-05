import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ScheduleSource {
  final SupabaseClient supabase;

  ScheduleSource({
    SupabaseClient? supabase,
  }) : supabase =
            supabase ?? Supabase.instance.client;

  // =========================================================
  // LOAD BEDTIME SCHEDULE
  // =========================================================

  Future<Map<String, dynamic>?>
      getSchedule() async {
    final user =
        supabase.auth.currentUser;

    if (user == null) {
      throw Exception(
        'Người dùng chưa đăng nhập',
      );
    }

    try {
      final response = await supabase
          .from('bedtime_schedules')
          .select()
          .eq(
            'user_id',
            user.id,
          )
          .maybeSingle();

      debugPrint(
        'BEDTIME SCHEDULE LOADED: $response',
      );

      return response;
    } on PostgrestException catch (e) {
      debugPrint(
        'LOAD SCHEDULE SUPABASE ERROR',
      );
      debugPrint(
        'message: ${e.message}',
      );
      debugPrint(
        'code: ${e.code}',
      );
      debugPrint(
        'details: ${e.details}',
      );
      debugPrint(
        'hint: ${e.hint}',
      );

      rethrow;
    } catch (e) {
      debugPrint(
        'LOAD SCHEDULE ERROR: $e',
      );

      rethrow;
    }
  }

  // =========================================================
  // SAVE BEDTIME SCHEDULE
  // =========================================================

  Future<void> saveSchedule({
    required String bedtime,
    required Set<int> activeDays,
    required int reminderOffsetMinutes,
    required bool notificationsEnabled,
  }) async {
    final user =
        supabase.auth.currentUser;

    if (user == null) {
      throw Exception(
        'Người dùng chưa đăng nhập',
      );
    }

    final now = DateTime.now()
        .toUtc()
        .toIso8601String();

    final sortedDays =
        activeDays.toList()..sort();

    final payload =
        <String, dynamic>{
      'user_id': user.id,
      'bedtime': bedtime,
      'active_days': sortedDays,
      'reminder_offset_minutes':
          reminderOffsetMinutes,
      'notifications_enabled':
          notificationsEnabled,
      'timezone':
          DateTime.now().timeZoneName,
      'updated_at': now,
    };

    debugPrint(
      'SAVING BEDTIME SCHEDULE',
    );

    debugPrint(
      'payload: $payload',
    );

    try {
      final existing =
          await supabase
              .from(
                'bedtime_schedules',
              )
              .select('id')
              .eq(
                'user_id',
                user.id,
              )
              .maybeSingle();

      if (existing == null) {
        await supabase
            .from(
              'bedtime_schedules',
            )
            .insert({
          ...payload,
          'created_at': now,
        });

        debugPrint(
          'BEDTIME SCHEDULE INSERTED',
        );
      } else {
        await supabase
            .from(
              'bedtime_schedules',
            )
            .update(payload)
            .eq(
              'user_id',
              user.id,
            );

        debugPrint(
          'BEDTIME SCHEDULE UPDATED',
        );
      }
    } on PostgrestException catch (e) {
      debugPrint(
        'SAVE SCHEDULE SUPABASE ERROR',
      );

      debugPrint(
        'message: ${e.message}',
      );

      debugPrint(
        'code: ${e.code}',
      );

      debugPrint(
        'details: ${e.details}',
      );

      debugPrint(
        'hint: ${e.hint}',
      );

      rethrow;
    } catch (e) {
      debugPrint(
        'SAVE SCHEDULE ERROR: $e',
      );

      rethrow;
    }
  }

  // =========================================================
  // GET SLEEP TIMER
  // =========================================================

  Future<int?>
      getSleepTimerMinutes() async {
    final user =
        supabase.auth.currentUser;

    if (user == null) {
      throw Exception(
        'Người dùng chưa đăng nhập',
      );
    }

    try {
      final response = await supabase
          .from('bedtime_schedules')
          .select(
            'sleep_timer_minutes',
          )
          .eq(
            'user_id',
            user.id,
          )
          .maybeSingle();

      if (response == null) {
        debugPrint(
          'SLEEP TIMER: chưa có schedule',
        );

        return null;
      }

      final value =
          response[
              'sleep_timer_minutes'];

      if (value == null) {
        debugPrint(
          'SLEEP TIMER: chưa đặt',
        );

        return null;
      }

      final minutes =
          (value as num).toInt();

      debugPrint(
        'SLEEP TIMER LOADED: $minutes phút',
      );

      return minutes;
    } on PostgrestException catch (e) {
      debugPrint(
        'LOAD SLEEP TIMER SUPABASE ERROR',
      );

      debugPrint(
        'message: ${e.message}',
      );

      debugPrint(
        'code: ${e.code}',
      );

      debugPrint(
        'details: ${e.details}',
      );

      debugPrint(
        'hint: ${e.hint}',
      );

      rethrow;
    } catch (e) {
      debugPrint(
        'LOAD SLEEP TIMER ERROR: $e',
      );

      rethrow;
    }
  }

  // =========================================================
  // UPDATE SLEEP TIMER
  // =========================================================

  Future<void>
      updateSleepTimerMinutes(
    int minutes,
  ) async {
    final user =
        supabase.auth.currentUser;

    if (user == null) {
      throw Exception(
        'Người dùng chưa đăng nhập',
      );
    }

    final now = DateTime.now()
        .toUtc()
        .toIso8601String();

    try {
      final existing =
          await supabase
              .from(
                'bedtime_schedules',
              )
              .select('id')
              .eq(
                'user_id',
                user.id,
              )
              .maybeSingle();

      // User chưa có bedtime schedule.
      if (existing == null) {
        await supabase
            .from(
              'bedtime_schedules',
            )
            .insert({
          'user_id': user.id,

          'sleep_timer_minutes':
              minutes,

          'timezone':
              DateTime.now()
                  .timeZoneName,

          'created_at': now,

          'updated_at': now,
        });

        debugPrint(
          'SLEEP TIMER INSERTED: $minutes phút',
        );

        return;
      }

      // User đã có schedule.
      await supabase
          .from(
            'bedtime_schedules',
          )
          .update({
        'sleep_timer_minutes':
            minutes,

        'updated_at': now,
      }).eq(
        'user_id',
        user.id,
      );

      debugPrint(
        'SLEEP TIMER UPDATED: $minutes phút',
      );
    } on PostgrestException catch (e) {
      debugPrint(
        'UPDATE SLEEP TIMER SUPABASE ERROR',
      );

      debugPrint(
        'message: ${e.message}',
      );

      debugPrint(
        'code: ${e.code}',
      );

      debugPrint(
        'details: ${e.details}',
      );

      debugPrint(
        'hint: ${e.hint}',
      );

      rethrow;
    } catch (e) {
      debugPrint(
        'UPDATE SLEEP TIMER ERROR: $e',
      );

      rethrow;
    }
  }

  // =========================================================
  // CLEAR SLEEP TIMER
  // =========================================================

  Future<void>
      clearSleepTimer() async {
    final user =
        supabase.auth.currentUser;

    if (user == null) {
      throw Exception(
        'Người dùng chưa đăng nhập',
      );
    }

    try {
      await supabase
          .from(
            'bedtime_schedules',
          )
          .update({
        'sleep_timer_minutes': null,

        'updated_at': DateTime.now()
            .toUtc()
            .toIso8601String(),
      }).eq(
        'user_id',
        user.id,
      );

      debugPrint(
        'SLEEP TIMER CLEARED',
      );
    } catch (e) {
      debugPrint(
        'CLEAR SLEEP TIMER ERROR: $e',
      );

      rethrow;
    }
  }
}