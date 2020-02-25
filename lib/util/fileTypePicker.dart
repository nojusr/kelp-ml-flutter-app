import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// used to sort files by filetype
// i.e to generate widgets or info depending on the given file,
// taken from a static list of files and their types
class fileTypePicker {

  static const imageFiletypes = [
    "png",
    "jpg",
    "jpeg",
    "webp",
    "tiff",
  ];

  static const videoFiletypes = [
    "webm",
    "mp4",
    "mkv",
    "mov",
    "gif"
  ];

  static const audioFiletypes = [
    "flac",
    "opus",
    "mp3",
    "ape"
  ];

  static const archiveFiletypes = [
    "tar.xz",
    "tar.gz",
    "7z",
    "tar.bz",
    "tar.bz2",
    "zip",
    "gz",
    "bz",
    "bz2",
    "xz"
  ];

  static Widget generateIcon(String filetype, Color color) {
    Widget fileIcon;

    if (imageFiletypes.contains(filetype)) {
      fileIcon = Icon(
        Icons.photo,
        color: color,
      );
    } else if (videoFiletypes.contains(filetype)) {
      fileIcon = Icon(
        Icons.local_movies,
        color: color,
      );
    } else if (archiveFiletypes.contains(filetype)) {
      fileIcon = Icon(
        Icons.archive,
        color: color,
      );
    } else if (audioFiletypes.contains(filetype)) {
      fileIcon = Icon(
        Icons.music_note,
        color: color,
      );
    } else {
      fileIcon = Icon(
        Icons.description,
        color: color,
      );
    }
    return fileIcon;
  }

  static String checkIfPreviewPossible(String filetype) {
    if (imageFiletypes.contains(filetype)) {
      return "image";
    } else if (videoFiletypes.contains(filetype)) {
      return "video";
    } else if (audioFiletypes.contains(filetype)) {
      return "audio"; // not yet implemented
    } else if (filetype == "txt") { // all plain text files are turned into .txt serverside
      return "text";
    }
    return "null";
  }
}