import 'package:flutter/material.dart';

class NameWidget extends StatefulWidget {
  final Function(String) callback;
  final GlobalKey<FormState> formKey;

  const NameWidget({super.key, required this.callback, required this.formKey});

  @override
  NameWidgetState createState() => NameWidgetState();
}

class NameWidgetState extends State<NameWidget> {
  late String _textFieldValue;
  bool _isInputValid = true;

  void _updateName(String newValue) {
    setState(() {
      _textFieldValue = newValue;
      _isInputValid = _validateInput(_textFieldValue);
    });

    // Invoke the callback function in the parent widget
    if (_isInputValid) {
      widget.callback(_textFieldValue);
    }
  }

  bool _validateInput(String? input) {
    if (input == "" || input == null) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0, right: 4.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: const Center(
              child: Text(
                'ชื่อ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
                top: 10.0, left: 42.0), // Adjust the left padding here
            child: TextFormField(
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'กรุณากรอกชื่อ';
                }
                return null;
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(
                    left: 8.0), // Adjust the left padding here
                hintText: 'สมศักดิ์',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                errorText: _isInputValid ? null : 'กรุณากรอกชื่อ',
              ),
              onChanged: (value) {
                _updateName(value);
              },
              onEditingComplete: () {
                setState(() {
                  _isInputValid = _validateInput(_textFieldValue);
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
