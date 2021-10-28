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