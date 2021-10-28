## Notes for myself with common Flutter tasks

### Getting access to the AuthenticationRepository

Use ```context.read<AuthenticationRepository>()``` to connect to the authentication repository.

Example:

```dart
return RepositoryProvider(
    create: (context) => AuthenticationRepository(),
    child: Center(
        child: Text(context.read<AuthenticationRepository>().currentUser.id)),
);
```

### Setting up CI/CD deployment

Run ```firebase init``` and use the following options (be sure to check if nothing changed);

* use ```build/web``` as the public directory
* use the single-page app option
* setup the PR and merge automatic deployment steps
* add the next code as the second step to the generated yaml files to build the app

```
steps:
    - uses: actions/checkout@v2
    # START OF STEP TO ADD
    - run: >-
          sudo snap install flutter --classic && flutter upgrade && flutter config --enable-web &&
          flutter build web --release
    # END OF STEP TO ADD
    - uses: FirebaseExtended/action-hosting-deploy@v0 # this is already there
```

Note that ```flutter upgrade``` is used to fix a dependency issue since snap installs an old version of flutter. 