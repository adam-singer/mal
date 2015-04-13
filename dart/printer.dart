library mal.printer;

import "dart:io";
import "types.dart";

String pr_str(MalType malType, [bool printReadable = true]) {
  return malType.toString();
}
