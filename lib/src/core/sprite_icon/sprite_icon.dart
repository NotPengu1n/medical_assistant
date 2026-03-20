import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:async';

import 'package:flutter/services.dart';

// Отрисовка изображения из коллекции картинок
class SpriteIcon extends StatefulWidget {
  final int index;
  final double size;
  final String image;

  const SpriteIcon({
    super.key,
    required this.index, // Номер картинки в коллекции
    this.size = 16, // Размер картинки в коллекции
    required this.image, // Имя файла в каталоге assets/images/
  });

  @override
  State<SpriteIcon> createState() => _SpriteIconState();
}

class _SpriteIconState extends State<SpriteIcon> {
  ui.Image? _image;
  bool _isLoading = true;
  static final Map<String, ui.Image> _imageCache = {};

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    final String imagePath = 'assets/images/${widget.image}';

    // Проверяем кэш
    if (_imageCache.containsKey(imagePath)) {
      setState(() {
        _image = _imageCache[imagePath];
        _isLoading = false;
      });
      return;
    }

    try {
      // Загружаем изображение
      final ByteData data = await rootBundle.load(imagePath);
      final Uint8List bytes = data.buffer.asUint8List();

      // Создаем изображение
      final ui.Image image = await decodeImageFromList(bytes);

      // Сохраняем в кэш
      _imageCache[imagePath] = image;

      if (mounted) {
        setState(() {
          _image = image;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Ошибка загрузки спрайта $imagePath: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        width: widget.size,
        height: widget.size,
        color: Colors.grey[100],
      );
    }

    if (_image == null) {
      return Container(
        width: widget.size,
        height: widget.size,
        color: Colors.grey[300],
        child: Icon(Icons.error, size: widget.size * 0.7, color: Colors.grey),
      );
    }

    return CustomPaint(
      size: Size(widget.size, widget.size),
      painter: _SpritePainter(
        image: _image!,
        index: widget.index,
        spriteWidth: 16,
        spriteHeight: 16,
      ),
    );
  }
}

class _SpritePainter extends CustomPainter {
  final ui.Image image;
  final int index;
  final double spriteWidth;
  final double spriteHeight;

  _SpritePainter({
    required this.image,
    required this.index,
    required this.spriteWidth,
    required this.spriteHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    try {
      final double sourceX = (index * spriteWidth).clamp(0, image.width - spriteWidth);

      final Rect sourceRect = Rect.fromLTWH(
        sourceX,
        0,
        spriteWidth,
        spriteHeight,
      );

      final Rect destRect = Rect.fromLTWH(
        0,
        0,
        size.width,
        size.height,
      );

      final paint = Paint()
        ..filterQuality = FilterQuality.low;

      canvas.drawImageRect(image, sourceRect, destRect, paint);
    } catch (e) {
      debugPrint('Ошибка отрисовки спрайта: $e');
    }
  }

  @override
  bool shouldRepaint(covariant _SpritePainter oldDelegate) {
    return oldDelegate.index != index || oldDelegate.image != image;
  }
}