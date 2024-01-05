import 'package:flutter/material.dart';

class UsernameField extends StatefulWidget {
  const UsernameField({
    required this.isUsernameAlreadyTaken,
    required this.setValue,
    required this.setIsUsernameAlreadyTaken,
    Key? key,
  }) : super(key: key);

  final bool isUsernameAlreadyTaken;
  final void Function(String?) setValue;
  final void Function(bool) setIsUsernameAlreadyTaken;

  @override
  State<UsernameField> createState() => _UsernameFieldState();
}

class _UsernameFieldState extends State<UsernameField> {
  RegExp get _usernameRegex => RegExp(
        r'^(?=.{1,20}$)(?![_])(?!.*[_.]{2})[a-zA-Z0-9_]+(?<![_])$',
      );

  String? _validationError;

  bool get _hasValidationError => _validationError != null;

  bool get _showErrorBelowField =>
      _hasValidationError || widget.isUsernameAlreadyTaken;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Username',
            style: TextStyle(
              fontSize: 12,
              color: _showErrorBelowField ? Colors.red : Colors.black54,
            ),
          ),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              filled: true,
              fillColor:
                  _showErrorBelowField ? Colors.red.shade100 : Colors.black12,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.greenAccent),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.red),
              ),
              errorText: _showErrorBelowField ? '' : null,
              errorStyle: const TextStyle(height: 0),
            ),
            onChanged: (value) {
              // Clear submission error of the username field
              widget.setIsUsernameAlreadyTaken(false);
            },
            onSaved: widget.setValue,
            validator: (value) {
              final error = _validateUsername(value);
              WidgetsBinding.instance!.addPostFrameCallback((_) {
                setState(() {
                  _validationError = error;
                });
              });
              return null;
            },
            textInputAction: TextInputAction.next,
          ),
          if (_showErrorBelowField)
            Text(
              _showErrorBelowField
                  ? widget.isUsernameAlreadyTaken
                      ? 'Username is already taken'
                      : _validationError!
                  : '',
              style: TextStyle(
                fontSize: 12,
                color: _showErrorBelowField ? Colors.red : Colors.black,
              ),
            ),
        ],
      ),
    );
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username cannot be empty';
    }
    if (!_usernameRegex.hasMatch(value)) {
      return 'Username is not valid';
    }
    return null;
  }
}
