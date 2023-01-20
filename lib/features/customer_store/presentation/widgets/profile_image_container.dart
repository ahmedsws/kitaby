import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileImageContainer extends StatelessWidget {
  const ProfileImageContainer({
    Key? key,
    this.imagePath,
    this.image,
    this.errorBuilder,
  }) : super(key: key);

  final String? imagePath;
  final Widget? image;
  final Widget Function(BuildContext, Object, StackTrace)? errorBuilder;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 112.h,
      width: 112.h,
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(100.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 24.r,
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100.r),
        clipBehavior: Clip.antiAlias,
        child: image ??
            (imagePath != null
                ? Image.network(
                    imagePath!,
                    fit: BoxFit.cover,
                    // errorBuilder: errorBuilder,
                  )
                : Icon(
                    Icons.person,
                    size: 40.w,
                    color: Color(0xFF231C45).withOpacity(.9),
                  )),
      ),
    );
  }
}
