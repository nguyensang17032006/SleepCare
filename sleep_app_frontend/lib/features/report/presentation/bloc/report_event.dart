part of 'report_bloc.dart';

@immutable
sealed class ReportEvent {}

class LoadReportData extends ReportEvent {
  final String userId;

  LoadReportData(this.userId);
}
