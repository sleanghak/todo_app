// import 'package:flutter/material.dart';

// class TodoCard extends StatelessWidget {
//   final int index;
//   final Map item;
//   final Function(Map) navigateToEditPage;
//   final Function(String) handleDeleteDataById;

//   const TodoCard({
//     super.key,
//     required this.index,
//     required this.item,
//     required this.navigateToEditPage,
//     required this.handleDeleteDataById,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final id = item[_id] as String;
//     return Card(
//       child: ListTile(
//         leading: CircleAvatar(
//           child: Text('${index + 1}'),
//         ),
//         title: Text(item['title']),
//         subtitle: Text(item['description']),
//         trailing: PopupMenuButton(
//           onSelected: (value) {
//             if (value == 'edit') {
//               // Open Edit page
//               navigateToEditPage(item);
//             } else if (value == 'delete') {
//               // Delete and remove the item
//               handleDeleteDataById(id);
//             }
//           },
//           itemBuilder: (context) {
//             return [
//               PopupMenuItem(
//                 child: Text('Edit'),
//                 value: 'edit',
//               ),
//               PopupMenuItem(
//                 child: Text('Delete'),
//                 value: 'delete',
//               ),
//             ];
//           },
//         ),
//       ),
//     );
//   }
// }
