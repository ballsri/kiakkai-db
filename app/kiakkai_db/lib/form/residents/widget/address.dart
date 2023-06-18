import 'package:flutter/material.dart';

class AddressWidget extends StatefulWidget {
  final Function(String) callback;
  final GlobalKey<FormState> formKey;

  const AddressWidget(
      {super.key, required this.callback, required this.formKey});

  @override
  AddressWidgetState createState() => AddressWidgetState();
}

class AddressWidgetState extends State<AddressWidget> {
  late String _textFieldValue;
  bool _isInputValid = true;

  void _updateAddress(String newValue) {
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
    final RegExp addressRegex =
        RegExp(r'^49\/[1-9]$|^49\/[1-9][0-9]$|^49\/1[0-2][0-9]$|^49\/133$');
    if (addressRegex.hasMatch(input)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: const Center(
              child: Text(
                'ห้อง',
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
            padding: const EdgeInsets.only(top: 10.0, left: 6.0),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'กรุณากรอกห้อง';
                }
                if (!_validateInput(value)) {
                  return 'ไม่มีห้องนี้ในระบบ';
                }
                return null;
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 6.0),
                hintText: '49/1',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                errorText: _isInputValid ? null : 'ไม่มีห้องนี้ในระบบ',
              ),
              onChanged: (value) {
                _updateAddress(value);
                // call its validator
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
