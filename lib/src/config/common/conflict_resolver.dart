import 'package:spending_pal/src/core/common/entity.dart';

abstract class ConflictResolver {
  static Resolved<T> resolveLatest<T extends HasUpdatedAt>({required T local, required T remote}) {
    if (remote.updatedAt.isAfter(local.updatedAt)) {
      return ResolvedRemote(remote);
    }

    return ResolvedLocal(local);
  }
}

abstract class Resolved<T> {
  B fold<B>(B Function(T local) ifLocal, B Function(T remote) ifRemote);

  T get value;
  bool get isLocal => this is ResolvedLocal;
  bool get isRemote => this is ResolvedRemote;
}

class ResolvedLocal<T> extends Resolved<T> {
  ResolvedLocal(this.local);

  final T local;

  @override
  B fold<B>(
    B Function(T local) ifLocal,
    B Function(T remote) ifRemote,
  ) => ifLocal(local);

  @override
  T get value => local;
}

class ResolvedRemote<T> extends Resolved<T> {
  ResolvedRemote(this.remote);

  final T remote;

  @override
  B fold<B>(
    B Function(T local) ifLocal,
    B Function(T remote) ifRemote,
  ) => ifRemote(remote);

  @override
  T get value => remote;
}
