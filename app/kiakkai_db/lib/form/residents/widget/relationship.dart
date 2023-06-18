import 'package:flutter/material.dart';

class RelationshipWidget extends StatefulWidget {
  final Function(String) callback;
  final GlobalKey<FormState> formKey;

  const RelationshipWidget(
      {super.key, required this.callback, required this.formKey});

  @override
  RelationshipWidgetState createState() => RelationshipWidgetState();
}

class RelationshipWidgetState extends State<RelationshipWidget> {
  late String _textFieldValue;
  bool _isInputValid = true;

  void _updateRelationship(String newValue) {
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
                'ความสำพันธ์',
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
                  return 'กรุณากรอกความสำพันธ์';
                }
                return null;
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 8.0),
                hintText: 'เจ้าบ้าน',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                errorText: _isInputValid ? null : 'กรุณากรอกความสำพันธ์',
              ),
              onChanged: (value) {
                _updateRelationship(value);
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
