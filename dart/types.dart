library mal.types;

class MalType {}

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
