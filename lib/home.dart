import 'package:flutter/material.dart';

class MeasureConverter extends StatefulWidget {
  const MeasureConverter({super.key});

  @override
  State<MeasureConverter> createState() => _MeasureConverterState();
}

class _MeasureConverterState extends State<MeasureConverter> {
  double _userinput = 0.0;
  String? _convertedmeasure;
  String? _errormessage;
  String? _startvalue;
  String? _selectedcategory = 'Length';

  final Map<String, List<String>> unitcategories = {
    'Length': ['Meters', 'Kilometers', 'Feet', 'Miles'],
    'Weight': ['Grams', 'Kilograms (kg)', 'Pounds (lbs)', 'Ounces'],
    'Temperature': ['Celsius', 'Fahrenheit', 'Kelvin'],
  };

  final Map<String, Map<String, int>> measuresMap = {
    'Length': {
      'Meters': 0,
      'Kilometers': 1,
      'Feet': 2,
      'Miles': 3,
    },
    'Weight': {
      'Grams': 0,
      'Kilograms (kg)': 1,
      'Pounds (lbs)': 2,
      'Ounces': 3,
    },
    'Temperature': {
      'Celsius': 0,
      'Fahrenheit': 1,
      'Kelvin': 2,
    },
  };

  final Map<String, List<List<double>>> formula = {
    'Length': [
      [1, 0.001, 3.28084, 0.000621371],
      [1000, 1, 3280.84, 0.621371],
      [0.3048, 0.0003048, 1, 0.000189394],
      [1609.34, 1.60934, 5280, 1],
    ],
    'Weight': [
      [1, 0.001, 0.00220462, 0.035274],
      [1000, 1, 2.20462, 35.274],
      [453.592, 0.453592, 1, 16],
      [28.3495, 0.0283495, 0.0625, 1],
    ],
  };

  void _convertion(double value, String from, String to, String category) {
    if (category == 'Temperature') {
      _temperature(value, from, to);
      return;
    }

    int? fromindex = measuresMap[category]?[from];
    int? toindex = measuresMap[category]?[to];

    if (fromindex == null || toindex == null) {
      setState(() {
        _errormessage = 'Invalid conversion units!!!';
      });
      return;
    }

    var multiplier = formula[category]![fromindex][toindex];
    var result = value * multiplier;

    setState(() {
      _errormessage =
          '$_userinput $_startvalue = ${result.toStringAsFixed(3)} $_convertedmeasure';
    });
  }

  void _temperature(double value, String from, String to) {
    double result;
    if (from == to) {
      result = value;
    } else if (from == 'Celsius' && to == 'Fahrenheit') {
      result = (value * 9 / 5) + 32;
    } else if (from == 'Celsius' && to == 'Kelvin') {
      result = value + 273.15;
    } else if (from == 'Fahrenheit' && to == 'Celsius') {
      result = (value - 32) * 5 / 9;
    } else if (from == 'Fahrenheit' && to == 'Kelvin') {
      result = (value - 32) * 5 / 9 + 273.15;
    } else if (from == 'Kelvin' && to == 'Celsius') {
      result = value - 273.15;
    } else if (from == 'Kelvin' && to == 'Fahrenheit') {
      result = (value - 273.15) * 9 / 5 + 32;
    } else {
      setState(() {
        _errormessage = 'Cannot perform this conversion!!!';
      });
      return;
    }

    setState(() {
      _errormessage ='$_userinput $_startvalue = ${result.toStringAsFixed(3)} $_convertedmeasure';
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      screenWidth *= 0.8;
    }

    List<String> units = unitcategories[_selectedcategory!]!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Unit Converter',
          style: TextStyle(
            fontSize: 26, 
            fontWeight: FontWeight.bold, 
            color: Colors.white, 
            letterSpacing: 2, 
            fontStyle: FontStyle.italic,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Select a Category:',
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueAccent),
          ),
          Tooltip(
            message: 'Select a category for conversion (Length, Weight, Temperature)',
            child: DropdownButtonFormField<String>(
              value: _selectedcategory,
              items: unitcategories.keys.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedcategory = value;
                  _startvalue = null;
                  _convertedmeasure = null;
                  _errormessage = null;
                });
              },
            ),
          ),
          const SizedBox(height: 20),
          Tooltip(
            message: 'Enter the value you want to convert',
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Enter value to convert:',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w500, color: Colors.blueAccent),
              keyboardType: TextInputType.number,
              onChanged: (text) {
                var input = double.tryParse(text);
                if (input != null) {
                  setState(() {
                    _userinput = input;
                  });
                }
              },
            ),
          ),
          const SizedBox(height: 20),
          Tooltip(
            message: 'Select the unit you want to convert from',
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'From :',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w500, color: Colors.blueAccent),
              value: _startvalue,
              items: units.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _startvalue = value;
                });
              },
            ),
          ),
          const SizedBox(height: 20),
          Tooltip(
            message: 'Select the unit you want to convert to',
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'To:',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w500, color: Colors.blueAccent),
              value: _convertedmeasure,
              items: units.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _convertedmeasure = value;
                });
              },
            ),
          ),
          const SizedBox(height: 20),
          Tooltip(
            message: 'Click to convert the value from one unit to another',
            child: ElevatedButton(
              onPressed: () {
                if (_startvalue == null ||
                    _convertedmeasure == null ||
                    _userinput == 0) {
                  setState(() {
                    _errormessage = 'Please fill all fields!!!';
                  });
                  return;
                }
                _convertion(
                    _userinput, _startvalue!, _convertedmeasure!, _selectedcategory!);
              },
              child: const Text('Convert:'),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            _errormessage ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.w500, color: Colors.blueAccent),
          ),
        ],
      ),
    );
  }
}