import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/user_provider.dart';

class ProfileImageWidget extends StatelessWidget {
  final double size;
  final bool showEditButton;

  const ProfileImageWidget({
    super.key,
    this.size = 100,
    this.showEditButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Stack(
          children: [
            // Profile Image Circle
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: FutureBuilder<bool>(
                  future: userProvider.hasProfileImage(),
                  builder: (context, snapshot) {
                    final hasImage = snapshot.data ?? false;
                    if (hasImage) {
                      final imageWidget = userProvider.getProfileImageWidget(
                        width: size,
                        height: size,
                        fit: BoxFit.cover,
                      );
                      if (imageWidget != null) {
                        return imageWidget;
                      }
                    }
                    // Default placeholder
                    return Container(
                      color: Colors.grey[200],
                      child: Icon(
                        Icons.person,
                        size: size * 0.6,
                        color: Colors.grey[600],
                      ),
                    );
                  },
                ),
              ),
            ),
            
            // Edit Button
            if (showEditButton)
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => _showImageSourceDialog(context, userProvider),
                  child: Container(
                    width: size * 0.3,
                    height: size * 0.3,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: size * 0.15,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  void _showImageSourceDialog(BuildContext context, UserProvider userProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () async {
                  Navigator.of(context).pop();
                  try {
                    await userProvider.changeUserImage(source: ImageSource.gallery);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Profile image updated successfully!')),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${e.toString()}')),
                      );
                    }
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () async {
                  Navigator.of(context).pop();
                  try {
                    await userProvider.changeUserImageFromCamera();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Profile image updated successfully!')),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${e.toString()}')),
                      );
                    }
                  }
                },
              ),
              FutureBuilder<bool>(
                future: userProvider.hasProfileImage(),
                builder: (context, snapshot) {
                  final hasImage = snapshot.data ?? false;
                  if (hasImage) {
                    return ListTile(
                      leading: const Icon(Icons.delete),
                      title: const Text('Remove Image'),
                      onTap: () async {
                        Navigator.of(context).pop();
                        try {
                          await userProvider.removeProfileImage();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Profile image removed successfully!')),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: ${e.toString()}')),
                            );
                          }
                        }
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
