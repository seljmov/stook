import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../common/widget/thesis_tab_bar.dart';
import 'bloc/resource_bloc.dart';
import 'bloc/resource_scope.dart';
import 'resource_put/resource_put_screen.dart';
import 'widget/resource_list.dart';

/// Страница экрана ресурсов.
class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  final tabIndexNotifier = ValueNotifier<int>(0);

  @override
  void dispose() {
    tabIndexNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<IResourceBloc, ResourceState>(
      bloc: ResourceScope.of(context)..add(const ResourceEvent.load()),
      listener: (context, state) {
        state.mapOrNull(
          loaderShow: (_) => context.loaderOverlay.show(),
          loaderHide: (_) => context.loaderOverlay.hide(),
          openPutResourceScreen: (state) => Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => ResourcePutScreen(
                        resource: state.resource,
                        fromScreenIndex: tabIndexNotifier.value,
                      )))
              .whenComplete(() => ResourceScope.load(context)),
        );
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Ресурсы'),
            centerTitle: false,
            surfaceTintColor: Colors.transparent,
          ),
          floatingActionButton: ValueListenableBuilder<int>(
            valueListenable: tabIndexNotifier,
            builder: (context, tabIndex, child) {
              return FloatingActionButton(
                onPressed: () => ResourceScope.putResource(
                  context,
                  fromScreenIndex: tabIndex,
                ),
                child: const Icon(Icons.add),
              );
            },
          ),
          body: Center(
            child: state.whenOrNull(
              loaded: (resources) => Visibility(
                visible: resources.isEmpty,
                child: const Text('Ресурсов нет'),
                replacement: ThesisTabBar(
                  initialScreenIndex: tabIndexNotifier.value,
                  tabs: const ['Все', 'Избранные'],
                  onTap: (index) => tabIndexNotifier.value = index,
                  children: [
                    ResourceList(resources: resources),
                    ResourceList(
                      resources: resources
                          .where((resource) => resource.isFavorite)
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
