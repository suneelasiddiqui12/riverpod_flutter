import 'package:flutter/material.dart';

extension TextStyleExtensions on TextStyle {
  TextStyle bold() => copyWith(fontWeight: FontWeight.bold);
  TextStyle italic() => copyWith(fontStyle: FontStyle.italic);
  TextStyle size(double size) => copyWith(fontSize: size);
}