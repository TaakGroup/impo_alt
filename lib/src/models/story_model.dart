import 'package:flutter/material.dart';
import 'package:story_view/models/story_model.dart';

abstract class StoryLocatorModel extends ChangeNotifier {

  StoryViewModel get story;

  void addStory(json);

}

class StoryLocatorModelImplementation extends StoryLocatorModel {

  late StoryViewModel _story;

  @override
  void addStory(json) {
    _story = StoryViewModel.fromJson(json);
    notifyListeners();
  }

  @override
  StoryViewModel get story => _story;

}

class StoryViewModel{
  late String text;
  late List<StoryModel>  items;

  StoryViewModel.fromJson(Map<String,dynamic> parsedJson){
    text = parsedJson['text'];
    items = parsedJson['items'].length != 0  ? [for (var mapJson in parsedJson['items']) StoryModel.fromJson(mapJson)] : [];
  }

}