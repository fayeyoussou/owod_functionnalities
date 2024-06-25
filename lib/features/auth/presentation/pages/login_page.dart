import 'package:owod_functionnalities/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:owod_functionnalities/features/auth/presentation/widgets/my_auth_consumer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_pallete.dart';
import '../../../../core/common/widgets/gradient_button.dart';
import '../widgets/auth_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyAuthConsumer(
        child: Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Sign in',
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 30,
          ),
          AuthField(
            hintText: 'Email',
            controller: emailController,
          ),
          const SizedBox(
            height: 15,
          ),
          AuthField(
              hintText: 'Password',
              controller: passwordController,
              obscure: true),
          const SizedBox(
            height: 15,
          ),
          GradientButton(
            message: 'Sign in',
            onPressed: () {
              if (formKey.currentState!.validate()) {
                context.read<AuthBloc>().add(AuthSignIn(
                    email: emailController.text.trim().toLowerCase(),
                    password: passwordController.text.trim()));
              }
            },
          ),
          const SizedBox(
            height: 15,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/signup');
            },
            child: RichText(
                text: TextSpan(
                    text: 'Don\'t have an account? ',
                    style: Theme.of(context).textTheme.titleMedium,
                    children: [
                  TextSpan(
                    text: 'Sign up',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppPalette.gradient2,
                        fontWeight: FontWeight.bold),
                  )
                ])),
          )
        ],
      ),
    ));
  }
}
