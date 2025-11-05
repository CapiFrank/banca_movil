// import 'package:banca_movil/utils/palette.dart';
// import 'package:flutter/material.dart';

// class LoadingProgress extends StatelessWidget {
//   const LoadingProgress({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Palette(
//         context,
//       ).shadow.withValues(alpha: 0.4), // semitransparente
//       alignment: Alignment.center,
//       child: CircularProgressIndicator(color: Palette(context).secondary),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:banca_movil/utils/palette.dart';

class LoadingProgress extends StatelessWidget {
  final bool isLoaded;
  final Widget Function() builder;

  const LoadingProgress({
    super.key,
    required this.isLoaded,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AbsorbPointer(
          absorbing: isLoaded, // bloquea interacción
          child: builder(), // contenido normal
        ),
        if (isLoaded)
          Positioned.fill(
            child: Container(
              color: Palette(context).shadow.withValues(alpha: 0.40),
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                color: Palette(context).secondary,
              ),
            ),
          ),
      ],
    );
  }
}
