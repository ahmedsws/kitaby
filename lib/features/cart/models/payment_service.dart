// import 'package:stripe_payment/stripe_payment.dart';

// class PaymentService {
//   final int? amount;
//   final String? url;

//   const PaymentService({this.amount, this.url});

//   static init() {
//     StripePayment.setOptions(
//       StripeOptions(
//         publishableKey:
//             'pk_test_51MFj5RHr9oEoEmnK3SBvQGrEUwP7osq2KFHhmqUI1REoeOcYISp66LZ7ZKIVptxFEoYcaGR2YmwYJrR9jQGYFmXk00mD8Yz27A',
//         androidPayMode: 'test',
//         merchantId: 'test',
//       ),
//     );
//   }

//   Future<PaymentMethod?> createPaymentMethod() async {
//     PaymentMethod payemntMethod =
//         await StripePayment.paymentRequestWithCardForm(
//       CardFormPaymentRequest(),
//     );

//     return payemntMethod;
//   }

//   Future<void> processPayment(PaymentMethod paymentMethod) async {
//     StripePayment.confirmPaymentIntent(
//       PaymentIntent(
//         clientSecret:
//             'sk_test_51MFj5RHr9oEoEmnKVnb2jT3HfejOyAM92ApzEVU0bAJdTTMe6C93vtowMOV5hNBZGGJ2h0nBwNmycHtlnCwJN3s000QIHDs8z0',
//         paymentMethodId: paymentMethod.id,
//       ),
//     );
//   }
// }
