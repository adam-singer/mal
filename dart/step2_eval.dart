#!/usr/bin/env dart

library mal.step2_eval;

import "dart:io";
import "types.dart";
import "reader.dart" as reader;
import "printer.dart" as printer;

MalType READ(String str) {
  return reader.read_str(str);
}

Map<String, BinaryOperator> repl_env = {
    '+': sumBinaryOperator,
    '-': minusBinaryOperator,
    '*': multiplyBinaryOperator,
    '/': divideBinaryOperator,
};

MalType eval_ast(MalType ast, Map<String, BinaryOperator> env) {

  if (ast is MalSymbol) {

    if (!env.containsKey(ast.symbol)) {
      throw new StateError("'${ast.symbol}' not found.");
    }

    BinaryOperator binaryOperator = env[ast.symbol];
    return binaryOperator;
  } else if (ast is MalList) {

    MalList newMalList = ast is MalVector ? new MalVector() : new MalList();

    ast.malTypes.forEach((MalType malType) {
      MalType evaluatedMalType = EVAL(malType, env);
      newMalList.malTypes.add(evaluatedMalType);
    });

    return newMalList;
  } else if (ast is MalHashMap) {

    MalHashMap newMalHashMap = new MalHashMap();

    ast.malHashMap.forEach((key, value) {
      MalType evaluatedMalType = EVAL(value, env);
      newMalHashMap.malHashMap[key] = evaluatedMalType;
    });

    return newMalHashMap;
  } else {
    return ast;
  }
}

MalType EVAL(MalType ast, Map<String, BinaryOperator> env) {

  if (!(ast is MalList) || ast is MalVector) {
    return eval_ast(ast, env);
  }

  if ((ast as MalList).malTypes.length == 0) {
    return ast;
  }

  if (!((ast as MalList).malTypes[0] is MalSymbol)) {
    throw new StateError("attempt to apply on non-symbol '${(ast as MalList).malTypes[0]}'");
  }

  MalList astList = eval_ast(ast, env);
  BinaryOperator binaryOperator = astList.malTypes[0];
  // TODO(adam): binaryOperator should be a varargs operator.
  return binaryOperator((astList.malTypes[1] as MalNumber).number,
  (astList.malTypes[2] as MalNumber).number);
}

void PRINT(MalType exp) {
  printer.pr_str(exp);
}

void rep(String str) {
  PRINT(EVAL(READ(str), repl_env));
}

void main(List<String> args) {
  String line;

  while (true) {
    stdout.write("user> ");
    try {
      line = stdin.readLineSync();
      if (line == null) {
        // Control signal or EOF then break from REPL.
        break;
      }

      rep(line);
    } on Exception catch (ex) {
      stdout.writeln("Error: ${ex.message}");
      break;
    } on StateError catch (ex) {
      stdout.writeln("Error: ${ex.message}");
      break;
    }
  }
}
