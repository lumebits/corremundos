part of 'create_trip_cubit.dart';

class CreateTripState extends Equatable {
  const CreateTripState({
    this.name = '',
    this.initDate,
    this.endDate,
    this.imageUrl = '',
    this.status = FormzStatus.pure,
  });

  final String name;
  final DateTime? initDate;
  final DateTime? endDate;
  final String imageUrl;
  final FormzStatus status;

  @override
  List<Object?> get props => [name, initDate, endDate, imageUrl, status];

  CreateTripState copyWith({
    String? name,
    DateTime? initDate,
    DateTime? endDate,
    String? imageUrl,
    FormzStatus? status,
  }) {
    return CreateTripState(
      name: name ?? this.name,
      initDate: initDate ?? this.initDate,
      endDate: endDate ?? this.endDate,
      imageUrl: imageUrl ?? this.imageUrl,
      status: status ?? this.status,
    );
  }
}
