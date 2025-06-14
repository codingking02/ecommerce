import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/error/exception.dart';
import 'package:ecommerce/core/error/faliure.dart';
import 'package:ecommerce/features/products/data/data_source/product_remote_data_source.dart';
import 'package:ecommerce/features/products/data/mappers/product_mapper.dart';
import 'package:ecommerce/features/products/data/mappers/specifi_product_mapper.dart';
import 'package:ecommerce/features/products/domain/entities/product.dart';
import 'package:ecommerce/features/products/domain/entities/specific_product.dart';
import 'package:ecommerce/features/products/domain/repository/product_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ProductRepository)
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _productRemoteDataSource;

  ProductRepositoryImpl(this._productRemoteDataSource);
  @override
  Future<Either<Faliure, List<Product>>> getProducts(
    int limit,
    int page,
    String? categoryId,
  ) async {
    try {
      final response =
          await _productRemoteDataSource.getProducts(limit, page, categoryId);
      return Right(response.data.map((product) => product.toEntity).toList());
    } on RemoteException catch (e) {
      return Left(Faliure(e.message));
    }
  }

  @override
  Future<Either<Faliure, SpecificProduct>> getSpecificProduct(
    String productId,
  ) async {
    try {
      final response =
          await _productRemoteDataSource.getSpecificProduct(productId);
      return Right(response.data.toEntity);
    } on RemoteException catch (e) {
      return Left(Faliure(e.message));
    }
  }
}
