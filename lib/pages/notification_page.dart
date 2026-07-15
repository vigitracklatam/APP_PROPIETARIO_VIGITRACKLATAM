import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final Map<String, List<NotificationMessage>> notifications = {
    '28/10/2024': [
      NotificationMessage(
        title: 'Mensaje del Administrador',
        body:
            'Nuevo mensaje del administrador.Nuevo mensaje del administrador.Nuevo mensaje del administrador.',
        dateTime: '10:00 AM',
      ),
      NotificationMessage(
        title: 'Actualización del Estado',
        body: 'Actualización del estado del pedido.',
        dateTime: '11:30 AM',
      ),
      NotificationMessage(
        title: 'Actualización del Estado',
        body: 'Actualización del estado del pedido.',
        dateTime: '2024/05/10 11:30:00',
      ),
      NotificationMessage(
        title: 'Actualización del Estado',
        body: 'Actualización del estado del pedido.',
        dateTime: '11:30 AM',
      ),
    ],
  };

  Map<String, bool> readStatus = {};

  @override
  void initState() {
    super.initState();
    for (var entry in notifications.entries) {
      for (var message in entry.value) {
        readStatus[message.body] = false; // No leído por defecto
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Notificaciones"),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: Container(
          child: ListView(
            children: [
              ...notifications.entries.map((entry) {
                return _buildNotificationList(entry.value);
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  // Lista de notificaciones
  Widget _buildNotificationList(List<NotificationMessage> messages) {
    return Column(
      children:
          messages.map((message) => _buildNotificationItem(message)).toList(),
    );
  }

  Widget _buildNotificationItem(NotificationMessage message) {
    bool isRead = readStatus[message.body] ?? false;

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              readStatus[message.body] = true; // Marcar como leído
            });
          },
          child: Card(
            margin: EdgeInsets.zero, // Sin margen alrededor de la tarjeta
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero, // Sin bordes redondeados
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título y fecha en una fila
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          message.title,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600, // Título destacado
                            overflow:
                                TextOverflow.ellipsis, // Recorta si es largo
                          ),
                        ),
                      ),
                      const SizedBox(
                          width: 8.0), // Espacio entre título y fecha
                      Text(
                        message.dateTime,
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4.0), // Espacio entre título y cuerpo
                  // Cuerpo del mensaje y el ícono al final de la misma línea
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          message.body,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                            overflow:
                                TextOverflow.ellipsis, // Recorta si es largo
                          ),
                          maxLines: 2, // Limita a dos líneas
                        ),
                      ),
                      const SizedBox(
                          width: 8.0), // Espacio entre cuerpo e icono
                      Icon(
                        Icons.circle,
                        size: 8.0, // Ícono pequeño y sutil
                        color: isRead
                            ? Colors.grey
                            : Colors.blue, // Estado dinámico
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const Divider(
          color: Colors.grey, // Línea gris
          thickness: 1.0, // Grosor de la línea
          height: 1.0, // Espacio vertical adicional
        ),
      ],
    );
  }
}

// Modelo para los mensajes de notificación
class NotificationMessage {
  final String title;
  final String body;
  final String dateTime;

  NotificationMessage({
    required this.title,
    required this.body,
    required this.dateTime,
  });
}
