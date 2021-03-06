import 'package:flutter/material.dart';
import 'widgets/NumberButton.dart';
import 'widgets/EqualButton.dart';
import 'widgets/zero_button.dart';
import 'widgets/binary_operator_button.dart';
import 'widgets/unary_operator_button.dart';
import 'constants.dart';

enum Operation {
  none,
  divide,
  multiply,
  subtract,
  add,
  clear,
  changeSign,
  addDecimal,
  percent,
  equals
}

enum BinaryOperation {
  divide,
  multiply,
  subtract,
  add,
}

enum UnaryOperation {
  changeSign,
  percent,
}

enum OtherOperation {
  clear,
  addDecimal,
  equals,
}

class CalculatorApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Binary Calculator',
      theme: new ThemeData(
        primaryColor: Color(0xFF474C50),
      ),
      home: new HomePage(title: 'Flutter Calculator Home Page'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Variables
  var operand1;
  var operand2;
  String operator;
  var result;
  bool isOperand1Completed;

  //Style
  TextStyle _whiteTextStyle = TextStyle(color: Colors.white, fontSize: 35.0);

  @override
  void initState() {
    super.initState();

    initialiseValues();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Theme.of(context).primaryColor,

      //---------------------
      //Cuerpo del Scaffold
      //---------------------
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        operand1 != null
                            ? SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  operand1 is double
                                      ? operand1.toStringAsFixed(2)
                                      : operand1.toString(),
                                  style: _whiteTextStyle,
                                  textAlign: TextAlign.right,
                                ),
                              )
                            : Container(),
                        operator != null
                            ? Text(
                                operator.toString(),
                                style: _whiteTextStyle,
                                textAlign: TextAlign.right,
                              )
                            : Container(),
                        operand2 != null
                            ? Text(
                                operand2.toString(),
                                style: _whiteTextStyle,
                                textAlign: TextAlign.right,
                              )
                            : Container(),
                        result != null
                            ? Divider(
                                height: 5.0,
                                color: Colors.white,
                              )
                            : Container(),
                        result != null
                            ? SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  result is double
                                      ? result.toStringAsFixed(2)
                                      : result.toString(),
                                  style: _whiteTextStyle,
                                  textAlign: TextAlign.right,
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ),

              //--------------------
              //Calculator Buttons
              //--------------------
              Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      NumberButton(
                        name: "ANS",
                        onPressed: () {
                          //AGREGAR FUNCION;
                        },
                      ),
                      NumberButton(
                        name: ".",
                        onPressed: () {
                          _otherOperationAction(OtherOperation.addDecimal);
                        },
                      ),
                      NumberButton(
                        name: "0",
                        onPressed: () {
                          _zeroButtonAction();
                        },
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      NumberButton(
                        name: "DEL",
                        onPressed: () {
                          _otherOperationAction(OtherOperation.clear);
                        },
                      ),
                      NumberButton(
                        name: "+/-",
                        onPressed: () {
                          _unaryOperationAction(UnaryOperation.changeSign);
                        },
                      ),
                      NumberButton(
                        name: "1",
                        onPressed: () {
                          _numberButtonAction("1");
                        },
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          BinaryOperatorButton(
                            name: divide_sign,
                            onPressed: () {
                              _binaryOperationAction(BinaryOperation.divide);
                            },
                          ),
                          BinaryOperatorButton(
                            name: "-",
                            onPressed: () {
                              _binaryOperationAction(BinaryOperation.subtract);
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          BinaryOperatorButton(
                            name: multiply_sign,
                            onPressed: () {
                              _binaryOperationAction(BinaryOperation.multiply);
                            },
                          ),
                          BinaryOperatorButton(
                            name: add_sign,
                            onPressed: () {
                              _binaryOperationAction(BinaryOperation.add);
                            },
                          ),
                        ],
                      ),
                      EqualButton(
                        name: equal_sign,
                        onPressed: () {
                          _otherOperationAction(OtherOperation.equals);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void initialiseValues() {
    operand1 = null;
    operand2 = null;
    result = null;
    operator = null;
    isOperand1Completed = false;
  }

  void _findOutput() {
    if (operand1 == null || operand2 == null) return;
    var exp1 = double.parse(operand1.toString());
    var exp2 = double.parse(operand2.toString());
    switch (operator) {
      case add_sign:
        result = exp1 + exp2;
        break;
      case minus_sign:
        result = exp1 - exp2;
        break;
      case multiply_sign:
        result = exp1 * exp2;
        break;
      case divide_sign:
        result = exp1 / exp2;
        break;
      case percent_sign:
        result = exp1 % exp2;
        break;
    }
    if (result.toString().endsWith(".0")) {
      result = int.parse(result.toString().replaceAll(".0", ""));
    }
  }

  void _numberButtonAction(String text) {
    if (result != null) initialiseValues();
    if (isOperand1Completed) {
      if (operand2 == null) {
        operand2 = text;
      } else {
        if (operand2.toString().length < 9) operand2 += text;
      }
    } else {
      if (operand1 == null) {
        operand1 = text;
      } else {
        if (operand1.toString().length < 9) operand1 += text;
      }
    }
    setState(() {});
  }

  void _zeroButtonAction() {
    if (result != null) initialiseValues();
    if (isOperand1Completed) {
      if (operand2 == null || operand1 == "0")
        operand2 = "0";
      else {
        if (operand2.toString().length < 9) operand2 += "0";
      }
    } else {
      if (operand1 == null || operand1 == "0") {
        operand1 = "0";
      } else {
        if (operand1.toString().length < 9) operand1 += "0";
      }
    }
    setState(() {});
  }

  void _binaryOperationAction(BinaryOperation operation) {
    switch (operation) {
      case BinaryOperation.add:
        if (operand2 != null) {
          if (result == null) _findOutput();
          operand1 = result;
          operand2 = null;
          result = null;
        }
        operator = add_sign;
        isOperand1Completed = true;
        break;
      case BinaryOperation.subtract:
        if (operand2 != null) {
          if (result == null) _findOutput();
          operand1 = result;
          operand2 = null;
          result = null;
        }
        operator = minus_sign;
        isOperand1Completed = true;
        break;
      case BinaryOperation.multiply:
        if (operand2 != null) {
          if (result == null) _findOutput();
          operand1 = result;
          operand2 = null;
          result = null;
        }
        operator = multiply_sign;
        isOperand1Completed = true;
        break;
      case BinaryOperation.divide:
        if (operand2 != null) {
          if (result == null) _findOutput();
          operand1 = result;
          operand2 = null;
          result = null;
        }
        operator = divide_sign;
        isOperand1Completed = true;
        break;
    }
    setState(() {});
  }

  void _unaryOperationAction(UnaryOperation operation) {
    switch (operation) {
      case UnaryOperation.changeSign:
        if (result != null)
          result = -result;
        else if (isOperand1Completed) {
          if (operand2 != null) {
            operand2 = (-int.parse(operand2)).toString();
          }
        } else {
          if (operand1 != null) {
            operand1 = (-int.parse(operand1)).toString();
          }
        }
        break;
      case UnaryOperation.percent:
        if (result != null)
          result = result / 100;
        else if (isOperand1Completed) {
          if (operand2 != null) {
            operand2 = (double.parse(operand2) / 100).toString();
          }
        } else {
          if (operand1 != null) {
            operand1 = (double.parse(operand1) / 100).toString();
          }
        }
        break;
    }
    setState(() {});
  }

  _otherOperationAction(OtherOperation operation) {
    switch (operation) {
      case OtherOperation.clear:
        initialiseValues();
        break;
      case OtherOperation.addDecimal:
        if (result != null) initialiseValues();
        if (isOperand1Completed) {
          if (!operand2.toString().contains(".")) {
            if (operand2 == null) {
              operand2 = ".";
            } else {
              operand2 += ".";
            }
          }
        } else {
          if (!operand1.toString().contains(".")) {
            if (operand1 == null) {
              operand1 = ".";
            } else {
              operand1 += ".";
            }
          }
        }
        break;
      case OtherOperation.equals:
        if (result == null) _findOutput();

        break;
    }
    setState(() {});
  }
}
