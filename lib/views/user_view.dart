import 'package:banca_movil/controllers/user_controller.dart';
import 'package:banca_movil/views/components/info_card.dart';
import 'package:banca_movil/views/layouts/scroll_layout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:banca_movil/utils/utilities.dart';

class UserView extends StatefulWidget {
  const UserView({super.key});

  @override
  UserViewState createState() => UserViewState();
}

class UserViewState extends State<UserView> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserController>().index();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // void _onSubmit(UserController userController) {
  //   if (_nameController.text.isEmpty || _emailController.text.isEmpty) {
  //     handleError('Por favor, completa todos los campos.');
  //     return;
  //   }
  //   userController
  //       .store(
  //         id: DateTime.now().millisecondsSinceEpoch.toString(),
  //         name: _nameController.text,
  //         email: _emailController.text,
  //       )
  //       .then((_) {
  //         _nameController.clear();
  //         _emailController.clear();
  //       })
  //       .catchError((error) {
  //         handleError('Error al agregar el cliente: $error');
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    UserController userController = context.watch<UserController>();
    final userList = userController.users;
    if (userController.isLoading) return loadingProgress();
    return ScrollLayout(
      toolbarHeight: 280,
      isEmpty: userList.isEmpty,
      showEmptyMessage: true,
      children: [
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final user = userList[index];
            return InfoCard(
              title: Text(user.name),
              children: [Text(user.email)],
            );
          }, childCount: userList.length),
        ),
      ],
    );
  }
}
