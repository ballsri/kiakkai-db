import 'package:flutter/material.dart';

class PrefixWidget extends StatefulWidget {
  final Function(String) callback;

  final GlobalKey<FormState> formKey;

  const PrefixWidget(
      {super.key, required this.callback, required this.formKey});

  @override
  PrefixWidgetState createState() => PrefixWidgetState();
}

class PrefixWidgetState extends State<PrefixWidget> {
  late String _textFieldValue;
  bool _isInputValid = true;

  void _updatePrefix(String newValue) {
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
          padding: const EdgeInsets.only(
            top: 10.0,
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: const Center(
              child: Text(
                'คำนำหน้า',
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
            padding: const EdgeInsets.only(top: 10.0, left: 8.0),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'กรุณากรอกคำนำหน้า';
                }
                return null;
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 8.0),
                hintText: 'พล.ร.ท',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                errorText: _isInputValid ? null : 'กรุณากรอกคำนำหน้า',
              ),
              onChanged: (value) {
                _updatePrefix(value);
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
