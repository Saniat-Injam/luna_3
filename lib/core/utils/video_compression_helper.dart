import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:video_compress/video_compress.dart';

/// Helper class for video compression
/// Compresses videos to reduce file size for better upload performance
class VideoCompressionHelper {
  /// Compress video file to reduce size for upload
  /// Returns compressed file path or null if compression fails
  static Future<File?> compressVideo({
    required File videoFile,
    VideoQuality quality = VideoQuality.MediumQuality,
    bool deleteOrigin = false,
    Function(double)? onProgress,
  }) async {
    try {
      // Check if file exists
      if (!await videoFile.exists()) {
        debugPrint('Video file does not exist');
        return null;
      }

      // Get file size before compression
      final originalSize = await videoFile.length();
      final originalSizeMB = originalSize / (1024 * 1024);

      debugPrint(
        'Original video size: ${originalSizeMB.toStringAsFixed(2)} MB',
      );

      // If file is already small enough, return original file
      if (originalSizeMB <= 10) {
        debugPrint('Video is already small enough, no compression needed');
        return videoFile;
      }

      // Subscribe to compression progress
      if (onProgress != null) {
        VideoCompress.compressProgress$.subscribe((progress) {
          onProgress(progress);
        });
      }

      // Get temporary directory for compressed file

      // Compress the video
      final MediaInfo? info = await VideoCompress.compressVideo(
        videoFile.path,
        quality: quality,
        deleteOrigin: deleteOrigin,
        includeAudio: true,
        frameRate: 24, // Reduce frame rate to decrease size
      );

      if (info != null && info.path != null) {
        final compressedFile = File(info.path!);
        final compressedSize = await compressedFile.length();
        final compressedSizeMB = compressedSize / (1024 * 1024);

        debugPrint(
          'Compressed video size: ${compressedSizeMB.toStringAsFixed(2)} MB',
        );
        debugPrint(
          'Compression ratio: ${((originalSize - compressedSize) / originalSize * 100).toStringAsFixed(1)}%',
        );

        return compressedFile;
      } else {
        debugPrint('Video compression failed');
        return null;
      }
    } catch (e) {
      debugPrint('Error compressing video: $e');
      return null;
    } finally {
      // Clean up subscription
      VideoCompress.dispose();
    }
  }

  /// Get video file information
  static Future<MediaInfo?> getVideoInfo(String videoPath) async {
    try {
      return await VideoCompress.getMediaInfo(videoPath);
    } catch (e) {
      debugPrint('Error getting video info: $e');
      return null;
    }
  }

  /// Check if video needs compression based on size
  static Future<bool> shouldCompressVideo(
    File videoFile, {
    double maxSizeMB = 10,
  }) async {
    try {
      final size = await videoFile.length();
      final sizeMB = size / (1024 * 1024);
      return sizeMB > maxSizeMB;
    } catch (e) {
      return false;
    }
  }

  /// Get recommended compression quality based on file size
  static VideoQuality getRecommendedQuality(double fileSizeMB) {
    if (fileSizeMB > 50) {
      return VideoQuality.LowQuality;
    } else if (fileSizeMB > 20) {
      return VideoQuality.MediumQuality;
    } else {
      return VideoQuality.DefaultQuality;
    }
  }

  /// Cancel ongoing compression
  static void cancelCompression() {
    VideoCompress.cancelCompression();
  }

  /// Delete temporary compressed files
  static Future<void> cleanupTempFiles() async {
    try {
      VideoCompress.deleteAllCache();
    } catch (e) {
      debugPrint('Error cleaning up temp files: $e');
    }
  }
}
