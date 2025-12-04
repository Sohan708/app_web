import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void manageHttpResponse({
  required http.Response response, //the HTTP response from the request
  required BuildContext context, //the context is to show the snackbar
  required VoidCallback
  onSuccess, //the callback to execute on a successful response
}) {
  //switch case to handle different HTTP status codes
  switch (response.statusCode) {
    case 200: //status code 200 means the request was successful
      onSuccess();
      break;
    case 400: //status code 400 means the request was bad
      showSnackbar(context: context, title: json.decode(response.body)['msg']);
      break;
    case 500: //status code 500 means the server error
      showSnackbar(
        context: context,
        title: json.decode(response.body)['error'],
      );
      break;
    case 201: //status code 201 means a resource was created successfully
      onSuccess();
      break;
  }
}

void showSnackbar({required BuildContext context, required String title}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(title)));
}
