sealed class Result<T, E extends Exception> {
  const Result();

  bool get isSuccess => this is Success<T, E>;
  bool get isFailure => this is Failure<T, E>;

  T? get orNull => switch (this) {
        Success(value: final v) => v,
        Failure() => null,
      };
}

class Success<T, E extends Exception> extends Result<T, E> {
  final T value;
  const Success(this.value);
}

class Failure<T, E extends Exception> extends Result<T, E> {
  final E exception;
  const Failure(this.exception);
}
