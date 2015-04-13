library all_tests;

import "step0_repl_test.dart" as step0;
import "step1_read_print_test.dart" as step1;
import "step2_eval_test.dart" as step2;
import "step3_env_test.dart" as step3;
import "step4_if_fn_do_test.dart" as step4;
import "step5_tco_test.dart" as step5;

import "env_test.dart" as env;
import "types_test.dart" as types;
import "core_test.dart" as core;

void main() {
  step0.main();
  step1.main();
  step2.main();
  step3.main();
  step4.main();
  step5.main();

  types.main();
  env.main();
  core.main();
}
