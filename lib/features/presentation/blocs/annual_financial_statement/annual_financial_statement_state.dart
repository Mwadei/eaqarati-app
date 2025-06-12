part of 'annual_financial_statement_bloc.dart';

sealed class AnnualFinancialStatementState extends Equatable {
  const AnnualFinancialStatementState();

  @override
  List<Object> get props => [];
}

class AnnualStatementInitial extends AnnualFinancialStatementState {}

class AnnualStatementLoading extends AnnualFinancialStatementState {}

class AnnualStatementLoaded extends AnnualFinancialStatementState {
  final List<FinancialStatementEntry> entries;

  const AnnualStatementLoaded(this.entries);
  @override
  List<Object> get props => [entries];
}

class AnnualStatementError extends AnnualFinancialStatementState {
  final String message;

  const AnnualStatementError(this.message);

  @override
  List<Object> get props => [message];
}
