import 'package:flutter/material.dart';

void main() => runApp(const CalculatorApp());

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5B5BD6),
          brightness: Brightness.dark,
        ),
      ),
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _display = '0';
  String _expression = '';
  double? _firstValue;
  String? _operation;
  bool _replaceDisplay = false;

  void _press(String key) {
    setState(() {
      if ('0123456789'.contains(key)) {
        _enterDigit(key);
      } else {
        switch (key) {
          case '.':
            _enterDecimal();
          case 'AC':
            _clear();
          case '⌫':
            _backspace();
          case '±':
            _toggleSign();
          case '%':
            _percent();
          case '+':
          case '−':
          case '×':
          case '÷':
            _chooseOperation(key);
          case '=':
            _calculate();
        }
      }
    });
  }

  void _enterDigit(String digit) {
    if (_display == 'Error' || _replaceDisplay) {
      _display = digit;
      _replaceDisplay = false;
    } else if (_display == '0') {
      _display = digit;
    } else {
      _display += digit;
    }
  }

  void _enterDecimal() {
    if (_display == 'Error' || _replaceDisplay) {
      _display = '0.';
      _replaceDisplay = false;
    } else if (!_display.contains('.')) {
      _display += '.';
    }
  }

  void _clear() {
    _display = '0';
    _expression = '';
    _firstValue = null;
    _operation = null;
    _replaceDisplay = false;
  }

  void _backspace() {
    if (_display == 'Error' || _replaceDisplay) {
      _display = '0';
      _replaceDisplay = false;
      return;
    }
    _display = _display.length > 1
        ? _display.substring(0, _display.length - 1)
        : '0';
    if (_display == '-' || _display.isEmpty) _display = '0';
  }

  void _toggleSign() {
    if (_display == '0' || _display == 'Error') return;
    _display = _display.startsWith('-') ? _display.substring(1) : '-$_display';
  }

  void _percent() {
    if (_display == 'Error') return;
    final value = double.tryParse(_display);
    if (value != null) {
      _display = _format(value / 100);
    }
  }

  void _chooseOperation(String operation) {
    if (_display == 'Error') return;
    if (_operation != null && !_replaceDisplay) _calculate();
    _firstValue = double.tryParse(_display);
    _operation = operation;
    _expression = '$_display $operation';
    _replaceDisplay = true;
  }

  void _calculate() {
    final secondValue = double.tryParse(_display);
    if (_firstValue == null || _operation == null || secondValue == null) {
      return;
    }

    final left = _firstValue!;
    double? result;
    switch (_operation) {
      case '+':
        result = left + secondValue;
      case '−':
        result = left - secondValue;
      case '×':
        result = left * secondValue;
      case '÷':
        result = secondValue == 0 ? null : left / secondValue;
    }

    _expression = '$_firstValue $_operation $_display =';
    _display = result == null ? 'Error' : _format(result);
    _firstValue = null;
    _operation = null;
    _replaceDisplay = true;
  }

  String _format(double value) {
    if (value.isInfinite || value.isNaN) return 'Error';
    if (value == value.roundToDouble()) return value.toInt().toString();
    return value
        .toStringAsPrecision(12)
        .replaceFirst(RegExp(r'0+$'), '')
        .replaceFirst(RegExp(r'\.$'), '');
  }

  @override
  Widget build(BuildContext context) {
    const keys = [
      ['AC', '⌫', '%', '÷'],
      ['7', '8', '9', '×'],
      ['4', '5', '6', '−'],
      ['1', '2', '3', '+'],
      ['±', '0', '.', '='],
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF16161D),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Calculator',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      _expression,
                      style: const TextStyle(
                        color: Color(0xFF9C9CA7),
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        _display,
                        key: const Key('display'),
                        style: const TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  for (final row in keys)
                    Expanded(
                      child: Row(
                        children: [
                          for (final key in row)
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: _CalculatorButton(
                                  label: key,
                                  kind: _buttonKind(key),
                                  onPressed: () => _press(key),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _ButtonKind _buttonKind(String key) {
    if (key == '=') return _ButtonKind.equals;
    if ('÷×−+'.contains(key)) return _ButtonKind.operator;
    if (['AC', '⌫', '%', '±'].contains(key)) return _ButtonKind.utility;
    return _ButtonKind.number;
  }
}

enum _ButtonKind { number, utility, operator, equals }

class _CalculatorButton extends StatelessWidget {
  const _CalculatorButton({
    required this.label,
    required this.kind,
    required this.onPressed,
  });
  final String label;
  final _ButtonKind kind;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final color = switch (kind) {
      _ButtonKind.number => const Color(0xFF292931),
      _ButtonKind.utility => const Color(0xFF40404A),
      _ButtonKind.operator => const Color(0xFF5B5BD6),
      _ButtonKind.equals => const Color(0xFF8B5CF6),
    };
    return SizedBox.expand(
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: const TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
        ),
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}
