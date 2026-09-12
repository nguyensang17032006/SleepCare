import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:sleep_app_frontend/features/library/domain/repositories/library_repository.dart';
import 'package:sleep_app_frontend/features/sleep_session/presentation/bloc/SleepPrep/sleep_prep_event.dart';
import 'package:sleep_app_frontend/features/sleep_session/presentation/bloc/SleepPrep/sleep_prep_state.dart';

class SleepPrepBloc extends Bloc<SleepPrepEvent, SleepPrepState> {
  final LibraryRepository libraryRepository;

  SleepPrepBloc({required this.libraryRepository})
    : super(const SleepPrepInitial()) {
    on<SleepPrepStarted>(_onStarted);
    on<SleepPrepTrackSelected>(_onTrackSelected);
    on<SleepPrepDurationChanged>(_onDurationChanged);
  }

  Future<void> _onStarted(
    SleepPrepStarted event,
    Emitter<SleepPrepState> emit,
  ) async {
    emit(const SleepPrepLoading());

    try {
      final musics = await libraryRepository.getSavedMusics();

      if (musics.isEmpty) {
        emit(const SleepPrepEmpty());
        return;
      }

      emit(
        SleepPrepLoaded(
          savedMusics: musics,
          selectedMusic: musics.first,
          durationMinutes: 30,
        ),
      );
    } catch (error, stackTrace) {
      debugPrint('LOAD SAVED SLEEP MUSIC ERROR: $error');
      debugPrint(stackTrace.toString());

      emit(SleepPrepFailure(error.toString()));
    }
  }

  void _onTrackSelected(
    SleepPrepTrackSelected event,
    Emitter<SleepPrepState> emit,
  ) {
    final currentState = state;

    if (currentState is! SleepPrepLoaded) {
      return;
    }

    final exists = currentState.savedMusics.any(
      (music) => music.id == event.music.id,
    );

    if (!exists) {
      return;
    }

    emit(currentState.copyWith(selectedMusic: event.music));
  }

  void _onDurationChanged(
    SleepPrepDurationChanged event,
    Emitter<SleepPrepState> emit,
  ) {
    final currentState = state;

    if (currentState is! SleepPrepLoaded) {
      return;
    }

    if (event.minutes <= 0) {
      return;
    }

    emit(currentState.copyWith(durationMinutes: event.minutes));
  }
}
