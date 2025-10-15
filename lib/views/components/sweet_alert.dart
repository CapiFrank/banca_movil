import 'package:banca_movil/utils/palette.dart';
import 'package:banca_movil/views/components/primary_button.dart';
import 'package:banca_movil/views/components/responsive_actions.dart';
import 'package:banca_movil/views/components/secondary_button.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

enum SweetAlertType { success, error, warning, info, confirm, loading }

class SweetAlert {
  static Future<void> show({
    required BuildContext context,
    required SweetAlertType type,
    String? title,
    String? message,
    bool barrierDismissible = false,
    Duration autoClose = Duration.zero,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    String labelConfirm = 'Aceptar',
    String labelCancel = 'Cancelar',
    List<ResponsiveAction>? actions,
  }) async {
    final String lottiePath;
    switch (type) {
      case SweetAlertType.success:
        lottiePath = 'assets/lottie/success.json';
        break;
      case SweetAlertType.error:
        lottiePath = 'assets/lottie/error.json';
        break;
      case SweetAlertType.warning:
        lottiePath = 'assets/lottie/warning.json';
        break;
      case SweetAlertType.info:
        lottiePath = 'assets/lottie/info.json';
        break;
      case SweetAlertType.confirm:
        lottiePath = 'assets/lottie/question.json';
        break;
      case SweetAlertType.loading:
        lottiePath = 'assets/lottie/loading.json';
        break;
    }

    showGeneralDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: '',
      barrierColor: Palette(context).shadow.withValues(alpha: 0.3),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Dialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(lottiePath, fit: BoxFit.contain, height: 120),
                if (title != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
                if (message != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    message,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
                if (type == SweetAlertType.confirm) ...[
                  const SizedBox(height: 20),
                  ResponsiveActions(
                    spacing: 8,
                    runSpacing: 8,
                    textStyle: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(fontSize: 16),
                    actions: [
                      ResponsiveAction(
                        label: labelCancel,
                        iconWidth:
                            0, // si tu SecondaryButton tiene icono, pon el ancho aproximado (ej. 24)
                        horizontalPadding: 16,
                        builder: (fullWidth) => fullWidth
                            ? SizedBox(
                                width: double.infinity,
                                child: SecondaryButton(
                                  labelText: labelCancel,
                                  onPressed: () {
                                    Navigator.of(
                                      context,
                                      rootNavigator: true,
                                    ).pop();
                                    if (onCancel != null) onCancel();
                                  },
                                ),
                              )
                            : SecondaryButton(
                                labelText: labelCancel,
                                onPressed: () {
                                  Navigator.of(
                                    context,
                                    rootNavigator: true,
                                  ).pop();
                                  if (onCancel != null) onCancel();
                                },
                              ),
                      ),
                      ResponsiveAction(
                        label: labelConfirm,
                        iconWidth: 0,
                        horizontalPadding: 16,
                        builder: (fullWidth) => fullWidth
                            ? SizedBox(
                                width: double.infinity,
                                child: PrimaryButton(
                                  labelText: labelConfirm,
                                  onPressed: () {
                                    Navigator.of(
                                      context,
                                      rootNavigator: true,
                                    ).pop();
                                    if (onConfirm != null) onConfirm();
                                  },
                                ),
                              )
                            : PrimaryButton(
                                labelText: labelConfirm,
                                onPressed: () {
                                  Navigator.of(
                                    context,
                                    rootNavigator: true,
                                  ).pop();
                                  if (onConfirm != null) onConfirm();
                                },
                              ),
                      ),
                    ],
                  ),
                ],
                if (type != SweetAlertType.confirm && actions != null) ...[
                  const SizedBox(height: 20),
                  ResponsiveActions(
                    spacing: 8,
                    runSpacing: 8,
                    textStyle: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(fontSize: 16),
                    actions: actions,
                  ),
                ],
              ],
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );

    // Si tiene autocierre
    if (autoClose > Duration.zero) {
      await Future.delayed(autoClose);
      if (context.mounted &&
          Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    }
  }
}
