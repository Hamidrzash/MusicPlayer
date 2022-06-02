part of 'all_songs_bloc.dart';

@immutable
abstract class AllSongsState {}

class AllSongsInitial extends AllSongsState {}

class GetSongsDataState extends AllSongsState {}

class GetSongsDataFailedState extends AllSongsState {}

class SearchSongsState extends AllSongsState {}
