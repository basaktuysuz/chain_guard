import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FormHeaderWidget extends StatelessWidget {
  const FormHeaderWidget ({
    Key? key,
    required this.image,
    required this.title,
    required this.subtitle,
  }) : super(key: key);
  final String image, title, subtitle;
  @override
  Widget build(BuildContext context) {
  final size = MediaQuery.of(context). size;
  return Center(
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,



    children: [
    Image (image: AssetImage('assets/images/recommended.png'), height: size. height * 0.2),
    Text(title, style: Theme.of(context).textTheme.headline5?.copyWith(color:Colors.black87,fontWeight: FontWeight.bold,),),
    Text(subtitle, style: Theme.of(context). textTheme.bodyText1),
    ],
    ),
  );
// Column
  }
}