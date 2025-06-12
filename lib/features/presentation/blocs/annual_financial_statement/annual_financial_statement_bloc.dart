import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:eaqarati_app/core/errors/failures.dart';
import 'package:eaqarati_app/features/domain/entities/financial_statement_entry.dart';
import 'package:eaqarati_app/features/domain/usecases/orchestration/generate_annual_financial_statement_use_case.dart';
import 'package:equatable/equatable.dart';

part 'annual_financial_statement_event.dart';
part 'annual_financial_statement_state.dart';

class FinancialStatementBloc
    extends Bloc<AnnualFinancialStatementEvent, AnnualFinancialStatementState> {
  final GenerateAnnualFinancialStatementUseCase
  generateAnnualFinancialStatementUseCase;

  FinancialStatementBloc({
    required this.generateAnnualFinancialStatementUseCase,
  }) : super(AnnualStatementInitial()) {
    on<LoadAnnualStatement>(_onLoadAnnualStatement);
  }

  Future<void> _onLoadAnnualStatement(
    LoadAnnualStatement event,
    Emitter<AnnualFinancialStatementState> emit,
  ) async {
    emit(AnnualStatementLoading());
    final failureOrStatement = await generateAnnualFinancialStatementUseCase(
      propertyId: event.propertyId,
      year: event.year,
    );

    failureOrStatement.fold(
      (failure) => emit(AnnualStatementError(_mapFailureToMessage(failure))),
      (entries) => emit(AnnualStatementLoaded(entries)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case const (ServerFailure):
        return 'Server Error: ${failure.message}';
      case const (DatabaseFailure):
        return 'Database Error: ${failure.message}';
      case const (NotFoundFailure):
        return 'Not Found: ${failure.message}';
      case const (ValidationFailure):
        return 'Validation Error: ${failure.message}';
      default:
        return 'Unexpected error: ${failure.message}';
    }
  }
}
