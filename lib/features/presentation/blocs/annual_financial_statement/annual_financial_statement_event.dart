part of 'annual_financial_statement_bloc.dart';

sealed class AnnualFinancialStatementEvent extends Equatable {
  const AnnualFinancialStatementEvent();

  @override
  List<Object> get props => [];
}

class LoadAnnualStatement extends AnnualFinancialStatementEvent {
  final int propertyId;
  final int year;

  const LoadAnnualStatement(this.propertyId, this.year);

  @override
  List<Object> get props => [propertyId, year];
}
