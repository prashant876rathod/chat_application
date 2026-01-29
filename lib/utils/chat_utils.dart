import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

class Utils{

static void showFlushBar({
  required BuildContext context,
  required String message,
  Color backgroundColor = Colors.red,
}) {
  Flushbar(
    message: message,
    duration: const Duration(seconds: 3),
    backgroundColor: backgroundColor,
    borderRadius: BorderRadius.circular(8),
    margin: const EdgeInsets.all(8),
    icon: Icon(
      backgroundColor == Colors.red ? Icons.error_outline : Icons.info_outline,
      color: Colors.white,
    ),
    flushbarPosition: FlushbarPosition.TOP,
    animationDuration: const Duration(milliseconds: 300),
  ).show(context);
}

static void showBottomSheet({
  required BuildContext context,
  required String title,
  required String subtitle,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    ),
    builder: (_) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.35,
        minChildSize: 0.25,
        maxChildSize: 0.8,
        builder: (context, scrollController) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// 🔹 Top Drag Indicator
                Center(
                  child: Container(
                    height: 4,
                    width: 45,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                /// 🔹 Title (Word)
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                /// Divider
                Divider(color: Colors.grey.shade300),

                const SizedBox(height: 10),

                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}


static void showLoader(BuildContext context) {
  context.loaderOverlay.show();
}

static void hideLoader(BuildContext context) {
  if (context.loaderOverlay.visible) {
    context.loaderOverlay.hide();
  }
}


 }