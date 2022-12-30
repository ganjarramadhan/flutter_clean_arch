import 'package:dartz/dartz.dart';
import 'package:flutter_clean_arch/core/errors/exception.dart';
import 'package:flutter_clean_arch/core/errors/failure.dart';
import 'package:flutter_clean_arch/core/platforms/network_info.dart';
import 'package:flutter_clean_arch/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutter_clean_arch/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_clean_arch/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_clean_arch/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:flutter_clean_arch/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late NumberTriviaRepositoryImpl repositoryImpl;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repositoryImpl = NumberTriviaRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
        networkInfo: mockNetworkInfo);
  });

  group(
    'get concrete number trivia',
    (() {
      const numberTest = 1;
      const model = NumberTriviaModel(text: "test trivia", number: numberTest);
      const NumberTrivia numberTrivia = model;

      group(
        'device is online',
        (() {
          setUp(() {
            when(() => mockNetworkInfo.isConnected)
                .thenAnswer((_) async => true);
          });

          test(
            'should check the device is online',
            (() async {
              when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
                  .thenAnswer((_) async => model);
              when(() => mockLocalDataSource.cacheNumberTrivia(model))
                  .thenAnswer((_) async => {});

              await repositoryImpl.getConcreteNumberTrivia(numberTest);

              verify(() => mockNetworkInfo.isConnected);
            }),
          );

          test(
            'should return remote data when the call to remote data source is success',
            (() async {
              when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
                  .thenAnswer((_) async => model);
              when(() => mockLocalDataSource.cacheNumberTrivia(model))
                  .thenAnswer((_) async => {});

              final result =
                  await repositoryImpl.getConcreteNumberTrivia(numberTest);

              verify(() =>
                  mockRemoteDataSource.getConcreteNumberTrivia(numberTest));
              expect(result, equals(const Right(model)));
            }),
          );

          test(
            'should cache the data locally',
            (() async {
              when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
                  .thenAnswer((_) async => model);
              when(() => mockLocalDataSource.cacheNumberTrivia(model))
                  .thenAnswer((_) async => {});

              await repositoryImpl.getConcreteNumberTrivia(numberTest);

              verify(() => mockLocalDataSource.cacheNumberTrivia(model));
              verify(() =>
                  mockRemoteDataSource.getConcreteNumberTrivia(numberTest));
            }),
          );

          test(
            'should return server failure when the call to remote data store is unsuccessful',
            (() async {
              when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
                  .thenThrow(ServerException());
              when(() => mockLocalDataSource.cacheNumberTrivia(model))
                  .thenAnswer((_) async => {});

              final result =
                  await repositoryImpl.getConcreteNumberTrivia(numberTest);

              verify(() =>
                  mockRemoteDataSource.getConcreteNumberTrivia(numberTest));
              verifyNever((() => mockLocalDataSource.cacheNumberTrivia(model)));
              expect(result, equals(Left(ServerFailure())));
            }),
          );
        }),
      );

      group(
        'device is offline',
        (() {
          setUp(() {
            when(() => mockNetworkInfo.isConnected)
                .thenAnswer((_) async => false);
          });

          test(
            'should return data from local',
            (() async {
              when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
                  .thenAnswer((_) async => model);
              when(() => mockLocalDataSource.getLastNumberTrivia())
                  .thenAnswer((_) async => model);

              final result =
                  await repositoryImpl.getConcreteNumberTrivia(numberTest);

              verifyNever((() =>
                  mockRemoteDataSource.getConcreteNumberTrivia(numberTest)));
              verify(() => mockLocalDataSource.getLastNumberTrivia());
              expect(result, equals(const Right(model)));
            }),
          );

          test(
            'should return cache failure when data in local not exist',
            (() async {
              when(() => mockRemoteDataSource.getConcreteNumberTrivia(any()))
                  .thenAnswer((_) async => model);
              when(() => mockLocalDataSource.getLastNumberTrivia())
                  .thenThrow(CacheException());

              final result =
                  await repositoryImpl.getConcreteNumberTrivia(numberTest);

              verifyNever((() =>
                  mockRemoteDataSource.getConcreteNumberTrivia(numberTest)));
              verify(() => mockLocalDataSource.getLastNumberTrivia());
              expect(result, equals(Left(CacheFailure())));
            }),
          );
        }),
      );
    }),
  );

  group(
    'get random  number trivia',
    (() {
      const model = NumberTriviaModel(text: "test trivia", number: 123);
      const NumberTrivia numberTrivia = model;

      group(
        'device is online',
        (() {
          setUp(() {
            when(() => mockNetworkInfo.isConnected)
                .thenAnswer((_) async => true);
          });

          test(
            'should check the device is online',
            (() async {
              when(() => mockRemoteDataSource.getRandomNumberTrivia())
                  .thenAnswer((_) async => model);
              when(() => mockLocalDataSource.cacheNumberTrivia(model))
                  .thenAnswer((_) async => {});

              await repositoryImpl.getRandomNumberTrivia();

              verify(() => mockNetworkInfo.isConnected);
            }),
          );

          test(
            'should return remote data when the call to remote data source is success',
            (() async {
              when(() => mockRemoteDataSource.getRandomNumberTrivia())
                  .thenAnswer((_) async => model);
              when(() => mockLocalDataSource.cacheNumberTrivia(model))
                  .thenAnswer((_) async => {});

              final result = await repositoryImpl.getRandomNumberTrivia();

              verify(() => mockRemoteDataSource.getRandomNumberTrivia());
              expect(result, equals(const Right(model)));
            }),
          );

          test(
            'should cache the data locally',
            (() async {
              when(() => mockRemoteDataSource.getRandomNumberTrivia())
                  .thenAnswer((_) async => model);
              when(() => mockLocalDataSource.cacheNumberTrivia(model))
                  .thenAnswer((_) async => {});

              await repositoryImpl.getRandomNumberTrivia();

              verify(() => mockLocalDataSource.cacheNumberTrivia(model));
              verify(() => mockRemoteDataSource.getRandomNumberTrivia());
            }),
          );

          test(
            'should return server failure when the call to remote data store is unsuccessful',
            (() async {
              when(() => mockRemoteDataSource.getRandomNumberTrivia())
                  .thenThrow(ServerException());
              when(() => mockLocalDataSource.cacheNumberTrivia(model))
                  .thenAnswer((_) async => {});

              final result = await repositoryImpl.getRandomNumberTrivia();

              verify(() => mockRemoteDataSource.getRandomNumberTrivia());
              verifyNever((() => mockLocalDataSource.cacheNumberTrivia(model)));
              expect(result, equals(Left(ServerFailure())));
            }),
          );
        }),
      );

      group(
        'device is offline',
        (() {
          setUp(() {
            when(() => mockNetworkInfo.isConnected)
                .thenAnswer((_) async => false);
          });

          test(
            'should return data from local',
            (() async {
              when(() => mockRemoteDataSource.getRandomNumberTrivia())
                  .thenAnswer((_) async => model);
              when(() => mockLocalDataSource.getLastNumberTrivia())
                  .thenAnswer((_) async => model);

              final result = await repositoryImpl.getRandomNumberTrivia();

              verifyNever((() => mockRemoteDataSource.getRandomNumberTrivia()));
              verify(() => mockLocalDataSource.getLastNumberTrivia());
              expect(result, equals(const Right(model)));
            }),
          );

          test(
            'should return cache failure when data in local not exist',
            (() async {
              when(() => mockRemoteDataSource.getRandomNumberTrivia())
                  .thenAnswer((_) async => model);
              when(() => mockLocalDataSource.getLastNumberTrivia())
                  .thenThrow(CacheException());

              final result = await repositoryImpl.getRandomNumberTrivia();

              verifyNever((() => mockRemoteDataSource.getRandomNumberTrivia()));
              verify(() => mockLocalDataSource.getLastNumberTrivia());
              expect(result, equals(Left(CacheFailure())));
            }),
          );
        }),
      );
    }),
  );
}
