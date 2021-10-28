// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i3;
import 'package:flutter/material.dart' as _i4;

import '../login/login.dart' as _i1;
import '../projects_page/projects_page.dart' as _i2;

class AppRouter extends _i3.RootStackRouter {
  AppRouter([_i4.GlobalKey<_i4.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i3.PageFactory> pagesMap = {
    LoginRoute.name: (routeData) {
      return _i3.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i1.LoginPage());
    },
    ProjectsRoute.name: (routeData) {
      return _i3.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i2.ProjectsPage());
    },
    EmailSignInRoute.name: (routeData) {
      return _i3.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i1.EmailSignInPage());
    }
  };

  @override
  List<_i3.RouteConfig> get routes => [
        _i3.RouteConfig(LoginRoute.name, path: '/'),
        _i3.RouteConfig(ProjectsRoute.name, path: '/projects-page'),
        _i3.RouteConfig(EmailSignInRoute.name, path: '/email-sign-in-page')
      ];
}

/// generated route for [_i1.LoginPage]
class LoginRoute extends _i3.PageRouteInfo<void> {
  const LoginRoute() : super(name, path: '/');

  static const String name = 'LoginRoute';
}

/// generated route for [_i2.ProjectsPage]
class ProjectsRoute extends _i3.PageRouteInfo<void> {
  const ProjectsRoute() : super(name, path: '/projects-page');

  static const String name = 'ProjectsRoute';
}

/// generated route for [_i1.EmailSignInPage]
class EmailSignInRoute extends _i3.PageRouteInfo<void> {
  const EmailSignInRoute() : super(name, path: '/email-sign-in-page');

  static const String name = 'EmailSignInRoute';
}
