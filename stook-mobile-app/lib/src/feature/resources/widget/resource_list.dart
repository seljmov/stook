import 'package:flutter/material.dart';
import 'package:stook_database/database_context.dart';

import 'resource_card.dart';

class ResourceList extends StatelessWidget {
  const ResourceList({
    super.key,
    required this.resources,
  });

  final List<Resource> resources;

  @override
  Widget build(BuildContext context) {
    final sortedNotes = resources.toList()
      ..sort((a, b) => b.createdDate.compareTo(a.createdDate));
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.69,
      child: Visibility(
        visible: resources.isEmpty,
        child: const Center(
          child: Text(
            'Ресурсов пока нет',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ),
        replacement: ListView.builder(
          itemCount: resources.length,
          itemBuilder: (context, index) {
            final resource = sortedNotes[index];
            return Padding(
              padding: EdgeInsets.only(top: index != 0 ? 16 : 0).copyWith(
                left: 16,
                right: 8,
                bottom: index == resources.length - 1 ? 64 : 0,
              ),
              child: ResourceCard(resource: resource),
            );
          },
        ),
      ),
    );
  }
}
