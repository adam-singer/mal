library mal.types;

abstract class MalType extends Function {
  call() { throw new Error(); }
}

class MalList extends MalType {
  final List<MalType> malTypes;
  MalList(): malTypes = new List<MalType>();
  MalList.fromList(this.malTypes);
  String toString() => "(${malTypes.join(' ')})";
}

class MalVector extends MalList {
  String toString() => "[${malTypes.join(' ')}]";
}

class MalHashMap extends MalType {
  final Map<String, MalType> malHashMap;
  MalHashMap(): malHashMap = new Map<String, MalType>();
  MalHashMap.fromMalList(MalList malList): malHashMap = new Map<String, MalType>() {
    for (int i = 0; i < malList.malTypes.length; i+=2) {
      MalType key = malList.malTypes[i];
      MalType val = malList.malTypes[i+1];
      malHashMap[key.toString()] = val;
    }
  }
  String toString() {
    StringBuffer sb = new StringBuffer();
    malHashMap.forEach((String k,MalType v) {
      sb.write("$k ${v.toString()}");
    });

    return "{${sb.toString()}}";
  }
}

class MalNumber extends MalType {
  final num number;
  MalNumber(this.number);
  String toString() => number.toString();
}

class MalSymbol extends MalType {
  final String symbol;
  MalSymbol(this.symbol);
  String toString() => symbol.toString();
}

typedef dynamic OnCall(List);

abstract class VarargsFunction extends MalType {
  OnCall _onCall;

  VarargsFunction(this._onCall);

  call() => _onCall([]);

  noSuchMethod(Invocation invocation) {
    final arguments = invocation.positionalArguments;
    return _onCall(arguments);
  }
}

class SumBinaryOperator extends VarargsFunction  {
  SumBinaryOperator(OnCall onCall): super(onCall);
}

class MinusBinaryOperator extends VarargsFunction {
  MinusBinaryOperator(OnCall onCall): super(onCall);
}

class MultiplyBinaryOperator extends VarargsFunction {
  MultiplyBinaryOperator(OnCall onCall): super(onCall);
}

class DivideBinaryOperator extends VarargsFunction {
  DivideBinaryOperator(OnCall onCall): super(onCall);
}

SumBinaryOperator sumBinaryOperator = new SumBinaryOperator(
        (arguments) => new MalNumber(arguments[0].number + arguments[1].number));
MinusBinaryOperator minusBinaryOperator = new MinusBinaryOperator(
        (arguments) => new MalNumber(arguments[0].number - arguments[1].number));
MultiplyBinaryOperator multiplyBinaryOperator = new MultiplyBinaryOperator(
        (arguments) => new MalNumber(arguments[0].number * arguments[1].number));
DivideBinaryOperator divideBinaryOperator = new DivideBinaryOperator(
        (arguments) => new MalNumber(arguments[0].number ~/ arguments[1].number));
