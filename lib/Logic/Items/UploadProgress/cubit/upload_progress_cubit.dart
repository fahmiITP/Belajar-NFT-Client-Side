import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'upload_progress_state.dart';

class UploadProgressCubit extends Cubit<UploadProgressState> {
  UploadProgressCubit() : super(UploadProgressInitial(percentage: 0));

  void setUploadProgress(int percentage) =>
      emit(UploadProgressInitial(percentage: percentage));
}
