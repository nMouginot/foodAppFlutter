// cc = custom component
import 'package:flutter/material.dart';

enum TextType { defaut, title }

Text ccText(String text, {TextType textType = TextType.defaut}) {
  switch (textType) {
    case TextType.defaut:
      return Text(text);

    case TextType.title:
      return Text(text);
  }
}
