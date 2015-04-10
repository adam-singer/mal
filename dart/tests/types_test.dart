library types_test;

import "../types.dart";

class DummyMalType extends MalType {}

class DummyVarargsFunction extends VarargsFunction {
  DummyVarargsFunction(OnCall onCall): super(onCall);
}

MalNumber malNumber1 = new MalNumber(1);
MalNumber malNumber10 = new MalNumber(10);
MalNumber malNumber100 = new MalNumber(100);
MalNumber malNumber1000 = new MalNumber(1000);

void main() {
  testMalType();
  testMalList();
  testMalVector();
  testMalHashMap();
  testMalNumber();
  testMalSymbol();
  testVarargsFunction();
}

void testMalType() {
  var failed = false;

  try {
    MalType malType = new DummyMalType();
    malType();
  } on Error catch(ex) {
    failed = true;
  }

  assert(failed);
}

void testMalList() {
  MalList malList = new MalList();
  malList.malTypes.add(malNumber10);
  assert(malList.toString() == "(10)");
}

void testMalVector() {
  MalVector malVector = new MalVector();
  malVector.malTypes.add(malNumber10);
  assert(malVector.toString() == "[10]");
}

void testMalHashMap() {
  MalHashMap malHashMap = new MalHashMap();
  malHashMap.malHashMap["sym"] = malNumber10;
  assert(malHashMap.toString() == "{sym ${malNumber10.toString()}}");
}

void testMalNumber() {
  int n = 10;
  MalNumber malNumber = new MalNumber(n);
  assert(malNumber.number == n);
  assert(malNumber.toString() == n.toString());
}

void testMalSymbol() {
  String sym = "sym";
  MalSymbol malSymbol = new MalSymbol(sym);
  assert(malSymbol.symbol == sym);
  assert(malSymbol.toString() == sym);
}

void testVarargsFunction() {
  DummyVarargsFunction dummyVarargsFunction = new DummyVarargsFunction((_) => true);
  assert(dummyVarargsFunction());

  var result = Function.apply(sumBinaryOperator, [malNumber1, malNumber10]);
  assert(result is MalNumber);
  assert(result.number == 11);

  result = Function.apply(minusBinaryOperator, [malNumber1, malNumber10]);
  assert(result is MalNumber);
  assert(result.number == -9);

  result = Function.apply(multiplyBinaryOperator, [malNumber1, malNumber10]);
  assert(result is MalNumber);
  assert(result.number == 10);

  result = Function.apply(divideBinaryOperator, [malNumber100, malNumber10]);
  assert(result is MalNumber);
  assert(result.number == 10);
}
