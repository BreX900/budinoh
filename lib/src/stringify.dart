import 'package:budinoh/src/stringifiers.dart';

abstract class Stringify {
  Map<String, dynamic> toJson();
}

abstract class Stringifier {
  const Stringifier();

  const factory Stringifier.json({
    String identity,
    String lineBreak,
  }) = JsonStringifier;

  const factory Stringifier.minimal({
    String identity,
    String lineBreak,
  }) = MinimalStringifier;

  String stringify(Object object);
}
