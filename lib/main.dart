import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'buttons.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Abacus Calculator',
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    ); // MaterialApp
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userInput = '';
  String answer = '';

  // Array of button
  final List<String> buttons = [
    'C',
    '+/-',
    '%',
    'DEL',
    '7',
    '8',
    '9',
    '/',
    '4',
    '5',
    '6',
    'x',
    '1',
    '2',
    '3',
    '-',
    '0',
    '.',
    '=',
    '+',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Abacus Calculator"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[300],
      body: Column(
        children: <Widget>[
          Expanded(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(20),
                    alignment: Alignment.centerRight,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        userInput,
                        style: const TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(15),
                    alignment: Alignment.centerRight,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        answer,
                        style: const TextStyle(
                            fontSize: 30,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ]),
          ),
          Expanded(
            flex: 3,
            child: GridView.builder(
                itemCount: buttons.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4),
                itemBuilder: (BuildContext context, int index) {
                  return _buildButton(buttons[index]);
                }),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String buttonText) {
    VoidCallback? buttontapped;
    Color? color;
    Color? textColor;

    switch (buttonText) {
      case 'C':
        buttontapped = () => setState(() {
              userInput = '';
              answer = '0';
            });
        color = Colors.blue[50];
        textColor = Colors.black;
        break;
      case '+/-':
        buttontapped = () => setState(() {
              if (userInput.startsWith('-')) {
                userInput = userInput.substring(1);
              } else {
                userInput = '-$userInput';
              }
            });
        color = Colors.blue[50];
        textColor = Colors.black;
        break;
      case '%':
        buttontapped = () => setState(() => userInput += buttonText);
        color = Colors.blue[50];
        textColor = Colors.black;
        break;
      case 'DEL':
        buttontapped = () => setState(() {
              if (userInput.isNotEmpty) {
                userInput = userInput.substring(0, userInput.length - 1);
              }
            });
        color = Colors.blue[50];
        textColor = Colors.black;
        break;
      case '=':
        buttontapped = () => setState(() => equalPressed());
        color = Colors.orange[700];
        textColor = Colors.white;
        break;
      default:
        buttontapped = () => setState(() => userInput += buttonText);
        if (isOperator(buttonText)) {
          color = Colors.blueAccent;
          textColor = Colors.white;
        } else {
          color = Colors.white;
          textColor = Colors.black;
        }
        break;
    }

    return MyButton(
      buttontapped: buttontapped,
      buttonText: buttonText,
      color: color,
      textColor: textColor,
    );
  }

  bool isOperator(String x) {
    if (x == '/' || x == 'X' || x == '-' || x == '+' || x == '=') {
      return true;
    }
    return false;
  }

// function to calculate the input operation
  void equalPressed() {
    String finaluserinput = userInput;
    finaluserinput = userInput.replaceAll('x', '*');

    try {
      Parser p = Parser();
      Expression exp = p.parse(finaluserinput);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      
      // Remove decimal point if result is an integer
      if (eval % 1 == 0) {
        answer = eval.toInt().toString();
      } else {
        answer = eval.toString();
      }
    } catch (e) {
      answer = "Error";
    }
  }
}
