import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskat_app/cubit/task_cubit.dart';
import 'package:taskat_app/cubit/task_state.dart';
import 'package:taskat_app/services/firebase_services.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskCubit(FirebaseServicee()),
      child: BlocBuilder<TaskCubit, TaskState>(
        builder: (context, state) => Scaffold(
          backgroundColor: const Color.fromRGBO(65, 111, 228, 1),


          floatingActionButton: FloatingActionButton(
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
                          decoration: const InputDecoration(
                            labelText: 'Task Name',
                          ),
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
            elevation: 10,
            backgroundColor: const Color.fromRGBO(39, 93, 231, 1),
            title: const Text(
              "TSKAT",
              style: TextStyle(
                fontSize: 33,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.delete_forever),
                color: Colors.redAccent,
              ),
            ],
          ),
         body: BlocBuilder<TaskCubit, TaskState>(
  builder: (context, state) {

    if (state is TaskLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state is TaskLoaded) {
      return Center(
        child: Text(
          state.tasks.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      );
    }

    if (state is TaskError) {
      return Center(
        child: Text(
          state.message,
          style: const TextStyle(
            color: Colors.red,
          ),
        ),
      );
    }

    return const Center(
      child: Text(
        'Waiting...',
        style: TextStyle(color: Colors.white),
      ),
    );
  },
),
           ),
      ),
    );
  }
}
