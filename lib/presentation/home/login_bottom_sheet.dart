import 'package:flutter/material.dart';

class LoginBottomSheet extends StatefulWidget {
  const LoginBottomSheet({
    super.key,
    required this.login,
    required this.loading,
    required this.savedUsername,
  });

  final Future<bool> Function(String username, String password) login;
  final bool loading;
  final String? savedUsername;

  @override
  State<LoginBottomSheet> createState() => _LoginBottomSheetState();
}

class _LoginBottomSheetState extends State<LoginBottomSheet> {
  late TextEditingController username;
  late TextEditingController password;

  bool errorOccured = false;
  bool loading = false;
  bool passwordVisible = false;

  @override
  void initState() {
    super.initState();
    username = TextEditingController(text: widget.savedUsername);
    password = TextEditingController();
    username.addListener(listener);
    password.addListener(listener);
  }

  @override
  void dispose() {
    username.removeListener(listener);
    password.removeListener(listener);
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
          const SizedBox(height: 20),
          if (loading) ...[
            const SizedBox(
              width: 15,
              height: 15,
              child: CircularProgressIndicator(),
            ),
            const SizedBox(height: 20),
          ],
          if (errorOccured) ...[
            const Text(
              'Invalid Credentials, try again',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 20),
          ],
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    enabled ? null : const WidgetStatePropertyAll(Colors.grey)),
            onPressed: enabled
                ? () {
                    if (enabled) {
                      setState(() {
                        loading = true;
                        errorOccured = false;
                      });
                      widget.login(username.text, password.text).then(
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
            child: Text('Login'),
          ),
        ],
      ),
    );
  }

  bool get enabled => username.text.isNotEmpty && password.text.isNotEmpty;
}
