import 'package:flutter/material.dart';
import 'package:stook_database/database_context.dart';
import 'package:stook_database/models/enums/resource_type.dart';

import '../bloc/resource_scope.dart';

/// Экран добавления/изменения ресурса.
class ResourcePutScreen extends StatefulWidget {
  const ResourcePutScreen({
    super.key,
    this.resource,
    this.fromScreenIndex = 0,
  });

  final Resource? resource;
  final int fromScreenIndex;

  @override
  State<ResourcePutScreen> createState() => _ResourcePutScreenState();
}

class _ResourcePutScreenState extends State<ResourcePutScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final isFavoriteNotifier = ValueNotifier<bool>(false);
  final urlController = TextEditingController();
  final typeNotifier = ValueNotifier<ResourceType?>(ResourceType.other);

  @override
  void initState() {
    if (widget.resource != null) {
      titleController.text = widget.resource!.title;
      descriptionController.text = widget.resource!.description ?? '';
      isFavoriteNotifier.value = widget.resource!.isFavorite;
      urlController.text = widget.resource!.url ?? '';
      typeNotifier.value = widget.resource!.type;
    }
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    isFavoriteNotifier.dispose();
    urlController.dispose();
    typeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.resource == null ? 'Добавить ресурс' : 'Изменить ресурс',
        ),
        centerTitle: false,
        actions: [
          Visibility(
            visible: widget.resource != null,
            child: IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () async {
                final deleted = await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Удалить ресурс?'),
                      content:
                          const Text('Вы уверены, что хотите удалить ресурс?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Да'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Нет'),
                        ),
                      ],
                    );
                  },
                );
                if (deleted != null && deleted) {
                  ResourceScope.deleteResource(
                    context,
                    resourceId: widget.resource!.id,
                  );
                  Navigator.of(context).pop();
                }
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              final title = titleController.text;
              if (title.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Введите название ресурса'),
                  ),
                );
                return;
              }

              final puttedResource = Resource(
                id: widget.resource?.id ??
                    DateTime.now().millisecondsSinceEpoch,
                title: title,
                description: descriptionController.text,
                url: urlController.text,
                type: typeNotifier.value!,
                createdDate: widget.resource?.createdDate ?? DateTime.now(),
                isFavorite: isFavoriteNotifier.value,
              );

              ResourceScope.savePuttedResource(
                context,
                resource: puttedResource,
                fromScreenIndex: widget.fromScreenIndex,
              );
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white70,
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: titleController,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                        hintText: 'Название',
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey.shade300,
                    ),
                    TextFormField(
                      controller: descriptionController,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                        hintText: 'Описание (необязательно)',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white70,
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'В избранное',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        ValueListenableBuilder<bool>(
                          valueListenable: isFavoriteNotifier,
                          builder: (context, isFavorite, child) {
                            return Checkbox(
                              value: isFavorite,
                              onChanged: (value) {
                                isFavoriteNotifier.value = value!;
                              },
                            );
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white70,
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: urlController,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                        hintText: 'URL',
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey.shade300,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: DropdownButtonFormField<ResourceType>(
                        value: typeNotifier.value,
                        onChanged: (value) => typeNotifier.value = value,
                        items: ResourceType.values
                            .map((type) => DropdownMenuItem(
                                value: type,
                                child: Text(
                                  type.name,
                                  style: TextStyle(
                                    color: type.color,
                                  ),
                                )))
                            .toList(),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                          hintText: 'Тип',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
