part of 'upload_progress_cubit.dart';

abstract class UploadProgressState extends Equatable {
  const UploadProgressState();

  @override
  List<Object> get props => [];
}

class UploadProgressInitial extends UploadProgressState {
  final int percentage;

  UploadProgressInitial({
    required this.percentage,
  });

  @override
  List<Object> get props => [percentage];
}
