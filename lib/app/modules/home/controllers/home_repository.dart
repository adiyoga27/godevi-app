import 'package:godevi_app/app/data/models/article_model.dart';
import 'package:godevi_app/app/data/models/homestay_model.dart';
import 'package:godevi_app/app/data/models/package_model.dart';
import 'package:godevi_app/app/data/models/slider_model.dart';
import 'package:godevi_app/app/data/models/village_model.dart';
import 'package:godevi_app/app/data/providers/api_provider.dart';

class HomeRepository {
  final ApiProvider apiProvider;

  HomeRepository(this.apiProvider);

  Future<List<SliderModel>> getSliders() async {
    final response = await apiProvider.getSliders();
    if (response.status.hasError) return [];
    final data = response.body['data'] as List;
    return data.map((e) => SliderModel.fromJson(e)).toList();
  }

  Future<List<VillageModel>> getPopularVillages() async {
    final response = await apiProvider.getPopularVillages();
    if (response.status.hasError) return [];
    final data = response.body['data'] as List;
    return data.map((e) => VillageModel.fromJson(e)).toList();
  }

  Future<List<PackageModel>> getBestTours() async {
    final response = await apiProvider.getBestTours();
    if (response.status.hasError) return [];
    final data = response.body['data'] as List;
    return data.map((e) => PackageModel.fromJson(e)).toList();
  }

  Future<List<HomestayModel>> getBestHomestays() async {
    final response = await apiProvider.getBestHomestays();
    if (response.status.hasError) return [];
    final data = response.body['data'] as List;
    return data.map((e) => HomestayModel.fromJson(e)).toList();
  }

  Future<List<ArticleModel>> getArticles({String? keyword}) async {
    final response = await apiProvider.getArticles(keyword: keyword);
    if (response.status.hasError) return [];
    final data = response.body['data'] as List;
    return data.map((e) => ArticleModel.fromJson(e)).toList();
  }

  Future<List<ArticleModel>> getPopularArticles() async {
    final response = await apiProvider.getPopularArticles();
    if (response.status.hasError) return [];
    final data = response.body['data'] as List;
    return data.map((e) => ArticleModel.fromJson(e)).toList();
  }
}
