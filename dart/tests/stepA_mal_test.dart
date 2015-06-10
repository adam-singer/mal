library stepA_mal_test;

import "../stepA_mal.dart";
import "test_helpers.dart";

Function testEval = (String input) => EVAL(READ(input), repl_env);

void main() {
  init();
}
