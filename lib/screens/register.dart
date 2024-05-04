// import 'package:emplanner/screens/sign_in.dart';
// import 'package:emplanner/widgets/combo_text_field.dart';
// import 'package:emplanner/widgets/main_button.dart';
// import 'package:flutter/material.dart';

// class RegisterScreen extends StatelessWidget {
//   const RegisterScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

//     return Scaffold(
//       body: Stack(
//         children: [
//           Positioned(
//             child: Image.asset('assets/images/shape.png'),
//           ),
//           SizedBox(
//             height: double.infinity,
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: EdgeInsets.fromLTRB(
//                     16,
//                     MediaQuery.of(context).padding.top + 130,
//                     16,
//                     keyboardSpace + 16),
//                 child: Column(
//                   children: [
//                     Image.asset(
//                       'assets/images/logo.png',
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     const Text(
//                       'Lets help you in completing your tasks',
//                     ),
//                     const SizedBox(
//                       height: 60,
//                     ),
//                     const ComboTextField(
//                       title: 'Fullname',
//                       hintText: 'Enter your fullname',
//                       isPassword: false,
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     const ComboTextField(
//                       title: 'Email',
//                       hintText: 'Enter your email',
//                       isPassword: false,
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     const ComboTextField(
//                       title: 'Password',
//                       hintText: 'Enter your password',
//                       isPassword: true,
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     const ComboTextField(
//                       title: 'Confirm Password',
//                       hintText: 'Enter confirm password',
//                       isPassword: true,
//                     ),
//                     const SizedBox(
//                       height: 50,
//                     ),
//                     MainButton(
//                       onPressed: () {},
//                       title: 'Register',
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Text(
//                           'Already have account?',
//                         ),
//                         TextButton(
//                           onPressed: () {
//                             Navigator.of(context).push(
//                               MaterialPageRoute(
//                                 builder: (ctx) => SignInScreen(),
//                               ),
//                             );
//                           },
//                           child: Text(
//                             'Sign in',
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .bodyMedium!
//                                 .copyWith(
//                                     fontWeight: FontWeight.bold,
//                                     color: const Color.fromARGB(
//                                         255, 250, 187, 24)),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
