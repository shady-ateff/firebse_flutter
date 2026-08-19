import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskat_app/cubit/task_cubit.dart';
import 'package:taskat_app/cubit/task_state.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2457D6),
        foregroundColor: Colors.white,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              final nameController = TextEditingController();
              final descriptionController = TextEditingController();

              return AlertDialog(
                title: const Text('Add Task'),

                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Task Name'),
                    ),

                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                    ),
                  ],
                ),

                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      context.read<TaskCubit>().addTask({
                        'name': nameController.text,
                        'description': descriptionController.text,
                        'isCompleted': false,
                      });

                      Navigator.pop(context);
                    },
                    child: const Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF5F7FB),
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'TSKAT',
          style: TextStyle(
            color: Color(0xFF17213B),
            fontSize: 24,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded),
            color: const Color(0xFF17213B),
          ),
        ],
      ),
      body: BlocBuilder<TaskCubit, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TaskLoaded) {
            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Your tasks',
                      style: TextStyle(
                        color: Color(0xFF17213B),
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '${state.tasks.length} total',
                      style: const TextStyle(color: Color(0xFF7B849B)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (state.tasks.isEmpty)
                  const _EmptyTasks()
                else
                  ...state.tasks.map((task) {
                    final taskData = task.data() as Map<String, dynamic>;

                    return _TaskTile(
                      taskId: task.id,
                      title:
                          (taskData['name'] as String?)?.trim().isNotEmpty ==
                              true
                          ? taskData['name'] as String
                          : 'Untitled task',
                      description: taskData['description'] as String? ?? '',
                      isCompleted: taskData['isCompleted'] == true,
                      onChanged: (value) => context
                          .read<TaskCubit>()
                          .updateTask(task.id, {'isCompleted': value}),
                    );
                  }),
              ],
            );
          }

          if (state is TaskError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Color(0xFFC43D53)),
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  const _TaskTile({
    required this.taskId,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.onChanged,
  });

  final String taskId;
  final String title;
  final String description;
  final bool isCompleted;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE6EAF2)),
      ),
      child: CheckboxListTile(
        value: isCompleted,
        onChanged: (value) => onChanged(value ?? false),
        activeColor: const Color(0xFF2457D6),
        controlAffinity: ListTileControlAffinity.leading,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: const Color(0xFF17213B),
                fontWeight: FontWeight.w700,
                decoration: isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
            IconButton(
              onPressed: () {
                context.read<TaskCubit>().deleteTask(taskId);
              },
              icon: const Icon(Icons.delete_outline_rounded),
              color: const Color(0xFFC43D53),
            ),
          ],
        ),
        subtitle: description.isEmpty ? null : Text(description),
      ),
    );
  }
}

class _EmptyTasks extends StatelessWidget {
  const _EmptyTasks();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE6EAF2)),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            size: 42,
            color: Color(0xFF2457D6),
          ),
          SizedBox(height: 12),
          Text(
            'Nothing on your list',
            style: TextStyle(
              color: Color(0xFF17213B),
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Tap + to add a task.',
            style: TextStyle(color: Color(0xFF7B849B)),
          ),
        ],
      ),
    );
  }
}
