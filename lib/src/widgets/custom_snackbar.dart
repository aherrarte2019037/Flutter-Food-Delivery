import 'package:flutter/material.dart';
import 'package:flash/flash.dart';

class CustomSnackBar {
  static showSuccess(BuildContext? context, String title, String message) {
    if (context == null) return;

    return showFlash(
        context: context,
        duration: const Duration(seconds: 3),
        builder: (context, controller) {
          return Flash.bar(
              position: FlashPosition.top,
              backgroundColor: Colors.white,
              margin: const EdgeInsets.all(8),
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              forwardAnimationCurve: Curves.decelerate,
              enableVerticalDrag: true,
              controller: controller,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                  color: Color(0XFF25D996),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              message,
                              style: const TextStyle(
                                  color: Color(0XFF393939), fontSize: 16),
                            )
                          ],
                        ),
                        const Icon(Icons.check_circle,
                            color: Color(0XFF27ECA3), size: 30)
                      ],
                    )),
              ));
        });
  }

  static showError(BuildContext? context, String title, String message) {
    if (context == null) return;

    return showFlash(
        context: context,
        duration: const Duration(seconds: 3),
        builder: (context, controller) {
          return Flash.bar(
              position: FlashPosition.top,
              backgroundColor: Colors.white,
              margin: const EdgeInsets.all(8),
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              forwardAnimationCurve: Curves.decelerate,
              enableVerticalDrag: true,
              controller: controller,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                  color: Color(0XFFFF4347),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              message,
                              style: const TextStyle(
                                  color: Color(0XFF393939), fontSize: 16),
                            )
                          ],
                        ),
                        const Icon(Icons.error, color: Color(0XFFFF5D60), size: 30)
                      ],
                    )),
              ));
        });
  }
}
