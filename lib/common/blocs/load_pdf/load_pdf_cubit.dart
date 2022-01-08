import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

part 'load_pdf_state.dart';

class LoadPdfCubit extends Cubit<LoadPdfState> {
  LoadPdfCubit() : super(const LoadPdfState());

  Future<void> load(String url) async {
    emit(state.copyWith(isLoading: true, error: false));

    await DefaultCacheManager()
        .getSingleFile(url)
        .then(
          (value) => emit(
            state.copyWith(path: value.path, isLoading: false, error: false),
          ),
        )
        .onError(
          (error, stackTrace) =>
              emit(state.copyWith(isLoading: false, error: true)),
        );
  }
}
