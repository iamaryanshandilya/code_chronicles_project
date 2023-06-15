import 'package:code_chronicles/core/failure.dart';
import 'package:fpdart/fpdart.dart';

// typedef FutureEither = Future<Either<String, Account>>;
typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureEitherVoid = FutureEither<void>;
typedef FutureVoid = Future<void>;