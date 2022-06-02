part of 'all_songs_bloc.dart';

@immutable
abstract class AllSongsEvent {}

class GetSongsDataEvent extends AllSongsEvent {}

class GetSongsDataFailedEvent extends AllSongsEvent {}
