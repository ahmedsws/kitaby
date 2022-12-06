// import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'models/user_model.dart';

// class AuthRepository {
//   Future<void> signup() async {
//     FirebaseAuth auth = FirebaseAuth.instance;
//     CollectionReference users = FirebaseFirestore.instance.collection('Users');

//     await FirebaseAuth.instance.verifyPhoneNumber(
//       phoneNumber: '+218912345678',
//       verificationCompleted: (PhoneAuthCredential credential) async {
//         await auth.signInWithCredential(credential).then(
//           (result) {
//             final user = UserModel(
//               id: result.user!.uid,
//               name: nameController.text,
//               username: phoneController.text,
//               phoneNumber: phoneController.text,
//               location: addressController.text,
//               password: passwordController.text,
//             ).toJson();

//             users.add(user).then(
//               (value) async {
//                 final prefs = await SharedPreferences.getInstance();

//                 prefs.setString(
//                   'user',
//                   jsonEncode(user),
//                 );

//                 print('user added and saved');
//               },
//             );
//           },
//         );
//       },
//       verificationFailed: (FirebaseAuthException e) {
//         if (e.code == 'invalid-phone-number') {
//           print('The provided phone number is not valid.');
//         }
//       },
//       codeSent: (String verificationId, int? resendToken) async {
//         // Update the UI - wait for the user to enter the SMS code
//         String smsCode = '123456';

//         // Create a PhoneAuthCredential with the code
//         PhoneAuthCredential credential = PhoneAuthProvider.credential(
//           verificationId: verificationId,
//           smsCode: smsCode,
//         );

//         // Sign the user in (or link) with the credential
//         await auth.signInWithCredential(credential);
//       },
//       timeout: const Duration(seconds: 60),
//       codeAutoRetrievalTimeout: (String verificationId) {},
//     );
//   }
// }
