import 'dart:convert';
import 'dart:math'; 
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTareaPage extends StatefulWidget {
  final Map? tarea;
  const AddTareaPage({
    super.key,
    this.tarea,
  });

  @override
  State<AddTareaPage> createState() => _AddTareaPageState();
}

class _AddTareaPageState extends State<AddTareaPage> {

  TextEditingController nombreTarea2 = TextEditingController();
  TextEditingController descripcionTarea2 = TextEditingController();

  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final tarea = widget.tarea;
    if(tarea != null ){
        isEdit = true;
        final nombreTarea1 = tarea['nombre_Tarea'];
         final descripcionTarea1 = tarea['descripcion_Tarea'];
         nombreTarea2.text = nombreTarea1;
         descripcionTarea2.text = descripcionTarea1;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(
          isEdit ? 'Actualizar Tarea': 'Añadir Tarea'
          ),
        backgroundColor: Colors.black54,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: nombreTarea2,
            decoration: const InputDecoration(hintText: 'Ingresa el Nombre de la Tarea'),

          ),


           const SizedBox(height: 20),

          TextField(
            controller: descripcionTarea2,
            decoration: const InputDecoration(

              labelText: "Ingresa la descripcion de la Tarea"
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed:  isEdit ? actualizarDatos : subirDatos, 
          child: Text(
            isEdit ? 'Actualizar' : 'Guardar'),
          )
        ],
      ),
    );  
  }


  Future<void> actualizarDatos() async{
    final tarea = widget.tarea;
    if(tarea == null){
      print("No se puede actualizar sin todos los datos de la tarea");
      return;
    }
    final id = tarea['id'] as int;
    final nombreTarea = nombreTarea2.text;
    final descripcionTarea = descripcionTarea2.text;
    const estadoTarea = false;
    const isDeletedTarea = false;
    final body = {
      "id": id,
      "nombre_Tarea": nombreTarea,
      "descripcion_Tarea": descripcionTarea,
      "isCompleted_Tarea": estadoTarea,
      "isDeleted_Tarea": isDeletedTarea
    };
    final url = 'https://10.0.2.2:7070/api/Tareas/edit/$id';
    final uri = Uri.parse(url);
    final response = await  http.put(
      uri,
     body: jsonEncode(body),
     headers: {'Content-Type': 'application/json'},
     );
      if(response.statusCode == 204){
      showSuccessMessage('Actualizado con Exito');
    }else{
       showErrorMessage('Error de Actualizacion');
    }

  }



  Future<void> subirDatos() async{

    var rand = Random();
    int randomNumber = rand.nextInt(1000);


    final id = randomNumber;
    final nombreTarea = nombreTarea2.text;
    final descripcionTarea = descripcionTarea2.text;
    const estadoTarea = false;
    const isDeletedTarea = false;
    final body = {
      "id": id,
      "nombre_Tarea": nombreTarea,
      "descripcion_Tarea": descripcionTarea,
      "isCompleted_Tarea": estadoTarea,
      "isDeleted_Tarea": isDeletedTarea
    };
    const url = 'https://10.0.2.2:7070/api/Tareas';
    final uri = Uri.parse(url);
    final response = await  http.post(
      uri,
     body: jsonEncode(body),
     headers: {'Content-Type': 'application/json'},
     );
    if(response.statusCode == 201){
      nombreTarea2.text = '';
      descripcionTarea2.text = '';
      showSuccessMessage('Registrado con Exito');
    }else{
       nombreTarea2.text = '';
       descripcionTarea2.text = '';
       showErrorMessage('Error!!');
      
    }
   
  }

  void showSuccessMessage(String message){
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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


}