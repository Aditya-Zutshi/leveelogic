import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leveelogic/login/login.dart';
import 'package:formz/formz.dart';
import 'package:leveelogic/login/widgets/sign_in_button.dart';
import 'package:leveelogic/router/approuter.gr.dart';

enum EmailFormType {
  signIn,
  signUp,
}

class EmailSignInForm extends StatefulWidget {
  const EmailSignInForm({Key? key}) : super(key: key);

  @override
  State<EmailSignInForm> createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  EmailFormType _emailFormType = EmailFormType.signIn;

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
          AutoRouter.of(context).replaceAll([const ProjectsRoute()]);
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
            padding: const EdgeInsets.all(16.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: _buildChildren()),
          ),
        ),
      ),
    );
  }

  void toggleFormType() {
    setState(() {
      _emailFormType = _emailFormType == EmailFormType.signIn
          ? EmailFormType.signUp
          : EmailFormType.signIn;
    });
  }

  List<Widget> _buildChildren() {
    final toggleButtonText = _emailFormType == EmailFormType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Sign in';

    return [
      _EmailInput(),
      const SizedBox(height: 8.0),
      _PasswordInput(),
      const SizedBox(height: 8.0),
      _emailFormType == EmailFormType.signIn ? _LoginButton() : _SignUpButton(),
      const SizedBox(height: 8.0),
      _ToggleLoginSignUpButton(
        text: toggleButtonText,
        onPressed: toggleFormType,
      ),
    ];
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return SizedBox(
          width: 300.0,
          child: TextField(
            key: const Key('loginForm_emailInput_textField'),
            onChanged: (email) =>
                context.read<LoginCubit>().emailChanged(email),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white70,
              labelText: 'email',
              helperText: '',
              errorText: state.email.invalid ? 'invalid email' : null,
            ),
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return SizedBox(
          width: 300.0,
          child: TextField(
            key: const Key('loginForm_passwordInput_textField'),
            onChanged: (password) =>
                context.read<LoginCubit>().passwordChanged(password),
            obscureText: true,
            decoration: InputDecoration(
              errorStyle: const TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
              filled: true,
              fillColor: Colors.white70,
              labelText: 'password',
              errorMaxLines: 3,
              helperText: '',
              errorText: state.password.invalid
                  ? 'invalid password\nminimum 8 characters including uppercase,\nlowercase, digit and a special sign'
                  : null,
            ),
          ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : SignInButton(
                text: 'Sign in',
                textColor: Colors.white,
                color: Colors.teal,
                onPressed: state.status.isValidated
                    ? () => context.read<LoginCubit>().logInWithCredentials()
                    : () {},
              );
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : SignInButton(
                text: 'Sign up',
                textColor: Colors.white,
                color: Colors.teal,
                onPressed: state.status.isValidated
                    ? () => context.read<LoginCubit>().signUpWithCredentials()
                    : () {},
              );
      },
    );
  }
}

class _ToggleLoginSignUpButton extends StatelessWidget {
  const _ToggleLoginSignUpButton(
      {Key? key, required this.text, required this.onPressed})
      : super(key: key);

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: TextButton(
        style: TextButton.styleFrom(
          primary: Colors.white,
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
