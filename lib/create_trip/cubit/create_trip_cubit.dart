import 'package:auth_repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:corremundos/common/read_unsplash_cred.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:trips_repository/trips_repository.dart';
import 'package:unsplash_client/unsplash_client.dart';
import 'package:uuid/uuid.dart';

part 'create_trip_state.dart';

class CreateTripCubit extends Cubit<CreateTripState> {
  CreateTripCubit(this.tripsRepository, this.authRepository)
      : super(
          CreateTripState(initDate: DateTime.now(), endDate: DateTime.now()),
        );

  final TripsRepository tripsRepository;
  final AuthRepository authRepository;

  void loadTripToEdit(Trip trip) {
    emit(
      state.copyWith(
        id: trip.id,
        name: trip.name,
        initDate: trip.initDate,
        endDate: trip.endDate,
        imageUrl: trip.imageUrl,
        status: FormzStatus.valid,
      ),
    );
  }

  void nameChanged(String value) {
    emit(
      state.copyWith(
        name: value,
        initDate: state.initDate,
        endDate: state.endDate,
        imageUrl: state.imageUrl,
        status: FormzStatus.valid,
      ),
    );
  }

  void initDateChanged(DateTime value) {
    emit(
      state.copyWith(
        name: state.name,
        initDate: value,
        endDate: state.endDate,
        imageUrl: state.imageUrl,
        status: FormzStatus.valid,
      ),
    );
  }

  void endDateChanged(DateTime value) {
    emit(
      state.copyWith(
        name: state.name,
        initDate: state.initDate,
        endDate: value,
        imageUrl: state.imageUrl,
        status: FormzStatus.valid,
      ),
    );
  }

  void imageUrlChanged(String image) {
    emit(
      state.copyWith(
        name: state.name,
        initDate: state.initDate,
        endDate: state.endDate,
        imageUrl: image,
        status: FormzStatus.valid,
      ),
    );
  }

  Future<void> saveTrip() async {
    await loadAppCredentialsFromFile().then((appCredentials) async {
      final client = UnsplashClient(
        settings: ClientSettings(credentials: appCredentials),
      );

      await client.search
          .photos(state.name, orientation: PhotoOrientation.landscape)
          .goAndGet()
          .then((photo) async {
        final imageUrl = photo.results.first.urls.regular.toString();
        final trip = Trip(
          uid: state.id != '' ? authRepository.currentUser.id : '',
          id: state.id != '' ? state.id : const Uuid().v4(),
          name: state.name,
          initDate: state.initDate,
          endDate: state.endDate,
          imageUrl: imageUrl,
        );
        await tripsRepository.updateOrCreateTrip(
          trip,
          authRepository.currentUser.id,
        );
      }).onError((error, stackTrace) async {
        final trip = Trip(
          uid: state.id != '' ? authRepository.currentUser.id : '',
          id: state.id != '' ? state.id : const Uuid().v4(),
          name: state.name,
          initDate: state.initDate,
          endDate: state.endDate,
          imageUrl:
              'https://images.unsplash.com/photo-1488646953014-85cb44e25828?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2070&q=80',
        );
        await tripsRepository.updateOrCreateTrip(
          trip,
          authRepository.currentUser.id,
        );
      });
      client.close();
    });
  }
}
