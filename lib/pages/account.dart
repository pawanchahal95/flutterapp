import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountInfoPage extends StatefulWidget {
  const AccountInfoPage({Key? key}) : super(key: key);

  @override
  _AccountInfoPageState createState() => _AccountInfoPageState();
}

class _AccountInfoPageState extends State<AccountInfoPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Future<List<AddressItem>> _addressItemsFuture;
  String? _selectedAddressId;

  // Controllers for form fields
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _houseNoController = TextEditingController();
  final _buildingNameController = TextEditingController();
  final _streetController = TextEditingController();
  final _areaController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _deliveryInstructionController = TextEditingController();
  final _customTimeController = TextEditingController();
  String _selectedAddressType = 'Home';

  bool _isFormVisible = false; // Controls the visibility of the form

  @override
  void initState() {
    super.initState();
    _addressItemsFuture = _fetchAddressItems();
  }

  Future<List<AddressItem>> _fetchAddressItems() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return [];

    final addressSnapshot = await _firestore.collection('users').doc(userId).collection('addresses').get();
    return addressSnapshot.docs.map((doc) => AddressItem.fromFirestore(doc)).toList();
  }

  void _selectAddress(String? addressId) {
    setState(() {
      _selectedAddressId = addressId;
    });

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    _firestore.collection('users').doc(userId).update({
      'selected_address': addressId,
    });
  }

  void _editAddress(AddressItem address) {
    _nameController.text = address.name;
    _contactController.text = address.contact;
    _houseNoController.text = address.houseNo;
    _buildingNameController.text = address.buildingName;
    _streetController.text = address.street;
    _areaController.text = address.area;
    _cityController.text = address.city;
    _stateController.text = address.state;
    _pincodeController.text = address.pincode;
    _deliveryInstructionController.text = address.deliveryInstruction;
    _selectedAddressType = address.addressType;
    _customTimeController.text = address.customTime ?? '';

    setState(() {
      _selectedAddressId = address.id;
      _isFormVisible = true; // Show the form when editing an address
    });
  }

  void _addOrUpdateAddress() {
    final name = _nameController.text;
    final contact = _contactController.text;
    final houseNo = _houseNoController.text;
    final buildingName = _buildingNameController.text;
    final street = _streetController.text;
    final area = _areaController.text;
    final city = _cityController.text;
    final state = _stateController.text;
    final pincode = _pincodeController.text;
    final deliveryInstruction = _deliveryInstructionController.text;
    final addressType = _selectedAddressType;
    final customTime = _customTimeController.text;

    if (name.isNotEmpty &&
        contact.isNotEmpty &&
        houseNo.isNotEmpty &&
        buildingName.isNotEmpty &&
        street.isNotEmpty &&
        area.isNotEmpty &&
        city.isNotEmpty &&
        state.isNotEmpty &&
        pincode.isNotEmpty) {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return;

      if (_selectedAddressId == null) {
        _firestore.collection('users').doc(userId).collection('addresses').add({
          'name': name,
          'contact': contact,
          'house_no': houseNo,
          'building_name': buildingName,
          'street': street,
          'area': area,
          'city': city,
          'state': state,
          'pincode': pincode,
          'delivery_instruction': deliveryInstruction,
          'address_type': addressType,
          'custom_time': customTime.isNotEmpty ? customTime : null,
        }).then((_) {
          setState(() {
            _addressItemsFuture = _fetchAddressItems();
            _isFormVisible = false; // Hide the form after adding/updating
          });
        });
      } else {
        _firestore.collection('users').doc(userId).collection('addresses').doc(_selectedAddressId).update({
          'name': name,
          'contact': contact,
          'house_no': houseNo,
          'building_name': buildingName,
          'street': street,
          'area': area,
          'city': city,
          'state': state,
          'pincode': pincode,
          'delivery_instruction': deliveryInstruction,
          'address_type': addressType,
          'custom_time': customTime.isNotEmpty ? customTime : null,
        }).then((_) {
          setState(() {
            _addressItemsFuture = _fetchAddressItems();
            _isFormVisible = false; // Hide the form after updating
          });
        });
      }
    }
  }

  void _cancelForm() {
    // Clear form fields and hide the form
    _nameController.clear();
    _contactController.clear();
    _houseNoController.clear();
    _buildingNameController.clear();
    _streetController.clear();
    _areaController.clear();
    _cityController.clear();
    _stateController.clear();
    _pincodeController.clear();
    _deliveryInstructionController.clear();
    _customTimeController.clear();
    setState(() {
      _isFormVisible = false; // Hide the form when Cancel is clicked
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Info', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Saved Addresses', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red)),
              SizedBox(height: 20),

              // Display saved addresses
              FutureBuilder<List<AddressItem>>(
                future: _addressItemsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error loading addresses'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No addresses found.'));
                  } else {
                    return Column(
                      children: snapshot.data!.map((address) {
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          decoration: BoxDecoration(
                            color: _selectedAddressId == address.id ? Colors.red[50] : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ListTile(
                            title: Text(address.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            subtitle: Text('${address.street}, ${address.city}, ${address.pincode}'),
                            leading: Radio<String>(
                              value: address.id,
                              groupValue: _selectedAddressId,
                              onChanged: (String? value) {
                                _selectAddress(value);
                              },
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.edit, color: Colors.red),
                              onPressed: () => _editAddress(address),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }
                },
              ),
              SizedBox(height: 20),

              // Show the form only if it's visible
              if (_isFormVisible) ...[
                Text('Address Form', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red)),
                SizedBox(height: 10),

                _buildFormField('Name', _nameController),
                SizedBox(height: 10),
                _buildFormField('Contact', _contactController),
                SizedBox(height: 10),
                _buildFormField('House No.', _houseNoController),
                SizedBox(height: 10),
                _buildFormField('Building Name', _buildingNameController),
                SizedBox(height: 10),
                _buildFormField('Street', _streetController),
                SizedBox(height: 10),
                _buildFormField('Area', _areaController),
                SizedBox(height: 10),
                _buildFormField('City', _cityController),
                SizedBox(height: 10),
                _buildFormField('State', _stateController),
                SizedBox(height: 10),
                _buildFormField('Pincode', _pincodeController),
                SizedBox(height: 10),
                _buildFormField('Delivery Instructions', _deliveryInstructionController),
                SizedBox(height: 10),

                // Dropdown for address type
                DropdownButtonFormField<String>(
                  value: _selectedAddressType,
                  items: ['Home', 'Office', 'Other'].map((type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedAddressType = value!;
                    });
                  },
                ),
                SizedBox(height: 10),

                _buildFormField('Custom Time (Optional)', _customTimeController),
                SizedBox(height: 20),

                ElevatedButton(
                  onPressed: _addOrUpdateAddress,
                  child: Text(_selectedAddressId == null ? 'Add Address' : 'Update Address'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 10),

                // Cancel Button
                TextButton(
                  onPressed: _cancelForm,
                  child: Text('Cancel', style: TextStyle(color: Colors.red)),
                ),
              ],
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _isFormVisible = true; // Show form when Add button is pressed
            _selectedAddressId = null; // Reset address selection
            // Clear form fields
            _nameController.clear();
            _contactController.clear();
            _houseNoController.clear();
            _buildingNameController.clear();
            _streetController.clear();
            _areaController.clear();
            _cityController.clear();
            _stateController.clear();
            _pincodeController.clear();
            _deliveryInstructionController.clear();
            _customTimeController.clear();
            _selectedAddressType = 'Home';
          });
        },
        child: Icon(Icons.add, size: 30),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget _buildFormField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      ),
    );
  }
}

class AddressItem {
  final String id;
  final String name;
  final String contact;
  final String houseNo;
  final String buildingName;
  final String street;
  final String area;
  final String city;
  final String state;
  final String pincode;
  final String deliveryInstruction;
  final String addressType;
  final String? customTime;

  AddressItem({
    required this.id,
    required this.name,
    required this.contact,
    required this.houseNo,
    required this.buildingName,
    required this.street,
    required this.area,
    required this.city,
    required this.state,
    required this.pincode,
    required this.deliveryInstruction,
    required this.addressType,
    this.customTime,
  });

  factory AddressItem.fromFirestore(DocumentSnapshot doc) {
    return AddressItem(
      id: doc.id,
      name: doc['name'],
      contact: doc['contact'],
      houseNo: doc['house_no'],
      buildingName: doc['building_name'],
      street: doc['street'],
      area: doc['area'],
      city: doc['city'],
      state: doc['state'],
      pincode: doc['pincode'],
      deliveryInstruction: doc['delivery_instruction'],
      addressType: doc['address_type'],
      customTime: doc['custom_time'],
    );
  }
}
