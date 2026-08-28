import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'library_event.dart';
part 'library_state.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  LibraryBloc() : super(LibraryInitial()) {
    on<LibraryEvent>((event, emit) {});
  }
}
