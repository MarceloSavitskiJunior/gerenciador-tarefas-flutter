import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/task.dart';

class ContentFormDialog extends StatefulWidget {
  final Task? actualTask;

  const ContentFormDialog({ Key? key, this.actualTask });

  @override
  State<ContentFormDialog> createState() => ContentFormDialogState();
}

class ContentFormDialogState extends State<ContentFormDialog> {
  final formKey = GlobalKey<FormState>();
  final idController = TextEditingController();
  final descriptionController = TextEditingController();
  final deliveryAtController = TextEditingController();
  final deliveryAtFormat = DateFormat("dd/MM/yyyy");

  @override
  void initState() {
    super.initState();

    final task = widget.actualTask;
    descriptionController.text = task != null ? task.description : "";
    deliveryAtController.text = task != null ? task.formatedDeliveryAt : "";
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: descriptionController,
            decoration: InputDecoration(labelText: 'Descrição'),
            validator: (String? value) {
              if (value == null || value.isEmpty) return "Informe a descrição";
              return null;
            },
          ),
          TextFormField(
            controller: deliveryAtController,
            decoration: InputDecoration(labelText: "Prazo",
              prefixIcon: IconButton(
                  onPressed: _showCalendar,
                  icon: Icon(Icons.calendar_today)
              ),
              suffixIcon: IconButton(
                  onPressed: () => deliveryAtController.clear(),
                  icon: Icon(Icons.close)
              )
            ),
            readOnly: true,
          )
        ],
      ),
    );
  }
  
  void _showCalendar() {
    final formatedDate = deliveryAtController.text;
    var date = DateTime.now();
    if (formatedDate.isNotEmpty) {
      date = deliveryAtFormat.parse(formatedDate);
    }

    showDatePicker(
      context: context,
      initialDate: date,
      firstDate: date.subtract(Duration(days: 100)),
      lastDate: date.add(Duration(days: 100)),
      cancelText: "Cancelar",
    ).then((DateTime? selectedDate) => {
      if (selectedDate != null) {
        deliveryAtController.text = deliveryAtFormat.format(selectedDate)
      }
    });
  }

  bool validatedData() => formKey.currentState?.validate() == true;

  Task get newTask => Task(
    id: widget.actualTask?.id ?? 0,
    description: descriptionController.text,
    deliveryAt: deliveryAtController.text.isEmpty ? null : deliveryAtFormat.parse(deliveryAtController.text)
  );
}