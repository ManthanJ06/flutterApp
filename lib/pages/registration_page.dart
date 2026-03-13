```dart
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../bloc/registration/registration_bloc.dart';
import '../bloc/registration/registration_event.dart';
import '../bloc/registration/registration_state.dart';
import '../core/constants.dart';
import '../core/validator.dart';
import '../widgets/note_button.dart';
import '../widgets/note_form_field.dart';
import '../widgets/note_icon_button_outlined.dart';
import 'recover_password_page.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  late final GlobalKey<FormState> formKey;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();

    formKey = GlobalKey();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegistrationBloc, RegistrationState>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          state.isRegisterMode ? 'Register' : 'Sign In',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 48,
                            fontFamily: 'Fredoka',
                            fontWeight: FontWeight.w600,
                            color: primary,
                          ),
                        ),
                        const SizedBox(height: 48),

                        if (state.isRegisterMode) ...[
                          NoteFormField(
                            controller: nameController,
                            labelText: 'Full name',
                            fillColor: white,
                            filled: true,
                            validator: Validator.nameValidator,
                            onChanged: (v) {
                              context.read<RegistrationBloc>().add(
                                    UpdateNameEvent(v),
                                  );
                            },
                          ),
                          const SizedBox(height: 8),
                        ],

                        NoteFormField(
                          controller: emailController,
                          labelText: 'Email address',
                          fillColor: white,
                          filled: true,
                          validator: Validator.emailValidator,
                          onChanged: (v) {
                            context
                                .read<RegistrationBloc>()
                                .add(UpdateEmailEvent(v));
                          },
                        ),
                        const SizedBox(height: 8),

                        NoteFormField(
                          controller: passwordController,
                          labelText: 'Password',
                          fillColor: white,
                          filled: true,
                          obscureText: state.isPasswordHidden,
                          suffixIcon: GestureDetector(
                            onTap: () {
                              context
                                  .read<RegistrationBloc>()
                                  .add(TogglePasswordVisibilityEvent());
                            },
                            child: Icon(
                              state.isPasswordHidden
                                  ? FontAwesomeIcons.eye
                                  : FontAwesomeIcons.eyeSlash,
                            ),
                          ),
                          validator: Validator.passwordValidator,
                          onChanged: (v) {
                            context
                                .read<RegistrationBloc>()
                                .add(UpdatePasswordEvent(v));
                          },
                        ),

                        const SizedBox(height: 12),

                        if (!state.isRegisterMode) ...[
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const RecoverPasswordpage(),
                                ),
                              );
                            },
                            child: const Text(
                              'Forgot password?',
                              style: TextStyle(
                                color: primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],

                        SizedBox(
                          height: 48,
                          child: NoteButton(
                            onPressed: state.isLoading
                                ? null
                                : () {
                                    if (formKey.currentState?.validate() ??
                                        false) {
                                      context.read<RegistrationBloc>().add(
                                            AuthenticateEvent(),
                                          );
                                    }
                                  },
                            child: state.isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                        color: white),
                                  )
                                : Text(state.isRegisterMode
                                    ? 'Create my account'
                                    : 'Log me in'),
                          ),
                        ),

                        const SizedBox(height: 32),

                        Row(
                          children: [
                            const Expanded(child: Divider()),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(state.isRegisterMode
                                  ? 'Or register with'
                                  : 'Or sign in with'),
                            ),
                            const Expanded(child: Divider()),
                          ],
                        ),

                        const SizedBox(height: 32),

                        Row(
                          children: [
                            Expanded(
                              child: NoteIconButtonOutlined(
                                icon: FontAwesomeIcons.google,
                                onPressed: () {
                                  context
                                      .read<RegistrationBloc>()
                                      .add(GoogleLoginEvent());
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: NoteIconButtonOutlined(
                                icon: FontAwesomeIcons.facebook,
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        Text.rich(
                          TextSpan(
                            text: state.isRegisterMode
                                ? 'Already have an account? '
                                : "Don't have an account? ",
                            style: const TextStyle(color: gray700),
                            children: [
                              TextSpan(
                                text: state.isRegisterMode
                                    ? 'Sign in'
                                    : 'Register',
                                style: const TextStyle(
                                  color: primary,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    context.read<RegistrationBloc>().add(
                                          ToggleAuthModeEvent(),
                                        );
                                  },
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
```
