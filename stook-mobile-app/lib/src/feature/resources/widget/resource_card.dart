import 'package:flutter/material.dart';
import 'package:stook_database/database_context.dart';
import 'package:stook_database/models/models.dart';

import '../../../common/constants/constants.dart';
import '../../../common/widget/type_card.dart';
import '../bloc/resource_scope.dart';

class ResourceCard extends StatelessWidget {
  const ResourceCard({
    super.key,
    required this.resource,
  });

  final Resource resource;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TypeCard(
                  title: resource.type.name,
                  color: resource.type.color,
                ),
                const SizedBox(height: 4),
                Text(
                  resource.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Добавлено: ${kDateTimeFormat.format(resource.createdDate)}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => ResourceScope.putResource(
              context,
              resourceId: resource.id,
              fromScreenIndex: 1,
            ),
            icon: const Icon(
              Icons.arrow_forward_ios_outlined,
              size: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
