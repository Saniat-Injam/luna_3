import 'package:flutter/material.dart';
import 'package:barbell/core/common/styles/global_text_style.dart';
import 'package:barbell/core/utils/constants/colors.dart';

class PopUpButton extends StatelessWidget {
  final VoidCallback onTap;
  const PopUpButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Stack(
        children: [
          // A transparent background to dismiss the dialog
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              color: Colors.transparent,
              
            ),
          ),
          // The positioned button
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 60), // adjust vertical position
              child: TextButton(
                onPressed: onTap,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                  backgroundColor: const Color(0xFFE2FF3B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  "Add",
                  style: getTextStyle1(
                    color: AppColors.appbar,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
