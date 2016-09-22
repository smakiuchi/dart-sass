// Copyright 2016 Google Inc. Use of this source code is governed by an
// MIT-style license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import '../utils.dart';
import '../visitor/interface/value.dart';
import '../value.dart';

class SassList extends Value {
  // TODO(nweiz): Use persistent data structures rather than copying here. An
  // RRB vector should fit our use-cases well.
  //
  // We may also want to fall back to a plain unmodifiable List for small lists
  // (<32 items?).
  final List<Value> contents;

  final ListSeparator separator;

  final bool hasBrackets;

  bool get isBlank => contents.every((element) => element.isBlank);

  List<Value> get asList => contents;

  SassList(Iterable<Value> contents, this.separator, {bool brackets: false})
      : contents = new List.unmodifiable(contents),
        hasBrackets = brackets;

  /*=T*/ accept/*<T>*/(ValueVisitor/*<T>*/ visitor) => visitor.visitList(this);

  bool operator ==(other) =>
      other is SassList &&
      other.separator == separator &&
      other.hasBrackets == hasBrackets &&
      listEquals(other.contents, contents);

  int get hashCode => listHash(contents);
}

class ListSeparator {
  static const space = const ListSeparator._("space");
  static const comma = const ListSeparator._("comma");
  static const undecided = const ListSeparator._("undecided");

  final String name;

  const ListSeparator._(this.name);

  String toString() => name;
}
