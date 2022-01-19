part of 'create_trip_cubit.dart';

class CreateTripState extends Equatable {
  const CreateTripState({
    this.id = '',
    this.name = '',
    required this.initDate,
    required this.endDate,
    this.imageUrl = '',
    this.status = FormzStatus.pure,
  });

  final String? id;
  final String name;
  final DateTime initDate;
  final DateTime endDate;
  final String imageUrl;
  final FormzStatus status;

  @override
  List<Object?> get props => [id, name, initDate, endDate, imageUrl, status];

  CreateTripState copyWith({
    String? id,
    String? name,
    DateTime? initDate,
    DateTime? endDate,
    String? imageUrl,
    FormzStatus? status,
  }) {
    return CreateTripState(
      id: id ?? this.id,
      name: name ?? this.name,
      initDate: initDate ?? this.initDate,
      endDate: endDate ?? this.endDate,
      imageUrl: imageUrl ?? this.imageUrl,
      status: status ?? this.status,
    );
  }
}
