 part of 'location_bloc.dart';



 enum LocationStateStatus { initial, success, error, loading }

 extension LocationStateStatusX on LocationStateStatus {
   bool get isInitial => this == LocationStateStatus.initial;
   bool get isSuccess => this == LocationStateStatus.success;
   bool get isError => this == LocationStateStatus.error;
   bool get isLoading => this == LocationStateStatus.loading;
 }
class LocationState extends Equatable{
  const LocationState({
    this.status = LocationStateStatus.initial,
     CurrentUserLocationEntity? currentUserLocation,
    String? errorMessage,
  })  : currentUserLocation =
      currentUserLocation ?? CurrentUserLocationEntity.empty,
         errorMessage = errorMessage ?? '';

  final LocationStateStatus status;
  final CurrentUserLocationEntity currentUserLocation;
   final String errorMessage;

  @override
  List<Object?> get props => [
    status,
    currentUserLocation,
     errorMessage,
  ];

  LocationState copyWith({
    LocationStateStatus? status,
    CurrentUserLocationEntity? currentUserLocation,
    Location? location,
    String? errorMessage,
  }) {
    return LocationState(
      status: status ?? this.status,
      currentUserLocation: currentUserLocation ?? this.currentUserLocation,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}