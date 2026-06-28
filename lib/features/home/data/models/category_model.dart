import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/di/injection_container.dart';

part 'category_model.g.dart';

@JsonSerializable()
class CategoryModel {
  @JsonKey(name: '_id')
  final String id;
  
  @JsonKey(includeFromJson: false, includeToJson: false)
  final String? fallbackTitle;

  final Map<String, dynamic>? translation;
  
  @JsonKey(defaultValue: '')
  final String image;

  const CategoryModel({
    required this.id,
    this.fallbackTitle,
    this.translation,
    required this.image,
  });

  String get title {
    if (translation != null) {
      try {
        final prefs = sl<SharedPreferences>();
        final code = prefs.getString('app_locale') ?? 'en';
        return translation![code] ?? translation!['en'] ?? translation!['fr'] ?? translation!['ar'] ?? fallbackTitle ?? '';
      } catch (_) {
        return translation!['en'] ?? fallbackTitle ?? '';
      }
    }
    return fallbackTitle ?? '';
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    final model = _$CategoryModelFromJson(json);
    
    return CategoryModel(
      id: model.id,
      fallbackTitle: json['title'] as String?,
      translation: model.translation,
      image: model.image,
    );
  }

  Map<String, dynamic> toJson() {
    final json = _$CategoryModelToJson(this);
    if (fallbackTitle != null) json['title'] = fallbackTitle;
    return json;
  }
}
