import 'models/notice.dart';

List<Notice> urgentNotices = [
  Notice.make(
    id: 1,
    urgent: true,
    imageId: 1,
    updatedAt: DateTime(2019, 12, 09),
    title: "This is an urgent test notice!",
    shortDesc:
    "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
    longDesc:
    "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type"
        " and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic"
        "typesetting, remaining essentially unchanged.",
  ),
  Notice.make(
    id: 2,
    urgent: true,
    imageId: 2,
    updatedAt: DateTime(2019, 07, 26),
    title: "This is an duplicate urgent test notice that needs to be really long",
    shortDesc:
    "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
    longDesc:
    "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type"
        " and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic"
        "typesetting, remaining essentially unchanged.",
  ),
];

List<Notice> otherNotices = [
  Notice.make(
    id: 1,
    urgent: false,
    imageId: null,
    updatedAt: DateTime(2020, 02, 29),
    title: "This is not an urgent test notice",
    shortDesc:
    "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
    longDesc: null,
  ),
];