import 'package:emplanner/screens/register.dart';
import 'package:emplanner/screens/sign_in.dart';
import 'package:emplanner/widgets/buttons/main_button.dart';
import 'package:flutter/material.dart';

class WellcomeScreen extends StatelessWidget {
  const WellcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            child: Image.asset(
              'assets/images/shape.png',
            ),
          ),
          Column(
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top + 130),
              Image.asset(
                'assets/images/logo.png',
              ),
              const SizedBox(
                height: 50,
              ),
              Image.asset(
                'assets/images/wellcom_img.png',
              ),
              const SizedBox(
                height: 50,
              ),
              Text(
                'Get things done with TODO',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w900,
                      fontSize: 22,
                    ),
              ),
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 63),
                child: Text(
                  "Emplanner help you stay focused, manage time effectively, and accomplish tasks efficiently. Give it a try and experience its utility!",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withAlpha(190),
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              MainButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (ctx) => SignInScreen(),
                    ));
                  },
                  title: Text(
                    'Get Started',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
