import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:lista_de_contatos/helpers/contact_helper.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;

  ContactPage({this.contact});
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _nameController = TextEditingController();
  final _companyController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final ImagePicker _picker = ImagePicker();

  bool userEdited = false;

  Contact _editedContact;

  @override
  void initState() {
    super.initState();

    if (widget.contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact.toMap());
      _nameController.text = _editedContact.name;
      _companyController.text = _editedContact.company;
      _emailController.text = _editedContact.email;
      _phoneController.text = _editedContact.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _editedContact.name ?? "Novo Contato",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.orange,
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if ((_editedContact.name != null &&
                    _editedContact.name.isNotEmpty) &&
                (_editedContact.phone != null &&
                    _editedContact.phone.isNotEmpty)) {
              Navigator.pop(context, _editedContact);
            } else {
              FocusScope.of(context).requestFocus(_nameFocus);
              FocusScope.of(context).requestFocus(_phoneFocus);
            }
          },
          child: Icon(
            Icons.save,
            size: 40.0,
          ),
          backgroundColor: Colors.black,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: BottomAppBar(
          color: Colors.orange,
          child: Container(
            height: 58.0,
          ),
        ),

        //? Corpo do App
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: Container(
                  width: 80.0,
                  height: 80.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: _editedContact.img != null
                            ? FileImage(File(_editedContact.img))
                            : AssetImage("images/cell.png"),
                        fit: BoxFit.cover),
                  ),
                ),
                onTap: () {
                  return showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Alterar foto",
                              style: TextStyle(color: Colors.cyan)),
                          content:
                              Text("", style: TextStyle(color: Colors.cyan)),
                          actions: <Widget>[
                            FlatButton(
                              child: Text("Tirar foto",
                                  style: TextStyle(color: Colors.cyan)),
                              onPressed: () async {
                                final PickedFile file = await _picker.getImage(
                                    source: ImageSource.camera);
                                if (file == null) return;
                                setState(() {
                                  _editedContact.img = file.path;
                                });

                                Navigator.pop(context);
                              },
                            ),
                            FlatButton(
                              child: Text("Escolher foto",
                                  style: TextStyle(color: Colors.cyan)),
                              onPressed: () async {
                                final PickedFile file = await _picker.getImage(
                                    source: ImageSource.gallery);
                                if (file == null) return;
                                setState(() {
                                  _editedContact.img = file.path;
                                });

                                Navigator.pop(context);
                              },
                            ),
                            FlatButton(
                              child: Text("Cancelar",
                                  style: TextStyle(color: Colors.cyan)),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      });
                },
              ),
              Divider(
                height: 40.0,
              ),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                    labelText: "Nome",
                    border: OutlineInputBorder(),
                    //  labelStyle: TextStyle(color: Colors.cyan),
                    icon: Icon(Icons.person)),
                style: TextStyle(fontSize: 20.0),
                focusNode: _nameFocus,
                onChanged: (text) {
                  userEdited = true;
                  setState(() {
                    _editedContact.name = text;
                  });
                },
              ),
              Divider(
                height: 20.0,
              ),
              TextField(
                controller: _companyController,
                decoration: InputDecoration(
                    labelText: "Empresa",
                    border: OutlineInputBorder(),
                    //  labelStyle: TextStyle(color: Colors.cyan),
                    icon: Icon(Icons.business)),
                style: TextStyle(fontSize: 20.0),
                onChanged: (text) {
                  userEdited = true;
                  setState(() {
                    _editedContact.company = text;
                  });
                },
              ),
              Divider(
                height: 10.0,
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                    labelText: "E-mail",
                    border: OutlineInputBorder(),
                    // labelStyle: TextStyle(color: Colors.cyan),
                    icon: Icon(Icons.email)),
                style: TextStyle(fontSize: 20.0),
                onChanged: (text) {
                  userEdited = true;

                  _editedContact.email = text;
                },
                keyboardType: TextInputType.emailAddress,
              ),
              Divider(
                height: 10.0,
              ),
              TextField(
                controller: _phoneController,
                focusNode: _phoneFocus,
                decoration: InputDecoration(
                    labelText: "Telefone",
                    border: OutlineInputBorder(),
                    //  labelStyle: TextStyle(color: Colors.cyan),
                    icon: Icon(Icons.phone_android)),
                style: TextStyle(fontSize: 20.0),
                onChanged: (text) {
                  userEdited = true;

                  _editedContact.phone = text;
                },
                keyboardType: TextInputType.phone,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _requestPop() {
    if (userEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Descartar Alterações?",
                  style: TextStyle(color: Colors.cyan)),
              content: Text("Se sair as alterações serão perdidas.",
                  style: TextStyle(color: Colors.cyan)),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cancelar", style: TextStyle(color: Colors.cyan)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text("Sim", style: TextStyle(color: Colors.cyan)),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
