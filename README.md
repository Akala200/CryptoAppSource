# sourcecodexchange

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.io/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.io/docs/cookbook)

For help getting started with Flutter, view our 
[online documentation](https://flutter.io/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.


Navigator.of(context)
                              .pushReplacement(PageRouteBuilder(
                                  pageBuilder: (_, __, ___) => bottomNavBar(
                                        themeBloc: _themeBloc,
                                      )));



   onTap: () async {
                              Loader.show(context,progressIndicator: CircularProgressIndicator(backgroundColor: Colors.blueGrey,),themeData: Theme.of(context).copyWith(accentColor: Colors.blueAccent));
                              final formState = _formKey.currentState;
                              if (formState.validate()) {
                                formState.save();
                                var ressp = await forgotPaasword(email);
                                if (ressp == 200){
                                  Loader.hide();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => verifyCode()),
                                  );
                                } else {
                                  Loader.hide();
                                  Toast.show(ressp, context, duration: Toast.LENGTH_LONG, backgroundColor: Colors.red,  gravity:  Toast.BOTTOM);
                                }
                              }
                            },