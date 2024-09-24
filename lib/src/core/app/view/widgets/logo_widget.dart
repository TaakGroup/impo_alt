import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                blurRadius: 20,
                color: Color(0xffEC407A).withOpacity(0.2)
            )
          ]
      ),
      child: Image.asset(
        'assets/images/logo_new.webp',
      ),
    );
  }
}
