import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_id/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:my_id/features/auth/presentation/bloc/auth_event.dart';
import 'package:my_id/features/auth/presentation/bloc/auth_state.dart';
import 'package:my_id/features/auth/presentation/pages/user_details_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _onStartSdk(BuildContext context) {
    context.read<AuthBloc>().add(StartSdkEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MyID Authentication')),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => UserDetailsPage(user: state.user),
              ),
            );
          } else if (state is AuthError) {
            debugPrint("${state.message} bu xatolik");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (state is AuthLoading) const CircularProgressIndicator(),
                  if (state is! AuthLoading)
                    MaterialButton(
                      onPressed: () => _onStartSdk(context),
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      child: const Text('Start SDK'),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
