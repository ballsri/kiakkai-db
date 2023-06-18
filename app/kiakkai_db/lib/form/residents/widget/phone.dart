import 'package:flutter/material.dart';

class PhoneWidget extends StatefulWidget {
  final Function(String) callback;
  final GlobalKey<FormState> formKey;

  const PhoneWidget({super.key, required this.callback, required this.formKey});

  @override
  PhoneWidgettState createState() => PhoneWidgettState();
}

class PhoneWidgettState extends State<PhoneWidget> {
  late String _textFieldValue;
  bool _isInputValid = true;

  void _updatePhone(String newValue) {
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
    final RegExp phoneRegex = RegExp(r'^0[0-9]{2} [0-9]{3} [0-9]{4}');
    if (phoneRegex.hasMatch(input)) {
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
                'เบอร์โทรศัพท์',
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
              maxLength: 12,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'กรุณากรอกเบอร์โทรศัพท์';
                }
                if (!_validateInput(value)) {
                  return 'กรุณากรอกเบอร์โทรศัพท์ให้ถูกต้อง';
                }
                return null;
              },
              decoration: InputDecoration(
                counterText: '',
                contentPadding: const EdgeInsets.only(left: 8.0),
                hintText: '099 999 9999',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                errorText: _isInputValid ? null : 'กรุณากรอกเว้นวรรคให้ถูกต้อง',
              ),
              onChanged: (value) {
                _updatePhone(value);
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
