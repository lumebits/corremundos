part of 'create_trip_cubit.dart';

class CreateTripState extends Equatable {
  const CreateTripState({
    this.id = '',
    this.name = '',
    required this.initDate,
    required this.endDate,
    this.imageUrl = '',
    bool? isLoading,
    this.status = FormzStatus.pure,
  }) : isLoading = isLoading ?? false;

  final String? id;
  final String name;
  final DateTime initDate;
  final DateTime endDate;
  final String imageUrl;
  final bool isLoading;
  final FormzStatus status;

  @override
  List<Object?> get props =>
      [id, name, initDate, endDate, imageUrl, isLoading, status];

  CreateTripState copyWith({
    String? id,
    String? name,
    DateTime? initDate,
    DateTime? endDate,
    String? imageUrl,
    bool? isLoading,
    FormzStatus? status,
  }) {
    return CreateTripState(
      id: id ?? this.id,
      name: name ?? this.name,
      initDate: initDate ?? this.initDate,
      endDate: endDate ?? this.endDate,
      imageUrl: imageUrl ?? this.imageUrl,
      isLoading: isLoading ?? this.isLoading,
      status: status ?? this.status,
    );
  }
}
