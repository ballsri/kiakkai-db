import 'package:flutter/material.dart';

class AgencyWidget extends StatefulWidget {
  final Function(String) callback;
  final GlobalKey<FormState> formKey;

  const AgencyWidget(
      {super.key, required this.callback, required this.formKey});

  @override
  AgencyWidgetState createState() => AgencyWidgetState();
}

class AgencyWidgetState extends State<AgencyWidget> {
  late String _textFieldValue;
  bool _isInputValid = true;

  void _updateAgency(String newValue) {
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
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: const Center(
              child: Text(
                'หน่วยงาน',
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
                  return 'กรุณากรอกหน่วยงาน';
                }
                return null;
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 8.0),
                hintText: 'กองงาน 905',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                errorText: _isInputValid ? null : 'กรุณากรอกหน่วยงาน',
              ),
              onChanged: (value) {
                _updateAgency(value);
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
