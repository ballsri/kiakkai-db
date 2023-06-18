import 'package:flutter/material.dart';

class CidWidget extends StatefulWidget {
  final Function(String) callback;
  final GlobalKey<FormState> formKey;

  const CidWidget({super.key, required this.callback, required this.formKey});

  @override
  CidWidgetState createState() => CidWidgetState();
}

class CidWidgetState extends State<CidWidget> {
  late String _textFieldValue;
  bool _isInputValid = true;

  void _updateCid(String newValue) {
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
    final RegExp cidRegex =
        RegExp(r'^[0-9] ^[0-9]{4} ^[0-9]{5} ^[0-9]{2} ^[0-9]$');
    if (cidRegex.hasMatch(_textFieldValue)) {
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
                'รหัสบัตรประชาชน',
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
                  return 'กรุณากรอกข้อมูล';
                }

                if (!_isInputValid) {
                  return 'กรุณาเว้นวรรคให้ถูกต้อง';
                }
                return null;
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 8.0),
                hintText: '1 2345 67890 12 3',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                errorText: _isInputValid ? null : 'กรุณาเว้นวรรคให้ถูกต้อง',
              ),
              onChanged: (value) {
                _updateCid(value);
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
