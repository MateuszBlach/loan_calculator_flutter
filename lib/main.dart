import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const LoanCalculatorApp());
}

class LoanCalculatorApp extends StatelessWidget {
  const LoanCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Symulator Kalkulacji Pożyczki',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade600,
            textStyle:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.blue.shade50,
          labelStyle: TextStyle(color: Colors.blue.shade700),
        ),
      ),
      home: const LoanInputScreen(),
    );
  }
}

class LoanInputScreen extends StatefulWidget {
  const LoanInputScreen({super.key});

  @override
  State<LoanInputScreen> createState() => _LoanInputScreenState();
}

class _LoanInputScreenState extends State<LoanInputScreen> {
  final TextEditingController loanAmountController = TextEditingController();
  final TextEditingController interestRateController = TextEditingController();
  final TextEditingController monthsController = TextEditingController();
  bool isEqualInstallments = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kalkulator Pożyczki',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: loanAmountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Kwota pożyczki (PLN)',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: interestRateController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Oprocentowanie (%)',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: monthsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Liczba miesięcy',
                  ),
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tryb rat:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    ListTile(
                      title: const Text('Równe'),
                      leading: Radio<bool>(
                        value: true,
                        groupValue: isEqualInstallments,
                        onChanged: (value) {
                          setState(() {
                            isEqualInstallments = value!;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Malejące'),
                      leading: Radio<bool>(
                        value: false,
                        groupValue: isEqualInstallments,
                        onChanged: (value) {
                          setState(() {
                            isEqualInstallments = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      final loanAmount =
                          double.tryParse(loanAmountController.text);
                      final interestRate =
                          double.tryParse(interestRateController.text);
                      final months = int.tryParse(monthsController.text);

                      if (loanAmount != null &&
                          interestRate != null &&
                          months != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoanResultScreen(
                              loanAmount: loanAmount,
                              interestRate: interestRate,
                              months: months,
                              isEqualInstallments: isEqualInstallments,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Proszę wprowadzić poprawne dane.'),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      }
                    },
                    child: const Text(
                      'Oblicz raty',
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

  List<double> _calculateInstallments() {
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

  double _calculateTotalPayment(List<double> installments) {
    return installments.reduce((a, b) => a + b);
  }

  @override
  Widget build(BuildContext context) {
    final installments = _calculateInstallments();
    final totalPayment = _calculateTotalPayment(installments);

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
