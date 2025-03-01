import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:todoapp_v3/pages/add_page.dart';

class TareasListPage extends StatefulWidget {
  final Map? tarea;
  const TareasListPage({
    super.key,
    this.tarea
    });

  @override
  State<TareasListPage> createState() => _TareasListPageState();
}

class _TareasListPageState extends State<TareasListPage> {
  bool isLoading = true;
  List items = [];

  @override
  void initState() {
    super.initState();
    fetchTarea();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aplicacion de Tareas'),
        backgroundColor: Colors.black54,
      ),
      
      body: Visibility(
        visible: isLoading,
      replacement: RefreshIndicator(
        onRefresh: fetchTarea,
        child: Visibility(
          visible: items.isNotEmpty,
          replacement: Center(child: Text("Sin Tareas",
          style: Theme.of(context).textTheme.headlineMedium,)),
         child: ListView.builder(
            itemCount: items.length,
            padding: const EdgeInsets.all(12),
             itemBuilder: (context, index){
                final item = items[index] as Map;
                final id = item['id'] as int;
            return Card(
          child: ListTile(
            leading: CircleAvatar(child:Text('${index+1}')),
              title: Text(item['nombre_Tarea']),
               subtitle: Text(item['descripcion_Tarea']),
            trailing: PopupMenuButton(
               onSelected: (value){
                  if (value == 'editar' ){
                    navigateToEditPage(item);
                  }else if(value == 'eliminar'){
                    deleteById(id);
                  }
            },
            itemBuilder: (context) {
            return[
                const PopupMenuItem(
                  value: 'editar',
                  child: Text('Actualizar'),
                  ),
                const PopupMenuItem(
                  value: 'eliminar',
                  child: Text('Eliminar'),
                ),
            ];
          }),
        ),
          );
      },
      ),
        ),
      ),
        child: Center(child : CircularProgressIndicator()),
      ),


      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddPage, 
        label: const Text('Añadir Tarea')),
    );
  }

  Future<void> navigateToEditPage(Map item) async{
    final route = MaterialPageRoute(
      builder: (context) => AddTareaPage(tarea: item),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTarea();
  }



  Future<void> navigateToAddPage() async{
    final route = MaterialPageRoute(builder: (context) => const AddTareaPage(),

    );
   
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTarea();
  }

 Future<void>deleteById(int id) async{
    final url = 'https://10.0.2.2:7070/api/Tareas/borrar/$id';
    final uri = Uri.parse(url);
    
    final response = await http.delete(uri);
    if (response.statusCode == 204){
      final filtro = items.where((element) => element['id'] != id).toList();
      setState(() {
        items = filtro;
      });
    }else{
      showErrorMessage('Eliminacion Fallida');
    }
 }


  void showErrorMessage(String message){
    final snackBar = SnackBar(
      content: Text(message,
       style: const TextStyle(color: Colors.white),
       ),   
       backgroundColor: Colors.red,
      );
       ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }




  Future<void> fetchTarea() async{
   
    const url = 'https://10.0.2.2:7070/api/Tareas';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if(response.statusCode == 200){
        final json = jsonDecode(response.body);  
        final result = json as List;
        setState(() {
          items = result;
        });
    }else{
        print(response.body);
    }

    setState(() {
      isLoading = false;
    });
   
  }

}