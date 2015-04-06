library step1_read_print_test;

import "../step1_read_print.dart";

void main() {
  String error1Expected = "expected ')', got EOF";
  String error1Actual;
  String error2Expected = "expected ']', got EOF";
  String error2Actual;
  String error3Expected = """expected '"', got EOF""";
  String error3Actual;

  try {
    rep("(1 2");
  } on StateError catch (se) {
    error1Actual = se.message;
  }

  assert(error1Expected == error1Actual);

  try {
    rep("[1 2");
  } on StateError catch (se) {
    error2Actual = se.message;
  }

  assert(error2Expected == error2Actual);

  try {
    rep("\"abc");
  } on StateError catch (se) {
    error3Actual = se.message;
  }

  assert(error3Expected == error3Actual);
}
