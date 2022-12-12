import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:wuzzufy/providers/UsersProvider.dart';
import 'package:wuzzufy/screens/auth/LoginScreen.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    UsersProvider usersProvider =
        Provider.of<UsersProvider>(context, listen: false);

    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 100,
              ),
              Text(
                "#وظايفي",
                style: TextStyle(fontSize: 40),
              ),
              Text(
                "اكبر تجمع وظايف بين ايديك",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              SizedBox(
                height: 20,
              ),
              nameTextField(context, usersProvider),
              SizedBox(
                height: 20,
              ),
              usernameTextField(context, usersProvider),
              SizedBox(
                height: 20,
              ),
              emailTextField(context, usersProvider),
              SizedBox(
                height: 20,
              ),
              //phoneTextField(context),
              //SizedBox(
              //  height: 20,
              //),
              passwordTextField(context, usersProvider),
              SizedBox(
                height: 20,
              ),
              signupBtn(context, usersProvider),
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child:
                        Divider(indent: 20, endIndent: 10, color: Colors.grey),
                  ),
                  Text(
                    "او",
                    style: TextStyle(color: Colors.grey),
                  ),
                  Expanded(
                    child:
                        Divider(indent: 10, endIndent: 20, color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                      onPressed: () {
                        usersProvider.signUpWithFacebook(context);
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.indigoAccent,
                        ),
                        child: Icon(
                          FontAwesome.facebook,
                          color: Colors.white,
                        ),
                      )),
                  FlatButton(
                      onPressed: () {
                        usersProvider.signUpWithGoogle(context);
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.deepOrange,
                        ),
                        child: Icon(
                          FontAwesome.google,
                          color: Colors.white,
                        ),
                      )),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "بالفعل لدي حساب",
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  LoginScreen()));
                    },
                    child: Text(
                      "دخول",
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  usernameTextField(context, usersProvider) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: TextFormField(
          onSaved: (newValue) {
            usersProvider.username = newValue;
          },
          validator: RequiredValidator(errorText: "ادخل اسم المستخدم"),
          decoration: InputDecoration(
            labelText: "اسم المستخدم",
            labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(20)),
            errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.redAccent),
                borderRadius: BorderRadius.circular(20)),
            focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red[300]),
                borderRadius: BorderRadius.circular(20)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                    color: Theme.of(context).accentColor, width: 1.0)),
            prefixIcon: const Icon(Icons.alternate_email),
          ),
          obscureText: false,
        ),
      ),
    );
  }

  nameTextField(context, usersProvider) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: TextFormField(
          onSaved: (newValue) {
            usersProvider.name = newValue;
          },
          validator: RequiredValidator(errorText: "ادخل الاسم"),
          decoration: InputDecoration(
            labelText: "الاسم",
            labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(20)),
            errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.redAccent),
                borderRadius: BorderRadius.circular(20)),
            focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red[300]),
                borderRadius: BorderRadius.circular(20)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                    color: Theme.of(context).accentColor, width: 1.0)),
            prefixIcon: const Icon(
              FontAwesome.user,
            ),
          ),
          obscureText: false,
        ),
      ),
    );
  }

  emailTextField(context, usersProvider) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: TextFormField(
          onSaved: (newValue) {
            usersProvider.email = newValue;
          },
          validator: MultiValidator([
            RequiredValidator(errorText: "ادخل البريد"),
            EmailValidator(errorText: "ادخل بريد صالح"),
          ]),
          decoration: InputDecoration(
            labelText: "البريد",
            labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(20)),
            errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.redAccent),
                borderRadius: BorderRadius.circular(20)),
            focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red[300]),
                borderRadius: BorderRadius.circular(20)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                    color: Theme.of(context).accentColor, width: 1.0)),
            prefixIcon: const Icon(
              Icons.email,
            ),
          ),
          obscureText: false,
        ),
      ),
    );
  }

  phoneTextField(context, usersProvider) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: TextFormField(
          onSaved: (newValue) {
            usersProvider.phone = newValue;
          },
          validator: RequiredValidator(errorText: "ادخل الهاتف"),
          decoration: InputDecoration(
            labelText: "الهاتف",
            labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
            errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.redAccent),
                borderRadius: BorderRadius.circular(20)),
            focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red[300]),
                borderRadius: BorderRadius.circular(20)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(20)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                    color: Theme.of(context).accentColor, width: 1.0)),
            prefixIcon: const Icon(
              FontAwesome.phone,
            ),
          ),
          obscureText: false,
        ),
      ),
    );
  }

  passwordTextField(context, usersProvider) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(
          right: 20,
          left: 20,
        ),
        child: TextFormField(
          onSaved: (newValue) {
            usersProvider.password = newValue;
          },
          validator: RequiredValidator(errorText: "ادخل كلمة السر"),
          obscureText: true,
          decoration: InputDecoration(
            labelText: "كلمة السر",
            labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
            hintStyle: TextStyle(fontSize: 14),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.grey, width: 1.0)),
            errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.redAccent),
                borderRadius: BorderRadius.circular(20)),
            focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red[300]),
                borderRadius: BorderRadius.circular(20)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                    color: Theme.of(context).accentColor, width: 1.0)),
            prefixIcon: const Icon(
              Icons.lock,
            ),
          ),
        ),
      ),
    );
  }

  signupBtn(context, usersProvider) {
    return Container(
      width: 200,
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Padding(
        padding: EdgeInsets.only(),
        child: TextButton.icon(
          icon: Icon(
            FontAwesome.sign_in,
            color: Colors.grey,
          ),
          onPressed: () async {
            if (!_formKey.currentState.validate()) {
              return;
            }

            _formKey.currentState.save();

            await usersProvider.signUpWithUsername(context);
          },
          label: Text(
            "تسجيل حساب جديد",
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
