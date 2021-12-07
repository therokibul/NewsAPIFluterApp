import 'package:flutter/material.dart';

class NewsTile extends StatelessWidget {
  const NewsTile(
      {Key? key,
      required this.imageUrl,
      required this.title,
      required this.description})
      : super(key: key);

  final String imageUrl, title, description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image(image: NetworkImage(imageUrl)),
        Text(title),
        Text(description),
      ],
    );
  }
}
