import 'package:flutter/material.dart';
import 'package:jade_talk/models/message_model.dart';

class StackedReations extends StatelessWidget {
  const StackedReations(
      {super.key,
      required this.size,
      required this.message,
      required this.onTap});

  final MessageModel message;
  final double size;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    //get the reactions from the list
    final messageReactions = message.reactions.map((e) => e.split('-')[1]).toList();
     
    // if reactions are greater than 5, get the first 5 reactions
    final reactionsToShow =
        messageReactions.length > 5 ? messageReactions.sublist(0, 5) : messageReactions;

// remaining reactions
    final remainingReactions = messageReactions.length - reactionsToShow.length;

    final allReactions = reactionsToShow
        .asMap()
        .map((index, reaction) {
          final value = Container(
            margin: EdgeInsets.only(left: index * 20.0),
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade400,
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: ClipOval(
              child: Text(
                reaction,
                style: TextStyle(fontSize: size),
              ),
            ),
          );
          return MapEntry(index, value);
        })
        .values
        .toList();

    return GestureDetector(
      onTap: onTap(),
      child: Row(
        children: [
          Stack(children: allReactions),
          if (remainingReactions > 0) ...[
            Positioned(
              left: 100,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade500,
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      '+$remainingReactions',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }
}
