import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

class CheckoutPaymentPage extends StatefulWidget {
  const CheckoutPaymentPage({Key? key}) : super(key: key);

  @override
  State<CheckoutPaymentPage> createState() => _CheckoutPaymentPageState();
}

class _CheckoutPaymentPageState extends State<CheckoutPaymentPage> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout Payment'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              CreditCardWidget(
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cardHolderName: cardHolderName,
                cvvCode: cvvCode,
                showBackView: isCvvFocused,
                obscureCardNumber: false,
                obscureCardCvv: false,
                isHolderNameVisible: true,
                cardBgColor: Colors.green.shade400,
                onCreditCardWidgetChange: (CreditCardBrand brand) {},
              ),
              CreditCardForm(
                formKey: formKey,
                obscureCvv: false,
                obscureNumber: false,
                cardNumber: cardNumber,
                cvvCode: cvvCode,
                isHolderNameVisible: true,
                isCardNumberVisible: true,
                isExpiryDateVisible: true,
                cardHolderName: cardHolderName,
                expiryDate: expiryDate,
                onCreditCardModelChange: onCreditCardModelChange,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    // Handle payment logic here
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Payment processed!')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Pay Now', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel data) {
    setState(() {
      cardNumber = data.cardNumber;
      expiryDate = data.expiryDate;
      cardHolderName = data.cardHolderName;
      cvvCode = data.cvvCode;
      isCvvFocused = data.isCvvFocused;
    });
  }
} 