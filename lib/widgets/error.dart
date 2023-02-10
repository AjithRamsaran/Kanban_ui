import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  final String errorMessage;

  final Function()? onRetryPressed;
  String buttonText;

  ErrorView(
      {required Key key,
        required this.errorMessage,
        required this.onRetryPressed,
        required this.buttonText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: 'Sorry',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins'),
                ),
                TextSpan(
                  text: ' !',
                  style: TextStyle(
                    color: Color(0xFFFBA500),
                    fontSize: 28,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ])),
          if (errorMessage.contains("No Products"))
            RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: 'No Products',
                    style: TextStyle(
                        color: Color(0xFFFBA500),
                        fontSize: 24,
                        fontFamily: 'Poppins'),
                  ),
                  TextSpan(
                    text: ' are added to this store',
                    style: TextStyle(
                        color: Colors.black, fontSize: 24, fontFamily: 'Poppins'),
                  ),
                ])),
          if (!errorMessage.contains("No Products"))
            Text(
              errorMessage,
              style: TextStyle(
                  color: Colors.black, //Color(0xFFFBA500),
                  fontSize: 24,
                  fontFamily: 'Poppins'),
            ),
          SizedBox(height: 20),
          Image.asset('assets/no_products.png',
              width: (MediaQuery.of(context).size.width -
                  4 -
                  (MediaQuery.of(context).padding.left +
                      MediaQuery.of(context).padding.right)) *
                  0.7),
          SizedBox(height: 20),
          if (onRetryPressed != null)
            ElevatedButton(
              //color: Colors.white,
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.green;
                    }
                    return Colors.white;
                  })),
              child: Text(buttonText != null ? buttonText : 'Retry',
                  style: TextStyle(color: Colors.black)),
              onPressed: onRetryPressed,
            ),
        ],
      ),
    );
  }
}
