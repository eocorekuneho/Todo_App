import 'package:flutter/material.dart';

class TodoTxt {
  static const String LINE_ENDING = "\n";
  static const String FIELD_SEPARATOR = " ";
  static const String PREFIX_PROJECT = "+";
  static const String PREFIX_CONTEXT = "@";
  static const String LPREFIX_DONE = "x";
  static const String REGEX_PROJECT = r"\B\+[a-zA-Z0-9\p{L}\p{M}]+";
  static const String REGEX_CONTEXT = r"\B@[a-zA-Z0-9\p{L}\p{M}]+";
  static const String REGEX_KEYVALUE = r'(\w+):([^\s]+)';
  static const String REGEX_DATE =
      r"\d{4}-(0?[1-9]|1[012])-(0?[1-9]|[12][0-9]|3[01])*";
  static const String REGEX_PRIORITY = r"\([A-Z]\)";
  static const String KEYCHAR_KEYVALUE = ":";

  static List<Map<String, dynamic>> parseContents(String pContent) {
    List<Map<String, dynamic>> retval = [];
    for (String line in pContent.split(LINE_ENDING)) {
      line.trim();
      if (line == "") continue;
      //print("parsing line: $line");
      if (line.startsWith("//")) {
        //print("it's comment, no parsing");
        continue;
      }
      var parsed = parseLine(line);
      retval.add(parsed);
    }
    return retval;
  }

  static Map<String, dynamic> parseDescription(String pDescription) {
    Map<String, dynamic> retval = {
      "content": "",
      "projects": [],
      "contexts": [],
      "keyvalues": {},
    };
    String content = "";
    for (String word in pDescription.split(FIELD_SEPARATOR)) {
      // Key-Values
      {
        RegExp search = RegExp(REGEX_KEYVALUE, unicode: true);
        if (search.hasMatch(word)) {
          var match = search.firstMatch(word);
          if (match?.group(1) != null && match?.group(2) != null) {
            (retval['keyvalues'] as Map)
                .addEntries([MapEntry(match!.group(1)!, match.group(2)!)]);
          }
          //continue;
        }
      }

      // Content
      retval['content'] += "$word ";

      // Projects
      {
        RegExp search = RegExp(REGEX_PROJECT, unicode: true);
        if (search.hasMatch(word)) {
          (retval['projects'] as List).add(search.firstMatch(word)!.group(0));
        }
      }

      // Contexts
      {
        RegExp search = RegExp(REGEX_CONTEXT, unicode: true);
        if (search.hasMatch(word)) {
          (retval['contexts'] as List).add(search.firstMatch(word)!.group(0));
        }
      }
    }
    return retval;
  }

  static Map<String, dynamic> parseLine(String pLine) {
    Map<String, dynamic> retval = {
      "done": false,
      "priority": null,
      "createdAt": null,
      "finishedAt": null,
      "content": "",
      "projects": [],
      "contexts": [],
      "keyvalues": {},
    };

    int wIndex = -1;
    DateTime? date1;
    DateTime? date2;
    bool prioritySet = false;
    String content = "";

    for (String word in pLine.split(FIELD_SEPARATOR)) {
      wIndex++;
      //print("\t$wIndex, $word");
      if (wIndex == 0) {
        // check if it's done
        if (word == LPREFIX_DONE) {
          retval['done'] = true;
          continue;
        }
      }

      // Priority
      if (!prioritySet) {
        RegExp search = RegExp(REGEX_PRIORITY, unicode: true);
        if (word.length == 3 && search.hasMatch(word)) {
          retval["priority"] = word.characters.elementAt(1);
          prioritySet = true;
          continue;
        }
      }
      bool kv = false;
      // Key-Values
      {
        RegExp search = RegExp(REGEX_KEYVALUE, unicode: true);
        if (search.hasMatch(word)) {
          var match = search.firstMatch(word);
          if (match?.group(1) != null && match?.group(2) != null) {
            (retval['keyvalues'] as Map)
                .addEntries([MapEntry(match!.group(1)!, match.group(2)!)]);
          }
          kv = true;
          //continue;
        }
      }

      // Dates
      if (!kv) {
        RegExp search = RegExp(REGEX_DATE, unicode: true);
        if (search.hasMatch(word)) {
          if (date1 == null) {
            date1 = DateTime.parse(word);
            prioritySet = true;
            continue;
          }

          if (date1 != null) {
            date2 = DateTime.parse(word);
            prioritySet = true;
            continue;
          }
        }
      }

      // Content
      retval['content'] += "$word ";

      // Projects
      {
        RegExp search = RegExp(REGEX_PROJECT, unicode: true);
        if (search.hasMatch(word)) {
          (retval['projects'] as List).add(search.firstMatch(word)!.group(0));
        }
      }

      // Contexts
      {
        RegExp search = RegExp(REGEX_CONTEXT, unicode: true);
        if (search.hasMatch(word)) {
          (retval['contexts'] as List).add(search.firstMatch(word)!.group(0));
        }
      }
    }

    if (date1 != null && date2 != null) {
      retval['finishedAt'] = date1;
      retval['createdAt'] = date2;
    } else if (date1 != null && date2 == null) {
      retval['createdAt'] = date1;
    }

    return retval;
  }
}
