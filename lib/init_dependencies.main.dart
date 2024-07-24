part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  final supabase = await Supabase.initialize(
    url: dotenv.env["SUPABASE_PROJECT_URL"]!,
    anonKey: dotenv.env["SUPABASE_API_KEY"]!,
  );
  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;
  _initSupabaseDependency(supabaseClient: supabase.client);
  _initHiveDependency();
  _initCoreDependencies();
  _initBlocDependencies();
  _initAuthDependencies();
  _initBlogDependencies();
}

void _initCoreDependencies() {
  serviceLocator
    ..registerFactory<ConnectionChecker>(
      () {
        return ConnectionCheckerImpl(internetConnection: serviceLocator());
      },
    )
    ..registerFactory<InternetConnection>(
      () {
        return InternetConnection();
      },
    );
}

void _initSupabaseDependency({required SupabaseClient supabaseClient}) {
  serviceLocator.registerLazySingleton<SupabaseClient>(
    () => supabaseClient,
  );
}

void _initHiveDependency() {
  serviceLocator.registerLazySingleton<Box>(
    () => Hive.box(name: "blogs"),
  );
}

void _initBlocDependencies() {
  serviceLocator
    ..registerLazySingleton<AppUserCubit>(
      () => AppUserCubit(),
    )
    ..registerLazySingleton<AuthBloc>(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userSignIn: serviceLocator(),
        userSignOut: serviceLocator(),
        currentUserRetrieval: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    )
    ..registerLazySingleton<BlogBloc>(
      () => BlogBloc(
        uploadBlog: serviceLocator(),
        getAllBlogs: serviceLocator(),
      ),
    );
}

void _initAuthDependencies() {
  serviceLocator
    ..registerFactory<UserSignUp>(
      () => UserSignUp(
        authRepository: serviceLocator(),
      ),
    )
    ..registerFactory<UserSignIn>(
      () => UserSignIn(
        authRepository: serviceLocator(),
      ),
    )
    ..registerFactory<UserSignOut>(
      () => UserSignOut(
        authRepository: serviceLocator(),
      ),
    )
    ..registerFactory<CurrentUserRetrieval>(
      () => CurrentUserRetrieval(
        authRepository: serviceLocator(),
      ),
    )
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        authRemoteDataSource: serviceLocator(),
        connectionChecker: serviceLocator(),
      ),
    )
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        supabaseClient: serviceLocator(),
      ),
    );
}

void _initBlogDependencies() {
  serviceLocator
    ..registerFactory<UploadBlog>(
      () => UploadBlog(
        blogRepository: serviceLocator(),
      ),
    )
    ..registerFactory<GetAllBlogs>(
      () => GetAllBlogs(
        blogRepository: serviceLocator(),
      ),
    )
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImpl(
        blogRemoteDataSource: serviceLocator(),
        blogLocalDataSource: serviceLocator(),
        connectionChecker: serviceLocator(),
      ),
    )
    ..registerFactory<BlogRemoteDataSource>(
      () => BlogRemoteDataSourceImpl(
        supabaseClient: serviceLocator(),
      ),
    )
    ..registerFactory<BlogLocalDataSource>(
      () => BlogLocalDataSourceImpl(
        box: serviceLocator(),
      ),
    );
}
