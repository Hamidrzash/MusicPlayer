import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'all_songs_event.dart';
part 'all_songs_state.dart';

class AllSongsBloc extends Bloc<AllSongsEvent, AllSongsState> {
  AllSongsBloc() : super(AllSongsInitial()) {
    on<GetSongsDataEvent>(_onGetSongsDataEvent);
    on<GetSongsDataFailedEvent>(_onGetSongsDataEventFailed);
  }

  void _onGetSongsDataEvent(event, emit) {}

  void _onGetSongsDataEventFailed(event, emit) {}
}
