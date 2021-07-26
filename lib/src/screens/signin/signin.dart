import 'package:crime_map/src/screens/home/home.dart';
import 'package:crime_map/src/screens/signin/signin.ui.dart';
import 'package:crime_map/src/services/account.services.dart';
import 'package:flutter/material.dart';

class SigninPage extends StatefulWidget {
  @override
  SigninView createState() => SigninView();
}

abstract class SigninPageState extends State<SigninPage> {
  late bool isLoading;
  late AccountService accountService;

  @override
  void initState() {
    super.initState();

    isLoading = false;
    accountService = AccountService();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void goBack() {
    Navigator.pop(context);
  }

  void openHomePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(),
      ),
    );
  }

  void googleSignIn() async {
    showLoadingButton();

    var res = await accountService.signInwithGoogle();
    print('_____:' + res.user!.email!);

    dismissLoadingButton();
    openHomePage();
  }

  void showLoadingButton() {
    setState(() {
      isLoading = true;
    });
  }

  void dismissLoadingButton() {
    setState(() {
      this.isLoading = false;
    });
  }
}
