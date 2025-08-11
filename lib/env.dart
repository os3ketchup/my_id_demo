import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'CLIENT_ID', obfuscate: true)
  static final String clientId = _Env.clientId;

  @EnviedField(varName: 'CLIENT_SECRET', obfuscate: true)
  static final String clientSecret = _Env.clientSecret;

  @EnviedField(varName: 'CLIENT_HASH_ID', obfuscate: true)
  static final String clientHashId = _Env.clientHashId;

  // The generator will handle the single-line string.
  @EnviedField(varName: 'CLIENT_HASH', obfuscate: true)
  static final String clientHash = _Env.clientHash;
}