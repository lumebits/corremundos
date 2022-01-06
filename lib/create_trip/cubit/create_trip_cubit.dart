import 'package:auth_repository/auth_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:corremundos/common/read_unsplash_cred.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:trips_repository/trips_repository.dart';
import 'package:unsplash_client/unsplash_client.dart';

part 'create_trip_state.dart';

class CreateTripCubit extends Cubit<CreateTripState> {
  CreateTripCubit(this.tripsRepository, this.authRepository)
      : super(const CreateTripState());

  final TripsRepository tripsRepository;
  final AuthRepository authRepository;

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
    await loadAppCredentialsFromFile().then((appCredentials) {
      final client = UnsplashClient(
        settings: ClientSettings(credentials: appCredentials),
      );

      client.search.photos(state.name).goAndGet().then((photo) {
        final imageUrl = photo.results.first.urls.regular.toString();
        final trip = Trip(
          uid: authRepository.currentUser.id,
          name: state.name,
          initDate: state.initDate,
          endDate: state.endDate,
          imageUrl: imageUrl,
        );
        tripsRepository.updateOrCreateTrip(
          trip,
          authRepository.currentUser.id,
        );
        emit(
          state.copyWith(
            name: '',
            initDate: DateTime.now(),
            endDate: DateTime.now(),
            imageUrl: '',
            status: FormzStatus.valid,
          ),
        );
      });
      client.close();
    });
  }
}
