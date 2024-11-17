import 'package:flutter/material.dart';
import '../screens/result_screen.dart';

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
