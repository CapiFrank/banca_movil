import 'package:banca_movil/utils/palette.dart';
import 'package:banca_movil/views/components/elevated_flex_container.dart';
import 'package:banca_movil/views/components/icon_text.dart';
import 'package:banca_movil/views/components/input_text.dart';
import 'package:banca_movil/views/components/primary_button.dart';
import 'package:banca_movil/views/components/section.dart';
import 'package:banca_movil/views/layouts/base_scaffold.dart';
import 'package:banca_movil/views/layouts/section_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      backgroundColor: Palette(context).secondary,
      body: SafeArea(
        child: SectionLayout(
          header: Section(
            alignment: Alignment.bottomCenter,
            child: Text(
              'BMóvil',
              style: TextStyle(
                color: Palette(context).onPrimary,
                fontSize: 70,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          body: Section(
            child: Column(
              children: [
                ElevatedFlexContainer.vertical(
                  children: [
                    Text(
                      '¡Bienvenido a su Banca Móvil!',
                      style: TextStyle(
                        fontSize: 20,
                        color: Palette(context).primary,
                      ),
                    ),
                    SizedBox(height: 16),
                    InputText(labelText: 'Usuario'),
                    SizedBox(height: 16),
                    InputText(labelText: 'Contraseña', obscureText: true),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
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
                      onPressed: () {
                        context.go('/account');
                      },
                    ),
                    SizedBox(height: 16),
                    Align(
                      alignment: Alignment.center,
                      child: IconText(
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
          footer: Section(
            alignment: Alignment.bottomCenter,
            child: IntrinsicHeight(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Palette(context).surface,
                        boxShadow: [
                          BoxShadow(
                            color: Palette(context).shadow,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: IconText(
                                icon: Icon(Icons.swap_vert, size: 24),
                                label: Text(
                                  "Tipo de Cambio",
                                  style: TextStyle(fontSize: 16),
                                ),
                                onPressed: () {
                                  context.push('/exchange');
                                },
                                position: IconPosition.top,
                              ),
                            ),
                            Expanded(
                              child: IconText(
                                icon: Icon(Clarity.users_line, size: 24),
                                label: Text(
                                  "Unirse",
                                  style: TextStyle(fontSize: 16),
                                ),
                                onPressed: () {},
                                position: IconPosition.top,
                              ),
                            ),
                            Expanded(
                              child: IconText(
                                icon: Icon(Clarity.help_line, size: 24),
                                label: Text(
                                  "Ayuda",
                                  style: TextStyle(fontSize: 16),
                                ),
                                onPressed: () {},
                                position: IconPosition.top,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
