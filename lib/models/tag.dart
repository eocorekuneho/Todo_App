import 'package:flutter/material.dart';

enum TagType { PROJECT, CONTEXT, NONE }

class Tag {
  String _id = "";
  TagType type = TagType.NONE;
  String name = "";
  String description = "";

  Tag(TagType pType, String pName, {this.description = ""}) {
    this.name = pName;
    this.type = pType;
    this._id = UniqueKey().toString();
  }
}
