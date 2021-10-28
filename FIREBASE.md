## Some helpful stuff for firebase

### Delete all user accounts

This might be helpful during testing where you can get a lot of anonymous logins. Note that this will remove **all users** so be aware of that.

* Open chrome and navigate to the Firebase website
* Select your project and open the Authentication tab (which should show a list of current authenticated users)
* Use F12 to open the DevTools and switch to the console
* Use the following code in the console;

**WARNING -> THIS WILL DELETE ALL USERS!**

```js
$('.edit-account-button').click();

$('.mat-menu-content button:last-child').click()

$('.fire-dialog-actions .confirm-button').click()
```