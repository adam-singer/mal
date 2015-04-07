library step2_eval_test;

import "../step2_eval.dart";

void main() {
  String error1Expected = "'abc' not found.";
  String error1Actual;

  try {
    rep("(abc 1 2 3)");
  } on StateError catch (se) {
    error1Actual = se.message;
  }

  assert(error1Expected == error1Actual);
}
