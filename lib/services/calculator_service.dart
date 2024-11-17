import 'dart:math';

class CalculatorService {
  static List<double> calculateInstallments({
    required double loanAmount,
    required double interestRate,
    required int months,
    required bool isEqualInstallments,
  }) {
    final monthlyRate = interestRate / 100 / 12;
    List<double> installments = [];

    if (isEqualInstallments) {
      double equalInstallment =
          loanAmount * monthlyRate / (1 - pow(1 + monthlyRate, -months));
      installments = List.filled(months, equalInstallment);
    } else {
      double remainingAmount = loanAmount;
      final principalPayment = loanAmount / months;

      for (int i = 0; i < months; i++) {
        final interestForMonth = remainingAmount * monthlyRate;
        final installment = principalPayment + interestForMonth;
        installments.add(installment);
        remainingAmount -= principalPayment;
      }
    }
    return installments;
  }

  static double calculateTotalPayment(List<double> installments) {
    return installments.reduce((a, b) => a + b);
  }
}
