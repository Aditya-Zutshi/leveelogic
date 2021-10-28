import 'package:auto_route/annotations.dart';
import 'package:leveelogic/login/login.dart';
import 'package:leveelogic/projects_page/projects_page.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: LoginPage, initial: true),
    AutoRoute(page: ProjectsPage),
    AutoRoute(page: EmailSignInPage),
  ],
)
class $AppRouter {}
