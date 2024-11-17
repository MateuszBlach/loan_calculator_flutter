import 'package:flutter/material.dart';
import '../services/calculator_service.dart';

class LoanResultScreen extends StatelessWidget {
  final double loanAmount;
  final double interestRate;
  final int months;
  final bool isEqualInstallments;

  const LoanResultScreen({
    super.key,
    required this.loanAmount,
    required this.interestRate,
    required this.months,
    required this.isEqualInstallments,
  });

  @override
  Widget build(BuildContext context) {
    final installments = CalculatorService.calculateInstallments(
      loanAmount: loanAmount,
      interestRate: interestRate,
      months: months,
      isEqualInstallments: isEqualInstallments,
    );
    final totalPayment = CalculatorService.calculateTotalPayment(installments);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Wynik Kalkulacji',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade700,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Wyniki Kalkulacji:',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Text(
                  'Łączna kwota do spłaty: ${totalPayment.toStringAsFixed(2)} PLN',
                  style: TextStyle(fontSize: 18, color: Colors.blue.shade700),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Raty miesięczne:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Miesiąc')),
                        DataColumn(label: Text('Rata (PLN)')),
                      ],
                      rows: List<DataRow>.generate(
                        installments.length,
                        (index) => DataRow(
                          cells: [
                            DataCell(Text('${index + 1}')),
                            DataCell(
                                Text(installments[index].toStringAsFixed(2))),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Wróć',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
