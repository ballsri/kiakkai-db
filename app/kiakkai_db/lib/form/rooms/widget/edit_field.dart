import 'package:flutter/material.dart';

class EditFieldWidget extends StatefulWidget {
  final String inputText;
  final void Function(String) callback;
  const EditFieldWidget(
      {super.key, required this.inputText, required this.callback});

  @override
  EditFieldWidgetState createState() => EditFieldWidgetState();
}

class EditFieldWidgetState extends State<EditFieldWidget> {
  late String inputText;

  @override
  void initState() {
    super.initState();
    inputText = widget.inputText;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(
              right: 4.0), // Adjust the right padding value as needed
          child: Text(
            inputText,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => widget.callback(inputText),
        )
      ],
    );
  }
}
