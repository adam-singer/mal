library mal.core;

import "types.dart";
import "printer.dart" as printer;
import "reader.dart" as reader;
import "dart:io";

SumBinaryOperator sumBinaryOperator = new SumBinaryOperator(
        (arguments) => new MalNumber(arguments[0].number + arguments[1].number));
MinusBinaryOperator minusBinaryOperator = new MinusBinaryOperator(
        (arguments) => new MalNumber(arguments[0].number - arguments[1].number));
MultiplyBinaryOperator multiplyBinaryOperator = new MultiplyBinaryOperator(
        (arguments) => new MalNumber(arguments[0].number * arguments[1].number));
DivideBinaryOperator divideBinaryOperator = new DivideBinaryOperator(
        (arguments) => new MalNumber(arguments[0].number ~/ arguments[1].number));

// `<`, `<=`, `>`, and `>=`: treat the first two parameters as
// numbers and do the corresponding numeric comparison, returning
// either true or false.
LessThanBinaryOperator lessThanBinaryOperator = new LessThanBinaryOperator(
        (arguments) => arguments[0].number < arguments[1].number ? MAL_TRUE : MAL_FALSE);
LessThanEqualBinaryOperator lessThanEqualBinaryOperator = new LessThanEqualBinaryOperator(
        (arguments) => arguments[0].number <= arguments[1].number ? MAL_TRUE : MAL_FALSE);
GreaterThanBinaryOperator greaterThanBinaryOperator = new GreaterThanBinaryOperator(
        (arguments) => arguments[0].number > arguments[1].number ? MAL_TRUE : MAL_FALSE);
GreaterThanEqualBinaryOperator greaterThanEqualBinaryOperator = new GreaterThanEqualBinaryOperator(
        (arguments) => arguments[0].number >= arguments[1].number ? MAL_TRUE : MAL_FALSE);

// `list`: take the parameters and return them as a list.
ToList toList = new ToList(
        (arguments) => new MalList.fromList(arguments.toList()));

// `list?`: return true if the first parameter is a list, false
// otherwise.
IsList isList = new IsList(
        (arguments) =>
        // TODO(adam): fix, we should not allow vector to assert true here.
        (arguments[0] is MalList && !(arguments[0] is MalVector)) ? MAL_TRUE : MAL_FALSE);

// `empty?`: treat the first parameter as a list and return true if
// the list is empty and false if it contains any elements.
IsEmpty isEmpty = new IsEmpty(
        (arguments) => (arguments[0] as MalList).malTypes.isEmpty? MAL_TRUE : MAL_FALSE);

// `=`: compare the first two parameters and return true if they are
// the same type and contain the same value. In the case of equal
// length lists, each element of the list should be compared for
// equality and if they are the same return true, otherwise false.
// TODO(adam): break up into smaller functions.
IsEqual isEqual = new IsEqual(
        (arguments) {
          var arg0 = arguments[0];
          var arg1 = arguments[1];

          if (/*(arg0 is MalVector && arg1 is MalVector) ||*/ (arg0 is MalList && arg1 is MalList)) {
            // vector or list
            if (arg0.malTypes.length != arg1.malTypes.length) {
              return MAL_FALSE;
            }

            for (int i = 0; i < arg0.malTypes.length; i++) {
              var result = Function.apply(isEqual, [arg0.malTypes[i], arg1.malTypes[i]]);
              if (result == MAL_FALSE) {
                return MAL_FALSE;
              }
            }

            return MAL_TRUE;
          } else if (arg0 is MalNumber && arg1 is MalNumber) {
            // number
            if (arg0.number == arg1.number) {
              return MAL_TRUE;
            } else {
              return MAL_FALSE;
            }
          } else if (arg0 is MalString && arg1 is MalString) {
            if (arg0.string == arg1.string) {
              return MAL_TRUE;
            } else {
              return MAL_FALSE;
            }
          } else if (arg0 is MalHashMap && arg1 is MalHashMap) {
            // hash map
            if (arg0.malHashMap.length != arg1.malHashMap.length) {
              return MAL_FALSE;
            }

            var keys = arg0.malHashMap.keys;
            for (int i = 0; i < arg0.malHashMap.length; i++) {
              var key = keys.elementAt(i);
              var value0 = arg0.malHashMap[key];
              var value1 = arg1.malHashMap[key];

              var result = Function.apply(isEqual, [value0, value1]);
              if (result == MAL_FALSE) {
                return MAL_FALSE;
              }
            }

            return MAL_TRUE;
          } else if (arg0 is MalSymbol && arg1 is MalSymbol) {
            // both are symbol
            if (arg0.symbol == arg1.symbol) {
              return MAL_TRUE;
            } else {
              return MAL_FALSE;
            }
          } else if (arg0 is MalKeyword && arg1 is MalKeyword)  {
            if (arg0.keyword == arg1.keyword) {
              return MAL_TRUE;
            } else {
              return MAL_FALSE;
            }
          } else if (arg0 is MalNil && arg1 is MalNil) {
            // both are nil
            return MAL_TRUE;
          } else if (arg0 is MalTrue && arg1 is MalTrue) {
            // both are true
            return MAL_TRUE;
          } else if (arg0 is MalFalse && arg1 is MalFalse) {
            // both are false
            return MAL_TRUE;
          } else {
            // unknown so its false.
            return MAL_FALSE;
          }
        });

