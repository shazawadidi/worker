
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../location_repository/location_repository.dart';
import '../location_repository/model/current_location.dart';
 import 'package:location/location.dart';

part 'location_event.dart';
part 'location_state.dart';
class LocationBloc extends Bloc<LocationEvent,LocationState>{
  LocationBloc({
    required this.locationRepository,
  }) : super(LocationState()) {
    on<GetLocation>(_getLocationEvent);
  }
  final LocationRepository locationRepository;

  void _getLocationEvent(GetLocation event, Emitter<LocationState> emit) async {
    try {
      emit(state.copyWith(status: LocationStateStatus.loading));

      var _currentLocation = await locationRepository.getCurrentLocation();

      emit(
        state.copyWith(
          currentUserLocation: _currentLocation,
          status: LocationStateStatus.success,
        ),
      );
    } on CurrentLocationFailure catch (e) {
      emit(
        state.copyWith(
          status: LocationStateStatus.error,
          errorMessage: e.error,
        ),
      );
      // This is important to check errors on tests.
      // Also you can see the error on the [BlocObserver.onError].
      addError(e);
    }
  }
}