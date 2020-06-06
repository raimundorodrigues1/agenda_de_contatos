import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lista_de_contatos/helpers/contact_helper.dart';
import 'package:lista_de_contatos/ui/contact_page.dart';
import 'package:url_launcher/url_launcher.dart';

enum OrderOptions { orderaz, orderza }

class HomePage extends StatefulWidget {
  final double elevation = 0;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();
  List<Contact> contacts = List();

  @override
  void initState() {
    super.initState();

    _getAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Contatos",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.orange,
          centerTitle: true,
          actions: <Widget>[
            PopupMenuButton<OrderOptions>(
              itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
                const PopupMenuItem<OrderOptions>(
                  child: Text("Ordenar de A-Z ↑",
                      style: TextStyle(
                          color: Colors.cyan, fontWeight: FontWeight.bold)),
                  value: OrderOptions.orderaz,
                ),
                const PopupMenuItem<OrderOptions>(
                  child: Text("Ordenar de Z-A ↓",
                      style: TextStyle(
                          color: Colors.cyan, fontWeight: FontWeight.bold)),
                  value: OrderOptions.orderza,
                ),
              ],
              onSelected: _orderList,
            )
          ],
        ),
        // backgroundColor: Colors.black26,

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showContactPage();
          },
          child: Icon(
            Icons.person_add,
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
        body: ListView.builder(
            padding: EdgeInsets.all(10.0),
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              return _contactCard(context, index);
            }));
  }

  Widget _contactCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: contacts[index].img != null
                          ? FileImage(File(
                              contacts[index].img,
                            ))
                          : AssetImage("images/cell.png"),
                      fit: BoxFit.cover),
                ),
              ),
              Container(
                child: Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          contacts[index].name ?? "",
                          style: TextStyle(
                              fontSize: 22.0, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          contacts[index].company ?? "",
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                        Text(
                          contacts[index].email ?? "",
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                        Text(
                          contacts[index].phone ?? "",
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        _showOptions(context, index);
      },
    );
  }
//? Esta funcão seleciona as opcões ligar, editar e exluir.

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: IconButton(
                        icon: Icon(Icons.call),
                        iconSize: 30.0,
                        color: Colors.cyan,
                        hoverColor: Colors.green,
                        padding: EdgeInsets.all(12.0),
                        onPressed: () {
                          launch("tel:${contacts[index].phone}");
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: IconButton(
                        icon: Icon(Icons.edit),
                        iconSize: 30.0,
                        color: Colors.cyan,
                        hoverColor: Colors.green,
                        padding: EdgeInsets.all(12.0),
                        onPressed: () {
                          Navigator.pop(context);
                          _showContactPage(contact: contacts[index]);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: IconButton(
                        icon: Icon(Icons.delete),
                        iconSize: 30.0,
                        color: Colors.cyan,
                        padding: EdgeInsets.all(12.0),
                        onPressed: () {
                          return showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Excluir este contato?",
                                      style: TextStyle(color: Colors.cyan)),
                                  content: Text(
                                      "O seguinte contato será removido da sua lista de contatos.",
                                      style: TextStyle(color: Colors.cyan)),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text("Cancelar",
                                          style: TextStyle(color: Colors.cyan)),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    FlatButton(
                                      child: Text("Excluir",
                                          style: TextStyle(color: Colors.cyan)),
                                      onPressed: () {
                                        helper
                                            .deleteContact(contacts[index].id);
                                        setState(() {
                                          contacts.removeAt(index);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        });
                                      },
                                    ),
                                  ],
                                );
                              });
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  void _showContactPage({Contact contact}) async {
    final recContact = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ContactPage(
                  contact: contact,
                )));
    if (recContact != null) {
      if (contact != null) {
        await helper.updateContat(recContact);
        _getAllContacts();
      } else {
        await helper.saveContacter(recContact);
      }
      _getAllContacts();
    }
  }

  void _getAllContacts() {
    helper.getAllContacts().then((list) {
      setState(() {
        contacts = list;
      });
    });
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderaz:
        contacts.sort((a, b) {
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        contacts.sort((a, b) {
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        });
        break;
    }
    setState(() {});
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancelar"),
      onPressed: () {},
    );
    Widget deleteButton = FlatButton(
      child: Text("Excluir"),
      onPressed: () {},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Excluir este contato"),
      content: Text("O contato será removido da sua lista de contatos."),
      actions: [
        cancelButton,
        deleteButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
