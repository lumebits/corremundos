
import 'package:auth_repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:trips_repository/trips_repository.dart';

part 'create_trip_state.dart';

class CreateTripCubit extends Cubit<CreateTripState> {
  CreateTripCubit(this.tripsRepository, this._authRepository) : super( CreateTripState());

  final TripsRepository tripsRepository;
  final AuthRepository _authRepository;

  void nameChanged(String value) {
    emit(
      state.copyWith(
        name: value,
        status: FormzStatus.valid,
      ),
    );
  }

  void initDateChanged(DateTime value) {
    emit(
      state.copyWith(
        initDate: value,
        status: FormzStatus.valid,
      ),
    );
  }

  void endDateChanged(DateTime value) {
    emit(
      state.copyWith(
        endDate: value,
        status: FormzStatus.valid,
      ),
    );
  }


}