// `count`: treat the first parameter as a list and return the number
// of elements that it contains.
Count count = new Count(
        (arguments) {

          // If argument is nil then return 0.
          if ((arguments[0] is MalNil)) {
            return new MalNumber(0);
          }

          return new MalNumber((arguments[0] as MalList).malTypes.length);
        });

// TODO(adam): revisit all the printing related stuff..

// `pr-str`: calls `pr_str` on each argument with `print_readably`
// set to true, joins the results with " " and returns the new
// string.
PrStr prStr = new PrStr(
        (arguments) {
          return new MalString(arguments.map((m) => m.toString(true)).join(" "));
        });

// `str`: calls `pr_str` on each argument with `print_readably` set
// to false, concatenates the results together ("" separator), and
// returns the new string.
Str str = new Str(
        (arguments) => new MalString(arguments.map((m) => m.toString(false)).join("")));

// `prn`:  calls `pr_str` on each argument with `print_readably` set
// to true, joins the results with " ", prints the string to the
// screen and then returns `nil`.
Prn prn = new Prn((arguments) {
  print(printer.pr_str(new MalString(arguments.map((m) => m.toString(true)).join(" "))));
  return MAL_NIL;
});

// `println`:  calls `pr_str` on each argument with `print_readably` set
// to false, joins the results with " ", prints the string to the
// screen and then returns `nil`.
PrintLn printLn = new PrintLn((arguments) {
  arguments.map((m) => printer.pr_str(m.toString()));
  return MAL_NIL;
});

ReadString readString = new ReadString((arguments) {
  String str = arguments[0].string;
  return reader.read_str(str);
});

Slurp slurp = new Slurp((arguments) {
  String str = arguments[0].string;
  File file = new File(str);
  String contents = file.readAsStringSync();
  return new MalString(contents);
});

Cons cons = new Cons((arguments) {
  MalList malList = new MalList();
  malList.malTypes.add(arguments[0]);
  malList.malTypes.addAll((arguments[1] as MalList).malTypes);
  return malList;
});

Concat concat = new Concat((arguments) {

  MalList malList = new MalList();

  if (arguments.length == 0) {
    return malList;
  }

  malList.malTypes.addAll( (arguments[0] as MalList).malTypes );

  for (int i = 1; i < arguments.length; i++) {
    malList.malTypes.addAll( (arguments[i] as MalList).malTypes );
  }

  return malList;
});

Nth nth = new Nth((arguments) {
  num index = (arguments[1] as MalNumber).number;
  MalList list = (arguments[0] as MalList);

  if (index < list.malTypes.length) {
    return list.nth(index);
  } else {
    throw new StateError("nth: index out of range");
  }
});

First first = new First((arguments) {
  MalList list = (arguments[0] as MalList);
  return list.malTypes.isNotEmpty ? list.nth(0) : MAL_NIL;
});

Rest rest = new Rest((arguments) {
  MalList list = (arguments[0] as MalList);
  return list.rest();
});

// core modules namespace
Map<String, Object> ns = {
    '=': isEqual,
    'pr-str': prStr,
    'str': str,
    'prn': prn,
    'println': printLn,

    'read-string': readString,
    'slurp': slurp,

    '<': lessThanBinaryOperator,
    '<=': lessThanEqualBinaryOperator,
    '>': greaterThanBinaryOperator,
    '>=': greaterThanEqualBinaryOperator,
    '+': sumBinaryOperator,
    '-': minusBinaryOperator,
    '*': multiplyBinaryOperator,
    '/': divideBinaryOperator,

    'list': toList,
    'list?': isList,

    'cons': cons,
    'concat': concat,

    'nth': nth,
    'first': first,
    'rest': rest,

    'empty?': isEmpty,
    'count': count
};
