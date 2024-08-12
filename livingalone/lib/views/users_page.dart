import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/user_viewmodel.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UserViewModel>(
        builder: (context, userViewModel, child) {
          if (userViewModel.users == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: userViewModel.users!.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(userViewModel.users![index].name),
                subtitle: Text(userViewModel.users![index].email),
              );
            },
          );
        },
      ),
    );
  }
}