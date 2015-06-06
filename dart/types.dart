library mal.types;

abstract class MalType extends Function {
  call() { throw new Error(); }
  @override
  String toString([bool print_readable = false]) { return "MalType"; }
}

class MalList extends MalType {
  // TODO(adam): should create a varargs constructor for MalList and MalVector.
  final List<MalType> malTypes;
  MalList(): malTypes = new List<MalType>();
  MalList.fromList(this.malTypes);
  /**
   * nth: this function takes a list (or vector) and a number (index) as arguments, returns the element of the
   * list at the given index. If the index is out of range, this function raises an exception.
   */
  MalType nth(int index) {
    if (index >= malTypes.length || index < 0) {
      throw new StateError("nth cannot index into $index element of $malTypes");
    }

    return malTypes[index];
  }

  /**
   * rest: this function takes a list (or vector) as its argument and returns a new list containing all the elements
   * except the first.
   */
  MalList rest() {
    if (malTypes.isEmpty) {
      return new MalList();
    }

    return new MalList.fromList(malTypes.toList()..removeAt(0));
  }

  MalType first() {
    return malTypes.first;
  }

  @override
  String toString([bool print_readable = false]) => "(${malTypes.join(' ')})";
}

// TODO(ADAM): do not inherit from mallist, treat them as two seprate types and then fix the type checks.
class MalVector extends MalList {
  @override
  String toString([bool print_readable = false]) => "[${malTypes.join(' ')}]";
}

class MalHashMap extends MalType {
  final Map<Object, MalType> malHashMap;
  MalHashMap(): malHashMap = new Map<Object, MalType>();
  MalHashMap.fromMalList(MalList malList): malHashMap = new Map<Object, MalType>() {
    for (int i = 0; i < malList.malTypes.length; i+=2) {
      MalType key = malList.malTypes[i];
      MalType val = malList.malTypes[i+1];
      // malHashMap[key.toString()] = val;
      malHashMap[key] = val;
    }
  }

  @override
  String toString([bool print_readable = false]) {
    StringBuffer sb = new StringBuffer();
    malHashMap.forEach((Object k,MalType v) {
      sb.write('${(k as MalType).toString(true)} ${v.toString()}');
    });

    return "{${sb.toString()}}";
  }
}

class MalNumber extends MalType {
  final num number;
  MalNumber(this.number);

  @override
  String toString([bool print_readable = false]) => number.toString();
}

class MalSymbol extends MalType {
  final String symbol;
  MalSymbol(this.symbol);

  @override
  String toString([bool print_readable = false]) => symbol.toString();

  @override
  bool operator ==(other) {
    if (other.runtimeType == this.runtimeType && other.symbol == this.symbol) {
      return true;
    } else {
      return false;
    }
  }

  @override
  int get hashCode {
    return symbol.hashCode;
  }
}

class MalKeyword extends MalType {
  final String keyword;
  MalKeyword(this.keyword);

  @override
  String toString([bool print_readable = false]) => keyword.toString();

  @override
  bool operator ==(other) {
    if (other.runtimeType == this.runtimeType && other.keyword == this.keyword) {
      return true;
    } else {
      return false;
    }
  }

  @override
  int get hashCode {
    return keyword.hashCode;
  }
}

final BIND_SYMBOL = new MalSymbol("&");

class MalString extends MalType {
  final String string;
  MalString(this.string);

  @override
  String toString([bool print_readable = false]) {

    if (print_readable) {
      return '"${string.toString()}"';
    } else {
      return string.toString();
    }
  }
}

class MalBoolean extends MalType {
  final bool value;
  MalBoolean(this.value);
  String toString([bool print_readable = false]) => "${this.value}";
}

class MalTrue extends MalBoolean {
  MalTrue(): super(true);
}

class MalFalse extends MalBoolean {
  MalFalse(): super(false);
}

class MalNil extends MalFalse {
  MalNil(): super();

  @override
  String toString([bool print_readable = false]) => "nil";
}

final MAL_NIL = new MalNil();
final MAL_TRUE = new MalTrue();
final MAL_FALSE = new MalFalse();

typedef dynamic OnCall(List);

abstract class VarargsFunction extends MalType {
  OnCall _onCall;
  var ast;
  var env;
  var fParams;
  var macro = false;

  VarargsFunction(this._onCall, {this.ast, this.env, this.fParams});

  call() => _onCall([]);

  noSuchMethod(Invocation invocation) {
    final arguments = invocation.positionalArguments;
    return _onCall(arguments);
  }

  void setMacro() {
    macro = true;
  }

  @override
  String toString([bool print_readable = false]) => "MalFunction";
}

class MalFunction extends VarargsFunction {
  MalFunction(OnCall onCall, {ast: null, env: null, fParams: null}): super(onCall, ast: ast, env: env, fParams: fParams);
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

class LessThanBinaryOperator extends VarargsFunction {
  LessThanBinaryOperator(OnCall onCall): super(onCall);
}

class LessThanEqualBinaryOperator extends VarargsFunction {
  LessThanEqualBinaryOperator(OnCall onCall): super(onCall);
}

class GreaterThanBinaryOperator extends VarargsFunction {
  GreaterThanBinaryOperator(OnCall onCall): super(onCall);
}

class GreaterThanEqualBinaryOperator extends VarargsFunction {
  GreaterThanEqualBinaryOperator(OnCall onCall): super(onCall);
}

class ToList extends VarargsFunction {
  ToList(OnCall onCall): super(onCall);
}

class IsList extends VarargsFunction {
  IsList(OnCall onCall): super(onCall);
}

class IsEmpty extends VarargsFunction {
  IsEmpty(OnCall onCall): super(onCall);
}

class IsEqual extends VarargsFunction {
  IsEqual(OnCall onCall): super(onCall);
}

class Count extends VarargsFunction {
  Count(OnCall onCall): super(onCall);
}

class PrStr extends VarargsFunction {
  PrStr(OnCall onCall): super(onCall);
}

class Str extends VarargsFunction {
  Str(OnCall onCall): super(onCall);
}

class Prn extends VarargsFunction {
  Prn(OnCall onCall): super(onCall);
}

class PrintLn extends VarargsFunction {
  PrintLn(OnCall onCall): super(onCall);
}

class ReadString extends VarargsFunction {
  ReadString(OnCall onCall): super(onCall);
}

class Slurp extends VarargsFunction {
  Slurp(OnCall onCall): super(onCall);
}

class Eval extends VarargsFunction  {
  Eval(OnCall onCall): super(onCall);
}

class Cons extends VarargsFunction {
  Cons(OnCall onCall): super(onCall);
}

class Concat extends VarargsFunction {
  Concat(OnCall onCall): super(onCall);
}

class Nth extends VarargsFunction {
  Nth(OnCall onCall): super(onCall);
}

class First extends VarargsFunction {
  First(OnCall onCall): super(onCall);
}

class Rest extends VarargsFunction {
  Rest(OnCall onCall): super(onCall);
}