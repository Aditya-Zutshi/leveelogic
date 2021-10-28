import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leveelogic/login/cubit/login_cubit.dart';
import 'package:leveelogic/login/widgets/sign_in_button.dart';
import 'package:leveelogic/login/widgets/social_sign_in_button.dart';
import 'package:formz/formz.dart';
import 'package:leveelogic/router/approuter.gr.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Authentication Failure'),
              ),
            );
        } else if (state.status.isSubmissionSuccess) {
          context.replaceRoute(const ProjectsRoute());
        }
      },
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('img/bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        //color: Colors.red,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SignInButton(
                  text: 'Sign in with email',
                  textColor: Colors.white,
                  color: Colors.teal,
                  onPressed: () =>
                      AutoRouter.of(context).navigate(const EmailSignInRoute()),
                ),
                const SizedBox(height: 8.0),
                SocialSignInButton(
                  assetName: 'img/google-logo.png',
                  text: 'Sign in with Google',
                  textColor: Colors.black87,
                  color: Colors.white,
                  onPressed: () => context.read<LoginCubit>().logInWithGoogle(),
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'or',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8.0),
                SignInButton(
                  text: 'Go anonymous',
                  textColor: Colors.black,
                  color: Colors.lime,
                  onPressed: () =>
                      context.read<LoginCubit>().loginAnonymously(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
