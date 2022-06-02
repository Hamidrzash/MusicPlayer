import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'online_songs_event.dart';
part 'online_songs_state.dart';

class OnlineSongsBloc extends Bloc<OnlineSongsEvent, OnlineSongsState> {
  OnlineSongsBloc() : super(OnlineSongsInitial()) {
    on<OnlineSongsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
