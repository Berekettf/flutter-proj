import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        setState(() {
          userData = doc.data()!;
          _usernameController.text = userData?['username'] ?? '';
          _fullNameController.text = userData?['fullName'] ?? '';
          _bioController.text = userData?['bio'] ?? '';
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      await _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('${user.uid}.jpg');
      
      await storageRef.putFile(_imageFile!);
      final downloadUrl = await storageRef.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'profileImage': downloadUrl});

      await _loadUserData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _updateProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
            'username': _usernameController.text,
            'fullName': _fullNameController.text,
            'bio': _bioController.text,
          });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      setState(() {
        _isEditing = false;
      });
      await _loadUserData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.signOutAlt),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (!mounted) return;
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
          ),
          IconButton(
            icon: _isEditing 
                ? const FaIcon(FontAwesomeIcons.save)
                : const FaIcon(FontAwesomeIcons.edit),
            onPressed: () {
              if (_isEditing) {
                _updateProfile();
              } else {
                setState(() {
                  _isEditing = true;
                });
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: _getProfileImage(),
                    child: _imageFile == null &&
                            (userData?['profileImage'] == null ||
                                userData!['profileImage'].isEmpty)
                        ? const FaIcon(FontAwesomeIcons.user, size: 60)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        icon: const FaIcon(FontAwesomeIcons.camera, color: Colors.white),
                        onPressed: _pickImage,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _isEditing
                ? _buildEditForm()
                : _buildProfileInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Column(
      children: [
        Card(
          child: ListTile(
            leading: const FaIcon(FontAwesomeIcons.user),
            title: const Text('Username'),
            subtitle: Text(userData?['username'] ?? 'Not set'),
          ),
        ),
        Card(
          child: ListTile(
            leading: const FaIcon(FontAwesomeIcons.idCard),
            title: const Text('Full Name'),
            subtitle: Text(userData?['fullName'] ?? 'Not set'),
          ),
        ),
        Card(
          child: ListTile(
            leading: const FaIcon(FontAwesomeIcons.envelope),
            title: const Text('Email'),
            subtitle: Text(FirebaseAuth.instance.currentUser?.email ?? 'No email'),
          ),
        ),
        Card(
          child: ListTile(
            leading: const FaIcon(FontAwesomeIcons.infoCircle),
            title: const Text('Bio'),
            subtitle: Text(userData?['bio']?.isNotEmpty == true 
                ? userData!['bio'] 
                : 'No bio yet'),
          ),
        ),
        Card(
          child: ListTile(
            leading: const FaIcon(FontAwesomeIcons.calendarAlt),
            title: const Text('Member Since'),
            subtitle: Text(userData?['createdAt'] != null
                ? _formatDate((userData!['createdAt'] as Timestamp).toDate())
                : 'Unknown'),
          ),
        ),
      ],
    );
  }

  Widget _buildEditForm() {
    return Column(
      children: [
        TextFormField(
          controller: _usernameController,
          decoration: InputDecoration(
            labelText: 'Username',
            prefixIcon: const FaIcon(FontAwesomeIcons.user),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _fullNameController,
          decoration: InputDecoration(
            labelText: 'Full Name',
            prefixIcon: const FaIcon(FontAwesomeIcons.idCard),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _bioController,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: 'Bio',
            prefixIcon: const FaIcon(FontAwesomeIcons.infoCircle),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          icon: const FaIcon(FontAwesomeIcons.save),
          label: const Text('Save Changes'),
          onPressed: _updateProfile,
        ),
      ],
    );
  }

  ImageProvider? _getProfileImage() {
    if (_imageFile != null) {
      return FileImage(_imageFile!);
    } else if (userData?['profileImage'] != null && 
               userData!['profileImage'].isNotEmpty) {
      return NetworkImage(userData!['profileImage']);
    }
    return null;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}