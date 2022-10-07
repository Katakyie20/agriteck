class PostObject {
  String? id;
  Map<String, dynamic>? sender;
  String? senderId;
  String? description;
  List<String>? images;
  String? title;
  int? createdAt;

  PostObject({
    this.id,
    this.sender,
    this.senderId,
    this.description,
    this.images,
    this.title,
    this.createdAt,
  });

  PostObject.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sender = json['sender'];
    senderId = json['senderId'];
    description = json['description'];
    images = json['images'].cast<String>();
    title = json['title'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sender'] = sender;
    data['senderId'] = senderId;
    data['description'] = description;
    data['images'] = images;
    data['title'] = title;
    data['createdAt'] = createdAt;
    return data;
  }
}

List<PostObject> dummyPost = [
  PostObject(
      title: "My Crops have this strange rushes",
      description: "My Crops have this strange rushes and it keeps spreading day in and day out. i have tried multiple checmicals but still not working.",
      images: ["https://cropwatch.unl.edu/soybeanMG/images/disease/DiseaseFigure61.jpg",
      "https://cdn.britannica.com/89/126689-004-D622CD2F/Potato-leaf-blight.jpg"
      ],
  ),
  PostObject(
    title: "What could be the Cause of this?",
    description:
        "My Crops have this strange rushes and it keeps spreading day in and day out. i have tried multiple checmicals but still not working.",
    images: [
      "http://www.aoa.aua.gr/wp-content/uploads/2017/05/shutterstock_313388153.jpg",
      "https://cdn.britannica.com/89/126689-004-D622CD2F/Potato-leaf-blight.jpg"
    ],
  ),
   PostObject(
    title: "Crops Leaves are turning yellow",
    description:
        "My Crops have this strange rushes and it keeps spreading day in and day out. i have tried multiple checmicals but still not working.",
    images: [
      "https://earthsally.com/wp-content/uploads/2021/03/powdery-mildew-plant-disease-1024x512.jpg",
      "https://cdn.britannica.com/89/126689-004-D622CD2F/Potato-leaf-blight.jpg"
    ],
  ),
   PostObject(
    title: "My Crops have this strange rushes",
    description:
        "My Crops have this strange rushes and it keeps spreading day in and day out. i have tried multiple checmicals but still not working.",
    images: [
      "https://cropwatch.unl.edu/soybeanMG/images/disease/DiseaseFigure61.jpg",
      "https://cdn.britannica.com/89/126689-004-D622CD2F/Potato-leaf-blight.jpg"
    ],
  ),
  PostObject(
    title: "What could be the Cause of this?",
    description:
        "My Crops have this strange rushes and it keeps spreading day in and day out. i have tried multiple checmicals but still not working.",
    images: [
      "http://www.aoa.aua.gr/wp-content/uploads/2017/05/shutterstock_313388153.jpg",
      "https://cdn.britannica.com/89/126689-004-D622CD2F/Potato-leaf-blight.jpg"
    ],
  ),
  PostObject(
    title: "Crops Leaves are turning yellow",
    description:
        "My Crops have this strange rushes and it keeps spreading day in and day out. i have tried multiple checmicals but still not working.",
    images: [
      "https://earthsally.com/wp-content/uploads/2021/03/powdery-mildew-plant-disease-1024x512.jpg",
      "https://cdn.britannica.com/89/126689-004-D622CD2F/Potato-leaf-blight.jpg"
    ],
  ),
       
];
