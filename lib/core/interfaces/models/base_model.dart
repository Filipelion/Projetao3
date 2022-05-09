//TODO: Implement a validator for each class!

// The validator class must validate each class property and
// convert to the desired property type.

abstract class BaseModel {
  BaseModel.fromJson(Map json);
  Map<String, dynamic> toJson();
}
