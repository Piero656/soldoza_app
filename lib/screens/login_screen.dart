import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soldoza_app/global_variables.dart';
import 'package:soldoza_app/providers/auth_provider.dart';
import 'package:soldoza_app/providers/discipline_provider.dart';
import 'package:soldoza_app/providers/plant_provider.dart';
import 'package:soldoza_app/providers/project_provider.dart';
import 'package:soldoza_app/services/push_notification_service.dart';

import '../theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final projectProvider = Provider.of<ProjectProvider>(context);
    final plantProvider = Provider.of<PlantProvider>(context);
    final disciplineProvider = Provider.of<DisciplineProvider>(context);

    final GlobalKey<FormState> myFormKey = GlobalKey<FormState>();

    final Map<String, String> formValues = {
      'username': '',
      'password': '',
    };

    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          // SizedBox(
          //   height: 300,
          // ),
          Padding(
            padding: const EdgeInsets.only(
                top: 150, bottom: 50, left: 25, right: 25),
            child: Container(
              width: double.infinity,
              // color: Colors.orange,
              decoration: _createCardShape(),
              child: Form(
                key: myFormKey,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // const Icon(
                      //   Icons.playlist_add,
                      //   color: AppTheme.orangeColor,
                      //   size: 150,
                      // ),
                      Image.asset(
                        'assets/img1.jpeg',
                        width: double.infinity,
                        height: 400,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      _CustomTextField(
                        formValues: formValues,
                        formField: "username",
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      TextFormField(
                        key: const Key('password'),
                        initialValue: "",
                        obscureText: true,
                        // textCapitalization: TextCapitalization.words,
                        onChanged: (value) {
                          formValues['password'] = value;
                        },
                        validator: (value) {
                          if (value == null) return 'Required field';
                          return value.length < 3 ? 'Min 3 characters' : null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppTheme.orangeColor)),
                          hintText: "Password",
                          labelText: "Password",
                          labelStyle: TextStyle(color: AppTheme.orangeColor),
                          prefixIcon: Icon(
                            Icons.key_outlined,
                            color: AppTheme.orangeColor,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      ElevatedButton(
                          onPressed: authProvider.isLoading
                              ? null
                              : () async {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());

                                  // FocusScopeNode currentFocus =
                                  //     FocusScope.of(context);

                                  // if (!currentFocus.hasPrimaryFocus) {
                                  //   currentFocus.unfocus();
                                  // }

                                  if (!myFormKey.currentState!.validate()) {
                                    return;
                                  }

                                  String token = await authProvider.login(
                                      formValues['username']!,
                                      formValues['password']!);

                                  if (token.isNotEmpty) {
                                    await PushNotificationService.getToken();

                                    await projectProvider.getProjectsByUser(
                                        Global.userMap["id"].toString());
                                    await plantProvider.getPlantByUserId(
                                        Global.userMap["id"].toString());
                                    await disciplineProvider
                                        .getDisciplinesByUserId(
                                            Global.userMap["id"].toString());

                                    await authProvider.updateFirebaseToken(
                                        PushNotificationService.token ?? '',
                                        authProvider.userMap['id'].toString());

                                    if (!mounted) return;
                                    Navigator.pushReplacementNamed(
                                        context, 'home');
                                  } else {
                                    const text = 'User or password Incorrects';
                                    const snackBar =
                                        SnackBar(content: Text(text));

                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                },
                          // child: Text("go"),
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            )),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                AppTheme.orangeColor),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Text(
                              "Login",
                              style: TextStyle(fontSize: 15),
                            ),
                          ))
                    ],
                  ),
                ),
              ),
            ),
          )
        ])),
      ),
    );
  }

  BoxDecoration _createCardShape() => BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [
            BoxShadow(
                color: Colors.black38, blurRadius: 15, offset: Offset(0, 0))
          ]);
}

class _CustomTextField extends StatelessWidget {
  const _CustomTextField({
    Key? key,
    required this.formValues,
    required this.formField,
  }) : super(key: key);

  final Map<String, dynamic> formValues;
  final String formField;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: "",
      onChanged: (value) {
        formValues[formField] = value;
        // print(value);
      },
      validator: (value) {
        if (value == null) {
          return 'Required field';
        }
        return value.length < 3 ? 'Min 3 characters' : null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: const InputDecoration(
        border: InputBorder.none,
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppTheme.orangeColor)),
        hintText: "Username",
        labelText: "Username",
        labelStyle: TextStyle(color: AppTheme.orangeColor),
        prefixIcon: Icon(
          Icons.person_outline,
          color: AppTheme.orangeColor,
        ),
      ),
    );
  }
}
