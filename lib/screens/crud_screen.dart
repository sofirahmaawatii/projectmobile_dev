import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/item_model.dart';

class CrudScreen extends StatefulWidget {
  const CrudScreen({super.key});

  @override
  State<CrudScreen> createState() => _CrudScreenState();
}

class _CrudScreenState extends State<CrudScreen> {
  final List<ItemModel> _items = [];

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  bool isLoading = false;

  static const Color blue = Color(0xFF087BC1);

  // FUNGSI POST API
  Future<void> _addItem() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'title': _titleController.text.trim(),
          'body': _descController.text.trim(),
          'userId': 1,
        }),
      );

      if (response.statusCode == 201) {
        final result = jsonDecode(response.body);

        if (!mounted) return;

        setState(() {
          _items.insert(
            0,
            ItemModel(
              id: result['id'].toString(),
              title: result['title'],
              description: result['body'],
            ),
          );

          isLoading = false;
        });

        _titleController.clear();
        _descController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Berita berhasil ditambahkan!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw Exception('Gagal mengirim data');
      }
    } catch (e) {
      if (!mounted) return;

      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // FORM TAMBAH DATA
  void _showAddForm() {
    _titleController.clear();
    _descController.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 25,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Tambah Berita Baru',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Judul Berita',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.title),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Judul wajib diisi';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 15),

                      TextFormField(
                        controller: _descController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          labelText: 'Deskripsi Berita',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.description),
                          alignLabelWithHint: true,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Deskripsi wajib diisi';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: isLoading
                              ? null
                              : () async {
                                  setModalState(() {});
                                  await _addItem();

                                  if (!mounted) return;

                                  if (!isLoading &&
                                      _titleController.text.isEmpty &&
                                      _descController.text.isEmpty) {
                                    Navigator.pop(context);
                                  }
                                },
                          icon: isLoading
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.send),
                          label: Text(
                            isLoading ? 'Mengirim...' : 'Simpan Berita',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: blue,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kelola Data (CRUD)')),

      body: _items.isEmpty
          ? const Center(child: Text('Belum ada data berita'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _items.length,
              itemBuilder: (ctx, index) => Card(
                child: ListTile(
                  title: Text(_items[index].title),
                  subtitle: Text(_items[index].description),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        _items.removeAt(index);
                      });
                    },
                  ),
                ),
              ),
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: _showAddForm,
        backgroundColor: blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
