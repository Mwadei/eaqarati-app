abstract class Usecase<Type, Parms> {
  Future<Type> call({Parms parms});
}
