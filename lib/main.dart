import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'buttons.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  const HomePage({super.key});

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
      backgroundColor: Colors.blue[100],
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            if (orientation == Orientation.portrait) {
              return Column(
                children: <Widget>[
                  Expanded(
                    child: _buildOutputDisplay(),
                  ),
                  Expanded(
                    flex: 4,
                    child: _buildButtonGrid(),
                  ),
                ],
              );
            } else {
              return Row(
                children: <Widget>[
                  Expanded(
                    child: _buildOutputDisplay(),
                  ),
                  Expanded(
                    flex: 2,
                    child: _buildButtonGrid(),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildOutputDisplay() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.centerRight,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                userInput,
                style: const TextStyle(
                    fontSize: 20, color: Color.fromARGB(255, 14, 62, 86)),
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
                    fontSize: 20,
                    color: Color.fromARGB(255, 14, 62, 86),
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
        ]);
  }

  Widget _buildButtonGrid() {
    return LayoutBuilder(builder: (context, constraints) {
      return GridView.builder(
          itemCount: buttons.length,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio:
                (constraints.maxWidth / 4) / (constraints.maxHeight / 5),
          ),
          itemBuilder: (BuildContext context, int index) {
            return _buildButton(buttons[index]);
          });
    });
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
