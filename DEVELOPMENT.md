## Setup for development or local usage 

You will need to setup connections to the Google Maps and Firebase API yourself or you will get errors with authentication (probably 'unknown exception occured) or map display.

### Firebase

Add your firebase credentials in a file called firebase_config.js like

```js
export const firebaseConfig = {
  apiKey: "",
  authDomain: "",
  projectId: "",
  storageBucket: "",
  messagingSenderId: "",
  appId: ""
};
```

Be sure to [restrict access to the firebase API key](https://firebase.google.com/docs/projects/api-keys) for your domain(s) only.

### Google Maps

Add your own Google Maps API key in index.html, be sure to [restrict your key](https://developers.google.com/maps/api-security-best-practices) for your domain(s) only.

### VS code

Here is an example file (usualy ```.vscode/launch.json```) for the launch settings which will run the Flutter app on a fixed port number 8080.

```
{
    // Use IntelliSense to learn about possible attributes.
    // Hover to view descriptions of existing attributes.
    // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
    "version": "0.2.0",
    "configurations": [
        {
            "name": "leveelogic",
            "request": "launch",
            "type": "dart",
            "args": ["-d", "chrome","--web-port", "8080"],
        },
        {
            "name": "leveelogic (profile mode)",
            "request": "launch",
            "type": "dart",
            "flutterMode": "profile"
        },
        {
            "name": "authentication_repository",
            "cwd": "packages\\authentication_repository",
            "request": "launch",
            "type": "dart"
        },
        {
            "name": "authentication_repository (profile mode)",
            "cwd": "packages\\authentication_repository",
            "request": "launch",
            "type": "dart",
            "flutterMode": "profile"
        },
        {
            "name": "form_inputs",
            "cwd": "packages\\form_inputs",
            "request": "launch",
            "type": "dart"
        }
    ]
}```