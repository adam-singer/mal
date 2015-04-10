library mal.env;

import "types.dart";

class Env {
  Env _outer;
  Env([this._outer]);

  Map<String, MalType> _env = {};

  void set(String key, MalType value) {
    _env[key] = value;
  }

  MalType find(String key) {
    if (_env.containsKey(key)) {
      return _env[key];
    }

    return _outer != null ? _outer.find(key) : null;
  }

  MalType get(String key) {
    var value = find(key);

    if (value != null) {
      return value;
    }

    throw new StateError("'$key' not found");
  }
}
