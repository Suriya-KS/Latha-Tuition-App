import 'package:flutter/material.dart';

import 'package:latha_tuition_app/widgets/buttons/primary_button.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.person_outline),
              prefixIconColor: Theme.of(context).colorScheme.primary,
              label: const Text('Full Name'),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.mail_outline),
              prefixIconColor: Theme.of(context).colorScheme.primary,
              label: const Text('Email Address'),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.phone_outlined),
              prefixIconColor: Theme.of(context).colorScheme.primary,
              prefixText: '+91 ',
              label: const Text('Phone Number'),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock_outline),
              prefixIconColor: Theme.of(context).colorScheme.primary,
              label: const Text('Password'),
              suffixIcon: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.remove_red_eye_outlined),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock_outline),
              prefixIconColor: Theme.of(context).colorScheme.primary,
              label: const Text('Confirm Password'),
              suffixIcon: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.remove_red_eye_outlined),
              ),
            ),
          ),
          const SizedBox(height: 50),
          const PrimaryButton(title: 'Sign Up'),
        ],
      ),
    );
  }
}
