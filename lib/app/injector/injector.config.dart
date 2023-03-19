// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:firebase_auth/firebase_auth.dart' as _i3;
import 'package:get_it/get_it.dart' as _i1;
import 'package:google_sign_in/google_sign_in.dart' as _i4;
import 'package:injectable/injectable.dart' as _i2;
import 'package:quantum_coherence/src/auth/bloc/auth_bloc.dart' as _i6;
import 'package:quantum_coherence/src/auth/repository/auth_repository.dart'
    as _i5;
import 'package:quantum_coherence/src/core/infrastructure/third_party_injectable_module.dart'
    as _i7; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
extension GetItInjectableX on _i1.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final thirdPartyInjectableModule = _$ThirdPartyInjectableModule();
    gh.lazySingleton<_i3.FirebaseAuth>(
        () => thirdPartyInjectableModule.firebaseAuth);
    gh.lazySingleton<_i4.GoogleSignIn>(
        () => thirdPartyInjectableModule.googleSignIn);
    gh.lazySingleton<_i5.IAuthRepository>(() => _i5.AuthRepository(
          gh<_i3.FirebaseAuth>(),
          gh<_i4.GoogleSignIn>(),
        ));
    gh.factory<_i6.AuthBloc>(() => _i6.AuthBloc(gh<_i5.IAuthRepository>()));
    return this;
  }
}

class _$ThirdPartyInjectableModule extends _i7.ThirdPartyInjectableModule {}
