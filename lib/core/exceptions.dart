// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Exceptions are thrown either by the VM or from Dart code.

/**
 * Interface implemented by all core library exceptions.
 * Defaults to an implementation that only carries a simple message.
 */
interface Exception default ExceptionImplementation {
  const Exception([var message]);
}


/**
 * Exception thrown because of an index outside of the valid range.
 */
class IndexOutOfRangeException implements Exception {
  const IndexOutOfRangeException(this._value);

  String toString() => "IndexOutOfRangeException: $_value";

  final _value;
}


/**
 * Exception thrown because of attempt to modify an immutable object.
 */
class IllegalAccessException implements Exception {
  const IllegalAccessException();
  String toString() => "Attempt to modify an immutable object";
}


class ClosureArgumentMismatchException implements Exception {
  const ClosureArgumentMismatchException();
  String toString() => "Closure argument mismatch";
}


class ObjectNotClosureException implements Exception {
  const ObjectNotClosureException();
  String toString() => "Object is not closure";
}


class IllegalArgumentException implements Exception {
  const IllegalArgumentException([arg = ""]) : _arg = arg;
  String toString() => "Illegal argument(s): $_arg";
  final _arg;
}


class OutOfMemoryException implements Exception {
  const OutOfMemoryException();
  String toString() => "Out of Memory";
}


class StackOverflowException implements Exception {
  const StackOverflowException();
  String toString() => "Stack Overflow";
}


/**
 * Exception thrown when a string or some other data does not have an expected
 * format and cannot be parsed or processed.
 */
class FormatException implements Exception {
  /**
   * A message describing the format error.
   */
  final String message;

  /**
   * Creates a new FormatException with an optional error [message].
   */
  const FormatException([this.message = ""]);

  String toString() => "FormatException: $message";
}


class WrongArgumentCountException implements Exception {
  const WrongArgumentCountException();
  String toString() => "WrongArgumentCountException";
}


class NullPointerException implements Exception {
  const NullPointerException([this.functionName, this.arguments = const []]);
  String toString() {
    if (functionName == null) {
      return exceptionName;
    } else {
      return "$exceptionName : method: '$functionName'\n"
          "Receiver: null\n"
          "Arguments: $arguments";
    }
  }

  String get exceptionName => "NullPointerException";

  final String functionName;
  final List arguments;
}


class NoMoreElementsException implements Exception {
  const NoMoreElementsException();
  String toString() => "NoMoreElementsException";
}


class EmptyQueueException implements Exception {
  const EmptyQueueException();
  String toString() => "EmptyQueueException";
}


class UnsupportedOperationException implements Exception {
  const UnsupportedOperationException(String this._message);
  String toString() => "UnsupportedOperationException: $_message";
  final String _message;
}


class NotImplementedException implements Exception {
  const NotImplementedException([String message]) : this._message = message;
  String toString() => (this._message !== null
                        ? "NotImplementedException: $_message"
                        : "NotImplementedException");
  final String _message;
}


class IllegalJSRegExpException implements Exception {
  const IllegalJSRegExpException(String this._pattern, String this._errmsg);
  String toString() => "IllegalJSRegExpException: '$_pattern' '$_errmsg'";
  final String _pattern;
  final String _errmsg;
}


class IntegerDivisionByZeroException implements Exception {
  const IntegerDivisionByZeroException();
  String toString() => "IntegerDivisionByZeroException";
}

/**
 * Exception thrown when a runtime error occurs.
 */
class RuntimeError implements Exception {
  final message;
  RuntimeError(this.message);
  String toString() => "RuntimeError: $message";
}
