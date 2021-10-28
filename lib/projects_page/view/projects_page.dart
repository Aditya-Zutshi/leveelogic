import 'package:authentication_repository/authentication_repository.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leveelogic/app/bloc/app_bloc.dart';
import 'package:leveelogic/router/approuter.gr.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LeveeLogic'),
        elevation: 2.0,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              context.read<AppBloc>().add(AppLogoutRequested());
              AutoRouter.of(context).replaceAll([const LoginRoute()]);
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Log out',
          ),
        ],
      ),
      body: RepositoryProvider(
        create: (context) => AuthenticationRepository(),
        child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('img/bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: const Center(
                child: Text(
              'Stay tuned for the coming changes!',
              style: TextStyle(color: Colors.white, fontSize: 30),
            ))),
      ),
    );
  }
}
