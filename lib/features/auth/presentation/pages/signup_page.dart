import 'package:owod_functionnalities/core/theme/app_pallete.dart';
import 'package:owod_functionnalities/core/common/widgets/gradient_button.dart';
import 'package:owod_functionnalities/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:owod_functionnalities/features/auth/presentation/widgets/auth_field.dart';
import 'package:owod_functionnalities/features/auth/presentation/widgets/my_auth_consumer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  SignupPageState createState() => SignupPageState();
}

class SignupPageState extends State<SignupPage> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (!RegExp(r'^[A-Za-z]').hasMatch(value)) {
      return 'Password must start with a letter';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MyAuthConsumer(
        child: Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Sign up',
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 30,
          ),
          AuthField(hintText: 'Name', controller: nameController),
          const SizedBox(
            height: 15,
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
            obscure: true,
            validator: _passwordValidator,
          ),
          const SizedBox(
            height: 15,
          ),
          GradientButton(
            message: 'Signup',
            onPressed: () {
              if (formKey.currentState!.validate()) {
                context.read<AuthBloc>().add(
                      AuthSignup(
                        email: emailController.text.trim().toLowerCase(),
                        password: passwordController.text.trim(),
                        name: nameController.text.trim(),
                      ),
                    );
              }
            },
          ),
          const SizedBox(
            height: 15,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/login');
            },
            child: RichText(
                text: TextSpan(
                    text: 'Already have an account? ',
                    style: Theme.of(context).textTheme.titleMedium,
                    children: [
                  TextSpan(
                    text: 'Sign in',
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
