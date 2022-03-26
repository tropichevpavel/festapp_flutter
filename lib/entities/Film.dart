
class Film {
	int id;
	String name, img, desc;

	Film(this.id, this.name, this.img, this.desc);

	Film.fromJSON (Map<String, dynamic> json) :
			id = json['id'],
			name = json['name'],
			img = json['img'],
			desc = json['desc'];

	// @override
	// String toJSON() => '{"name":"$name", "phone":$phone, "adress":"$adress"}';
	//
	// @override
	// toMapDB() => {'agentName': name, 'agentPhone': phone, 'agentAdress': adress};

	@override
	String toString() => '{"id":$id, "name":"$name"}';
}