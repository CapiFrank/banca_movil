import 'package:banca_movil/bloc/auth/auth_bloc.dart';
import 'package:banca_movil/utils/palette.dart';
import 'package:banca_movil/views/components/primitives/elevated_flex_container.dart';
import 'package:banca_movil/views/components/primitives/icon_text.dart';
import 'package:banca_movil/views/components/primitives/indexed_navigation_bar.dart';
import 'package:banca_movil/views/components/primitives/input_text.dart';
import 'package:banca_movil/views/components/composites/primary_button.dart';
import 'package:banca_movil/views/components/primitives/loading_progress.dart';
import 'package:banca_movil/views/components/primitives/outlined_text.dart';
import 'package:banca_movil/views/components/primitives/section.dart';
import 'package:banca_movil/views/components/layouts/base_scaffold.dart';
import 'package:banca_movil/views/components/layouts/section_layout.dart';
import 'package:banca_movil/views/components/primitives/sweet_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
  final _citizenNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  bool get _isValid {
    return _citizenNumberController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_refresh);
    _citizenNumberController.addListener(_refresh);
  }

  @override
  void dispose() {
    _citizenNumberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      backgroundColor: Palette(context).transparent,
      bottomNavigationBar: IndexedNavigationBar(
        selectedIndex: 3,
        onTap: (index) {
          switch (index) {
            case 0:
              context.push('/exchange');
              break;
            case 1:
              context.go('/join');
              break;
            case 2:
              context.go('/help');
              break;
          }
        },
        backgroundColor: Palette(context).onSecondary,
        items: [
          BottomNavItemData(icon: Icons.swap_vert, label: 'Tipo de Cambio'),
          BottomNavItemData(icon: Clarity.users_line, label: 'Unirse'),
          BottomNavItemData(icon: Clarity.help_line, label: 'Ayuda'),
        ],
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            SweetAlert.show(
              type: SweetAlertType.error,
              message: state.message,
              context: context,
              autoClose: Duration(seconds: 2),
            );
          } else if (state is AuthAuthenticated) {
            SweetAlert.show(
              type: SweetAlertType.success,
              context: context,
              autoClose: Duration(seconds: 2),
            );
            context.go('/account');
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) => LoadingProgress(
            isLoaded: state is AuthLoading,
            builder: () {
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/img/pattern_8.png'),
                    repeat: ImageRepeat.repeat,
                    scale: 20,
                  ),
                ),
                child: SafeArea(
                  child: SectionLayout(
                    header: Section(
                      alignment: Alignment.bottomCenter,
                      child: OutlinedText(
                        'BMóvil',
                        textColor: Palette(context).secondary,
                        strokeColor: Palette(context).surface,
                        style: TextStyle(
                          fontSize: 70,
                          fontWeight: FontWeight.w900,
                        ),
                        strokeWidth: 16,
                      ),
                    ),
                    body: Section(
                      child: Column(
                        children: [
                          ElevatedFlexContainer.vertical(
                            borderRadius: BorderRadius.circular(16),
                            children: [
                              Text(
                                '¡Bienvenido a su Banca Móvil!',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Palette(context).primary,
                                ),
                              ),
                              SizedBox(height: 16),
                              InputText(
                                labelText: 'Usuario',
                                textEditingController: _citizenNumberController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                textInputAction: TextInputAction.next,
                              ),
                              SizedBox(height: 16),
                              InputText(
                                labelText: 'Contraseña',
                                obscureText: true,
                                textEditingController: _passwordController,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.all(5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    '¿No puede ingresar?',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Palette(context).primary,
                                    ),
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                              PrimaryButton(
                                labelText: "Iniciar Sesión",
                                isEnabled: _isValid,
                                onPressed: () {
                                  final bloc = context.read<AuthBloc>();
                                  bloc.add(
                                    AuthLoginRequested(
                                      citizenNumber:
                                          _citizenNumberController.text,
                                      password: _passwordController.text,
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 16),
                              Align(
                                alignment: Alignment.center,
                                child: IconText(
                                  borderRadius: BorderRadius.circular(8),
                                  icon: Icon(TeenyIcons.face_id, size: 20),
                                  label: Text(
                                    'o ingrese con Face ID',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
