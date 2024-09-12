import 'package:flutter/material.dart';

class LoginBottomSheet extends StatefulWidget {
  const LoginBottomSheet({
    super.key,
    required this.login,
    required this.loading,
    required this.savedUsername,
  });

  final Future<bool> Function(
    String username,
    String password, {
    String? code,
  }) login;
  final bool loading;
  final String? savedUsername;

  @override
  State<LoginBottomSheet> createState() => _LoginBottomSheetState();
}

class _LoginBottomSheetState extends State<LoginBottomSheet> {
  late TextEditingController username;
  late TextEditingController password;
  late TextEditingController code;

  bool errorOccured = false;
  bool loading = false;
  bool passwordVisible = false;

  @override
  void initState() {
    super.initState();
    username = TextEditingController(text: widget.savedUsername);
    password = TextEditingController();
    code = TextEditingController();
    username.addListener(listener);
    password.addListener(listener);
    code.addListener(listener);
  }

  @override
  void dispose() {
    username.removeListener(listener);
    password.removeListener(listener);
    code.removeListener(listener);
    super.dispose();
  }

  void listener() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            decoration: InputDecoration(labelText: 'Username'),
            autocorrect: false,
            controller: username,
            obscureText: false,
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(labelText: 'Password'),
                  autocorrect: false,
                  controller: password,
                  obscureText: !passwordVisible,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    passwordVisible = !passwordVisible;
                  });
                },
                child: Icon(
                  passwordVisible ? Icons.visibility_off : Icons.visibility,
                ),
              ),
            ],
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Verification Code'),
            autocorrect: false,
            controller: code,
            obscureText: false,
          ),
          const SizedBox(height: 20),
          if (errorOccured) ...[
            const Text(
              'Login Failed',
              style: TextStyle(
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
            const Text(
              'Please Ensure you are Connected to the Internet, your Credentials are Correct, and Try Again...',
              style: TextStyle(
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
            // const SizedBox(height: 10),
          ],
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                          enabled ? Colors.green : Colors.grey)),
                  onPressed: enabled
                      ? () {
                          if (enabled) {
                            setState(() {
                              loading = true;
                              errorOccured = false;
                            });
                            widget
                                .login(
                                  username.text,
                                  password.text,
                                  code: code.text,
                                )
                                .then(
                                  (success) => success
                                      ? Navigator.pop(context)
                                      : setState(
                                          () {
                                            errorOccured = true;
                                            loading = false;
                                          },
                                        ),
                                );
                          }
                        }
                      : null,
                  child: loading
                      ? const SizedBox(
                          width: 15,
                          height: 15,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Login',
                          style: enabled
                              ? const TextStyle(color: Colors.white)
                              : null,
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool get enabled => username.text.isNotEmpty && password.text.isNotEmpty;
}
