import 'package:Projetao3/core/locator.dart';
import 'package:Projetao3/services/tags_service.dart';

class WorkerController {
  var _tagService = locator<TagsService>();

  Future<Map<String, dynamic>> getTags(String? tag) async =>
      await _tagService.getSameClusterTags(tag: tag);
}
