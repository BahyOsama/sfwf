import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class OptimizedImage extends StatelessWidget {
  final String? assetPath;
  final String? networkUrl;
  final String? filePath;
  final Uint8List? bytes;
  final double? width;
  final double? height;
  final BoxFit fit;
  final int? maxWidth;
  final int? maxHeight;
  final Widget? placeholder;
  final Widget? errorWidget;
  final Map<String, String>? httpHeaders;

  const OptimizedImage({
    super.key,
    this.assetPath,
    this.networkUrl,
    this.filePath,
    this.bytes,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.maxWidth,
    this.maxHeight,
    this.placeholder,
    this.errorWidget,
    this.httpHeaders,
  }) : assert(
         (assetPath != null ? 1 : 0) +
                 (networkUrl != null ? 1 : 0) +
                 (filePath != null ? 1 : 0) +
                 (bytes != null ? 1 : 0) ==
             1,
         'Provide exactly one of: assetPath, networkUrl, filePath, bytes',
       );

  factory OptimizedImage.asset(
    String path, {
    Key? key,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    int? maxWidth,
    int? maxHeight,
    Widget? placeholder,
    Widget? errorWidget,
  }) =>
      OptimizedImage(
        key: key,
        assetPath: path,
        width: width,
        height: height,
        fit: fit,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        placeholder: placeholder,
        errorWidget: errorWidget,
      );

  factory OptimizedImage.network(
    String url, {
    Key? key,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    int? maxWidth,
    int? maxHeight,
    Widget? placeholder,
    Widget? errorWidget,
    Map<String, String>? httpHeaders,
  }) =>
      OptimizedImage(
        key: key,
        networkUrl: url,
        width: width,
        height: height,
        fit: fit,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        placeholder: placeholder,
        errorWidget: errorWidget,
        httpHeaders: httpHeaders,
      );

  factory OptimizedImage.file(
    String path, {
    Key? key,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    int? maxWidth,
    int? maxHeight,
    Widget? placeholder,
    Widget? errorWidget,
  }) =>
      OptimizedImage(
        key: key,
        filePath: path,
        width: width,
        height: height,
        fit: fit,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        placeholder: placeholder,
        errorWidget: errorWidget,
      );

  factory OptimizedImage.memory(
    Uint8List bytes, {
    Key? key,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    int? maxWidth,
    int? maxHeight,
    Widget? placeholder,
    Widget? errorWidget,
  }) =>
      OptimizedImage(
        key: key,
        bytes: bytes,
        width: width,
        height: height,
        fit: fit,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        placeholder: placeholder,
        errorWidget: errorWidget,
      );

  @override
  Widget build(BuildContext context) {
    Widget image;

    if (assetPath != null) {
      image = Image.asset(
        assetPath!,
        width: width,
        height: height,
        fit: fit,
      );
    } else if (networkUrl != null) {
      image = Image.network(
        networkUrl!,
        width: width,
        height: height,
        fit: fit,
        headers: httpHeaders,
        loadingBuilder: placeholder != null
            ? (context, child, progress) =>
                progress == null ? child : placeholder!
            : null,
        errorBuilder: errorWidget != null
            ? (context, error, stackTrace) => errorWidget!
            : null,
      );
    } else if (filePath != null) {
      image = Image.file(
        File(filePath!),
        width: width,
        height: height,
        fit: fit,
        errorBuilder: errorWidget != null
            ? (context, error, stackTrace) => errorWidget!
            : null,
      );
    } else if (bytes != null) {
      image = Image.memory(
        bytes!,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: errorWidget != null
            ? (context, error, stackTrace) => errorWidget!
            : null,
      );
    } else {
      return const SizedBox.shrink();
    }

    if (maxWidth == null && maxHeight == null) return image;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: maxWidth?.toDouble() ?? double.infinity,
        maxHeight: maxHeight?.toDouble() ?? double.infinity,
      ),
      child: image,
    );
  }
}
