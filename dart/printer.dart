library mal.printer;

import "dart:io";
import "types.dart";

void pr_str(MalType malType) {
  stdout.writeln(malType.toString());
}
