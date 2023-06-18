import 'package:flutter/material.dart';
import 'package:kiakkai_db/form/residents/widget/address.dart';
import 'package:kiakkai_db/form/residents/widget/agency.dart';
import 'package:kiakkai_db/form/residents/widget/citizen_id.dart';
import 'package:kiakkai_db/form/residents/widget/lastname.dart';
import 'package:kiakkai_db/form/residents/widget/name.dart';
import 'package:kiakkai_db/form/residents/widget/phone.dart';
import 'package:kiakkai_db/form/residents/widget/prefix.dart';
import 'package:kiakkai_db/form/residents/widget/relationship.dart';

class AddResidentForm extends StatefulWidget {
  const AddResidentForm({super.key});

  @override
  AddResidentFormState createState() => AddResidentFormState();
}

class AddResidentFormState extends State<AddResidentForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String address = "";
  String prefix = "";
  String name = "";
  String lastname = "";
  String cid = "";
  String phone = "";
  String agency = "";
  String relationship = "";

  void _getAddressFromChild(String value) {
    setState(() {
      address = value;
    });
  }

  void _getPrefixFromChild(String value) {
    setState(() {
      prefix = value;
    });
  }

  void _getNameFromChild(String value) {
    setState(() {
      name = value;
    });
  }

  void _getLastnameFromChild(String value) {
    setState(() {
      lastname = value;
    });
  }

  void _getCidFromChild(String value) {
    setState(() {
      cid = value;
    });
  }

  void _getPhoneFromChild(String value) {
    setState(() {
      phone = value;
    });
  }

  void _getAgencyFromChild(String value) {
    setState(() {
      agency = value;
    });
  }

  void _getRelationshipFromChild(String value) {
    setState(() {
      relationship = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double visibleHeight = MediaQuery.of(context).viewInsets.bottom;
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: SizedBox(
        // change by size of the keyboard
        height: MediaQuery.of(context).size.height * 0.8 - visibleHeight,
        child: ListView(padding: EdgeInsets.all(16.0), children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: AddressWidget(
                          callback: _getAddressFromChild,
                          formKey: _formKey,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 6.0),
                          child: PrefixWidget(
                            callback: _getPrefixFromChild,
                            formKey: _formKey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: NameWidget(
                    callback: _getNameFromChild,
                    formKey: _formKey,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: LastNameWidget(
                    callback: _getLastnameFromChild,
                    formKey: _formKey,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: CidWidget(
                    callback: _getCidFromChild,
                    formKey: _formKey,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: PhoneWidget(
                    callback: _getPhoneFromChild,
                    formKey: _formKey,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: AgencyWidget(
                    callback: _getAgencyFromChild,
                    formKey: _formKey,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: RelationshipWidget(
                    callback: _getRelationshipFromChild,
                    formKey: _formKey,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          print("save");
                          _formKey.currentState!.save();
                        }

                        print("address: $address");
                        print("prefix: $prefix");
                        print("name: $name");
                        print("lastname: $lastname");
                        print("cid: $cid");
                        print("phone: $phone");
                        print("agency: $agency");
                        print("relationship: $relationship");
                      },
                      child: Text("สร้าง"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
