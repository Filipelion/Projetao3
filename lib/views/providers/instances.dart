import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Projetao3/views/providers/professional_skills_viewmodel.dart';
import 'package:Projetao3/views/providers/user_viewmodel.dart';
import 'package:Projetao3/views/providers/worker_viewmodel.dart';

class Providers {
  static List<ChangeNotifierProvider> instances() {
    return [
      ChangeNotifierProvider<ProfessionalSkillsViewModel>(
        create: (_) => ProfessionalSkillsViewModel(),
      ),
      ChangeNotifierProvider<UserViewModel>(create: (_) => UserViewModel()),
      ChangeNotifierProvider<WorkerViewModel>(create: (_) => WorkerViewModel()),
    ];
  }
}
