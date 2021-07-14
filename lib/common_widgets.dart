import 'package:flutter/material.dart';

showLoaderDialog(BuildContext context){

  showDialog(barrierDismissible: false,
    context:context,
    builder:(BuildContext context){
      return WillPopScope(
        onWillPop: (){},
        child:Center(child: CircularProgressIndicator()),
      );
    },
  );
}

void  snackbar(GlobalKey<ScaffoldState> _scaffoldKey,String message){
  _scaffoldKey.currentState.showSnackBar(SnackBar(
    content: Text(message),
  ));
}
