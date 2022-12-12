import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wuzzufy/utils/Config.dart';

class ProfileImageWidget extends StatelessWidget {
  final double radius;
  final errorIcon;
  final String url;

  const ProfileImageWidget({Key key, this.radius, this.errorIcon, this.url})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
          child: (url != null && url.isNotEmpty) ? CachedNetworkImage(
            imageUrl: Config.PROVIDERS_PHOTO_URL + "/" + url,
            imageBuilder: (context, imageProvider) =>
                Container(
                  height: radius * 2,
                  width: radius * 2,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      alignment: Alignment.center,
                      fit: BoxFit.scaleDown,
                      image: imageProvider,
                    ),
                    border: Border.all(color: Theme.of(context).primaryColor ,style: BorderStyle.solid,width: 1.0),
                    shape: BoxShape.circle,
                  ),),
            placeholder: (context, url) =>
                Center(
                  child: CircularProgressIndicator(),
                ),
            errorWidget: (context, url, error) =>
                CircleAvatar(
                  radius: radius,
                  child: Icon(errorIcon),
                ),
          ) : CircleAvatar(
            radius: radius,
            child: Icon(errorIcon),
          ),
      ),
    );
  }
}
