import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/widgets/loader.dart';
import '../../../../core/utils/show_snackbar.dart';
import '../bloc/auth_bloc.dart';

class MyAuthConsumer extends StatelessWidget {
  const MyAuthConsumer({super.key,required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if(state is AuthFailure ){
              showSnackBar(context,state.message);
            } else if(state is AuthSuccess){
              Navigator.of(context).pushReplacementNamed('/');
            }
          },
          builder: (context, state) {
            if(state is AuthLoading){
              return const Loader();
            }
            return child;
          },
        ),
      ),
    );
  }
}
