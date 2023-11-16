import 'package:flutter/material.dart';

enum TagType { PROJECT, CONTEXT, KEYVALUE, NONE }

class Tag {
  String _id = "";
  TagType type = TagType.NONE;
  String name = "";
  String description = "";
  String value = "";

  Tag(TagType pType, String pName, {this.description = "", this.value = ""}) {
    name = pName;
    type = pType;
    _id = UniqueKey().toString();
  }

  setValue(String pValue) {
    value = pValue;
  }

  setDescription(String pValue) {
    description = pValue;
  }
}
