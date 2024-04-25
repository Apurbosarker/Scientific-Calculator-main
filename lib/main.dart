import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'dart:math' as math;

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Scientific Calculator",
    theme: ThemeData(primarySwatch: Colors.purple, brightness: Brightness.dark),
    home: const CalculatorScreen(),
  ));
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '';

  final List<String> _buttonValues = [
    'sqrt',
    'sin',
    'cos',
    'tan',
    'sec',
    'csc',
    'log',
    'exp',
    'x!',
    'ln',
    'log10',
    'sin^-1',
    'cos^-1',
    'tan^-1',
    '%',
    '7',
    '8',
    '9',
    "DEL",
    'AC',
    '4',
    '5',
    '6',
    '*',
    '/',
    '1',
    '2',
    '3',
    '+',
    '-',
    '0',
    '.',
    '='
  ];

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'AC') {
        _display = '';
      } else if (value == 'DEL') {
        if (_display.isNotEmpty) {
          _display = _display.substring(0, _display.length - 1);
        }
      } else if (value == '=') {
        _display = performCalculation();
      } else if (value == 'sqrt') {
        _display = (math.sqrt(double.parse(_display))).toString();
      } else if (value == 'sin') {
        _display = (math.sin(double.parse(_display))).toString();
      } else if (value == 'cos') {
        _display = (math.cos(double.parse(_display))).toString();
      } else if (value == 'tan') {
        _display = (math.tan(double.parse(_display))).toString();
      } else if (value == 'sec') {
        _display = (1 / math.cos(double.parse(_display))).toString();
      } else if (value == 'csc') {
        _display = (1 / math.sin(double.parse(_display))).toString();
      } else if (value == 'log') {
        _display = performLogarithm(double.parse(_display));
      } else if (value == 'exp') {
        _display = (math.exp(double.parse(_display))).toString(); // Exponential
      } else if (value == 'x!') {
        _display = calculateFactorial(double.parse(_display));
      } else if (value == 'ln') {
        _display =
            (math.log(double.parse(_display))).toString(); // Natural logarithm
      } else if (value == 'log10') {
        _display = (math.log(double.parse(_display)))
            .toString(); // Base-10 logarithm
      } else if (value == 'sin^-1') {
        _display =
            (math.asin(double.parse(_display))).toString(); // Inverse sine
      } else if (value == 'cos^-1') {
        _display =
            (math.acos(double.parse(_display))).toString(); // Inverse cosine
      } else if (value == 'tan^-1') {
        _display =
            (math.atan(double.parse(_display))).toString(); // Inverse tangent
      } else if (value == '%') {
        _display = performModulus(); // Modulus operation
      } else {
        _display += value;
      }
    });
  }

  String performModulus() {
    try {
      var operands = _display.split('%');
      if (operands.length >= 2) {
        double dividend = double.parse(operands[0]);
        double divisor = double.parse(operands[1]);
        double result = dividend % divisor;
        return result.toString();
      } else {
        return "Error: Insufficient operands for modulus operation";
      }
    } catch (e) {
      return "Error: Invalid modulus operation";
    }
  }

  String performLogarithm(double number) {
    return math.log(number).toString(); // Natural logarithm
  }

  String calculateFactorial(double number) {
    if (number < 0) {
      return "Error: Factorial is not defined for negative numbers.";
    }
    int factorial = 1;
    for (int i = 1; i <= number.toInt(); i++) {
      factorial *= i;
    }
    return factorial.toString();
  }

  String performCalculation() {
    try {
      // Evaluating the expression
      Parser p = Parser();
      Expression exp = p.parse(_display);
      ContextModel cm = ContextModel();
      double result = exp.evaluate(EvaluationType.REAL, cm);
      return result.toString();
    } catch (e) {
      return "Error during calculation: $e";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scientific Calculator'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              _display,
              style: const TextStyle(fontSize: 24.0),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height *
                0.6, // Adjust height as needed
            child: GridView.count(
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
              crossAxisCount: 5,
              shrinkWrap: true,
              children: _buttonValues.map((value) {
                return CalculatorButton(
                  text: value,
                  onPressed: () => _onButtonPressed(value),
                  width: 0,
                  height: 0,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class CalculatorButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double width;
  final double height;

  const CalculatorButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isNumberButton = RegExp(r'^[0-9]$').hasMatch(text);
    final isSymbolButton = RegExp(r'^[=,.%]$').hasMatch(text);

    return MaterialButton(
      onPressed: onPressed,
      color: isNumberButton ? Colors.black : Colors.purple,
      height: height,
      minWidth: width,
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    );
  }
}
