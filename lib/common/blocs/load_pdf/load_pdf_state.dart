part of 'load_pdf_cubit.dart';

class LoadPdfState extends Equatable {
  const LoadPdfState({
    String? path,
    bool? isLoading,
    bool? error,
  })  : path = path ?? '',
        isLoading = isLoading ?? true,
        error = error ?? false;

  final String path;
  final bool isLoading;
  final bool error;

  LoadPdfState copyWith({
    String? path,
    bool? isLoading,
    bool? error,
  }) {
    return LoadPdfState(
      path: path ?? this.path,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [path, isLoading, error];

  @override
  String toString() => 'LoadPdfState { path: $path,  isLoading: $isLoading, '
      'error: $error }';
}
