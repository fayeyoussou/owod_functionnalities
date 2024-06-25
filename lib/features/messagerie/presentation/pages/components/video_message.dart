import 'package:owod_functionnalities/core/theme/app_pallete.dart';
import 'package:owod_functionnalities/features/messagerie/data/models/message_model.dart';
import 'package:flutter/material.dart';


class VideoMessage extends StatelessWidget {
  const VideoMessage({super.key, required this.messageModel,});
  final MessageModel messageModel;

  @override
  Widget build(BuildContext context) {
    var rad10 = const Radius.circular(10);
    return SizedBox(
       // 45% of total width
      child: Container(
        decoration : BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: rad10 ,topRight: rad10 , bottomLeft: rad10 ),
          color: AppPalette.gradient3.withAlpha(100)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(messageModel.content,width: MediaQuery.of(context).size.width * 0.45,fit: BoxFit.contain,),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0,bottom: 8,top: 3),
              child: Text(messageModel.description ??''),
            )
          ],
        ),
      ),
    );
  }
}
