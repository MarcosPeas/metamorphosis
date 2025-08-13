import 'dart:developer';

import 'package:metamorphis/src/application/global_enumerator/create_global_enumerator_use_case.dart'
    show CreateGlobalEnumeratorUseCase;
import 'package:metamorphis/src/application/global_enumerator/delete_global_enumerator_use_case.dart';
import 'package:metamorphis/src/application/global_enumerator/get_global_enumerators_by_application_use_case.dart';
import 'package:metamorphis/src/application/global_enumerator/update_global_enumerator_use_case.dart';
import 'package:metamorphis/src/domain/_core/domain/repository.dart';
import 'package:metamorphis/src/domain/application/entities/application.dart';
import 'package:metamorphis/src/domain/global_enumerator/entities/global_enumerator.dart';
import 'package:metamorphis/src/presenter/_core/app_store.dart';
import 'package:metamorphis/src/presenter/home/global_enumerators/global_enumerators_store.dart';

class GlobalEnumeratorsController {
  late final GlobalEnumeratorsStore store;
  final AppStore appStore;
  final CreateGlobalEnumeratorUseCase createGlobalEnumeratorUseCase;
  final DeleteGlobalEnumeratorUseCase deleteGlobalEnumeratorUseCase;
  final UpdateGlobalEnumeratorUseCase updateGlobalEnumeratorUseCase;
  final GetGlobalEnumeratorsByApplicationUseCase
  getGlobalEnumeratorsByApplicationUseCase;

  GlobalEnumeratorsController({
    required this.appStore,
    required this.createGlobalEnumeratorUseCase,
    required this.deleteGlobalEnumeratorUseCase,
    required this.updateGlobalEnumeratorUseCase,
    required this.getGlobalEnumeratorsByApplicationUseCase,
  }) {
    store = GlobalEnumeratorsStore();
  }

  Application get application => appStore.application!;

  Future<void> init() async {
    store.loading = true;
    final result = await getGlobalEnumeratorsByApplicationUseCase.execute(
      PaginateParams(
        limit: 100,
        filterBy: 'applicationId',
        filterValue: application.id,
        ascending: true,
        offset: 0,
        orderBy: 'createdAt',
      ),
    );
    result.fold(
      (error) {
        store.loading = false;
        log(error.message);
        log(error.trace);
      },
      (enums) {
        store.enumerators = enums;
        store.loading = false;
      },
    );
  }

  Future<void> createEnumerator(GlobalEnumerator enumerator) async {
    final result = await createGlobalEnumeratorUseCase.execute(enumerator);
    result.fold(
      (error) {
        log(error.message);
        log(error.trace);
      },
      (enumCreated) {
        store.addEnumerator(enumCreated);
      },
    );
  }

  Future<void> updateEnumerator(GlobalEnumerator enumerator) async {
    final result = await updateGlobalEnumeratorUseCase.execute(enumerator);
    result.fold(
      (error) {
        log(error.message);
        log(error.trace);
      },
      (enumCreated) {
        store.updateEnumerator(enumCreated);
      },
    );
  }

  Future<void> deleteEnumerator(GlobalEnumerator enumerator) async {
    final result = await deleteGlobalEnumeratorUseCase.execute(enumerator);
    result.fold(
      (error) {
        log(error.message);
        log(error.trace);
      },
      (_) {
        store.deleteEnumerator(enumerator);
      },
    );
  }
}
