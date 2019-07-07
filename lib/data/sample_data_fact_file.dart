// This file contains basic forms of the classes that will exist in the
// application.

// You can use them to build your views.

// Your widget for displaying all of the entries will be passed a list of
// categories, [categories], which it will use to generate the tabs (i.e. if
// there are only two categories, only two tabs will be built). If there are
// too many tabs to display on the tab bar, the user should be able to slide the
// tab bar horizontally to reveal the extra tabs.

// Number of categories => `categories.length`

// Each tab view will be passed the list of entries belonging to the category,
// accessed with `categories[i].entries`, where `i` is the index of the tab that
// you are on.

// Your tile widget will be passed a single entry object so that it can display
// the image and the name. Make sure the name/title is coming from the entry object,
// and not the images file name.

// Your widget for displaying the details for an entry will be passed a single
// entry object, from which you will be able to determine the title, content
// text, path to image, path to pronunciation file (if any), and path to bird
// call file (if any).

/// Represents the different categories that fact file entries may belong to.
class FactFileCategory {
  FactFileCategory(this.id, this.name, this.entries);

  final int id;

  final String name;

  final List<FactFileEntry> entries;

  @override
  String toString() => 'FactFileCategory($id : $name)';
}

/// Represents the data for a single entry in the fact file.
class FactFileEntry {
  FactFileEntry(
      {this.id,
      this.categoryId,
      this.title,
      this.content,
      this.description,
      this.mainImage,
      this.secondaryImage,
      this.tertiaryImage,
      this.pronunciationAudio,
      this.birdCallAudio});

  final int id;

  /// References a [FactFileCategory] in the database.
  final int categoryId;

  final String title;

  final String content;

  final String description;

  /// Path to the main display image.
  final MediaFile mainImage;

  ///Path to the secondary image.
  final MediaFile secondaryImage;

  final MediaFile tertiaryImage;

  /// Path to the audio file containing the pronunciation. Null if n/a.
  final MediaFile pronunciationAudio;

  /// Path to the audio file containing the bird call. Null if n/a.
  final MediaFile birdCallAudio;
}

/// Defines the file types supported by the application.
enum MediaFileType {
  png,
  jpg,
  mp3,
}

class MediaFile {
  MediaFile(this.id, this.type, this.description, this.path);

  final int id;

  /// Identifies what type of file this is.
  final MediaFileType type;

  /// Description of the files contents.
  final String description;

  /// The path to the file, relative to the applications root storage directory.
  final String path;
}

/// Generate the sample data which you will pass to your views. In the production
/// application, these lists will be fetched from the SQLite database.abstract

/// This is used by your widget that displays all entries
List<FactFileCategory> categories = [
  FactFileCategory(1, 'Fauna', faunaEntries),
  FactFileCategory(2, 'Flora', floraEntries),
  FactFileCategory(3, 'Other', otherEntries),
];

/// These lists are passed to your tab views. The entry objects within are
/// passed to your 'tile' and 'details' widgets. Not sure exactly what you
/// called them.

List<FactFileEntry> faunaEntries = [
  FactFileEntry(
    id: 1,
    categoryId: 1,
    title: 'Pekin Duck',
    description:
        "The Pekin or White Pekin is an American breed of domestic duck",
    content:
        'Pekin ducks are a large-breed, white dabbling duck that was domesticated over 2000 years ago.'
        ' Although the location is often disputed, all agree it was probably somewhere in Southeast Asia.'
        'By using selective breeding habits, these birds were bred to produce bigger eggs, more meat, and '
        'to have a visual appearance that appeases the eye. Since then, Pekins have become one of the most'
        ' common production ducks in the world today!'
        'In general, a Pekin is a big, white duck with an orange beak that is a hearty, friendly bird. '
        'These calm-natured ducks are a little bit skittish but make excellent pets due to their unique '
        'personalities and overall durability. ',
    mainImage: MediaFile(1, MediaFileType.jpg, "Pekin Duck",
        "assets/images/primary/pekinDuck.jpg"),
    secondaryImage: MediaFile(2, MediaFileType.png, "Pekin Duck",
        "assets/images/secondary/pekinDuck.png"),
    tertiaryImage: MediaFile(3, MediaFileType.png, "Pekin Duck",
        "assets/images/primary/pekinDuck.png"),
    pronunciationAudio: null,
    birdCallAudio: null,
  ),
  FactFileEntry(
    id: 2,
    categoryId: 1,
    title: 'Kea',
    content:
        'The kea is a species of large parrot in the family Nestoridae found in '
        'the forested and alpine regions of the South Island of New Zealand. '
        'About 48 cm long, it is mostly olive-green with a brilliant orange '
        'under its wings and has a large, narrow, curved, grey-brown upper '
        'beak.',
    description: "The Kea is a cheeky bird, becareful not to let it bite you!",
    // Put the pubspec asset path in these for now.
    mainImage: MediaFile(
        1, MediaFileType.jpg, "KeaImage", "assets/images/primary/kea.jpg"),
    secondaryImage: MediaFile(
        2, MediaFileType.jpg, "KeaImage", "assets/images/secondary/kea.jpg"),
    tertiaryImage: MediaFile(
        3, MediaFileType.jpg, "KeaImage", "assets/images/tertiary/kea.jpg"),
    pronunciationAudio: MediaFile(1, MediaFileType.mp3, "KeaPronunce",
        "assets/audio/pronunciations/kea.mp3"),
    birdCallAudio: MediaFile(
        1, MediaFileType.mp3, "KeaCall", "assets/audio/calls/kea.mp3"),
  ),
  FactFileEntry(
    id: 4,
    categoryId: 1,
    title: 'Tomtit',
    description:
        "The there are 5 subspecies of Tomtit North & South Islands as well as the Auckland, Chathams and Snares Islands",
    content: 'The tomtit is a small passerine bird in'
        ' the family Petroicidae, the Australian robins. It is endemic to the '
        'islands of New Zealand, ranging across the main islands as well as '
        'several of the outlying islands. It has several other English names '
        'as well.',
    mainImage: MediaFile(
        1, MediaFileType.jpg, "Tomtit", "assets/images/primary/tomtit.jpg"),
    secondaryImage: MediaFile(
        2, MediaFileType.jpg, "Tomtit", "assets/images/secondary/tomtit.jpg"),
    tertiaryImage: MediaFile(
        3, MediaFileType.jpg, "Tomtit", "assets/images/tertiary/tomtit.jpg"),
    pronunciationAudio: null,
    birdCallAudio: null,
  ),
  FactFileEntry(
    id: 3,
    categoryId: 1,
    title: 'Rifleman',
    description:
        "The tiny rifleman is one of two surviving species of the New Zealand wren family (the other is rock wren).",
    content:
        'The rifleman is a small insectivorous passerine bird that is endemic to '
        'New Zealand. It belongs to the family Acanthisittidae, also known as '
        'the New Zealand wrens, of which it is one of only two surviving '
        'species.',
    mainImage: MediaFile(
        1, MediaFileType.jpg, "Rifleman", "assets/images/primary/rifleman.jpg"),
    secondaryImage: MediaFile(2, MediaFileType.jpg, "Rifleman",
        "assets/images/secondary/rifleman.jpg"),
    tertiaryImage: MediaFile(
        3, MediaFileType.jpg, "Rifleman", "assets/images/primary/rifleman.jpg"),
    pronunciationAudio: null,
    birdCallAudio: null,
  ),
];

List<FactFileEntry> floraEntries = [
  FactFileEntry(
    id: 4,
    categoryId: 2,
    title: 'Rimu',
    description:
        'Rimu is a slow-growing tree, eventually attaining a height of up to 50 m,'
        ' although most surviving large trees are 20 to 35 m tall. It typically'
        ' appears as an emergent from mixed broadleaf temperate rainforest, although'
        ' there are almost pure stands ',
    content: 'Dacrydium cupressinum, commonly known as '
        'rimu, is a large evergreen coniferous tree endemic to the forests of New'
        ' Zealand. It is a member of the southern conifer group, the podocarps. '
        'The former name \"red pine\" has fallen out of common use.',
    mainImage: MediaFile(
        1, MediaFileType.jpg, "Rimu", "assets/images/primary/rimu.jpg"),
    secondaryImage: MediaFile(
        2, MediaFileType.jpg, "Rimu", "assets/images/secondary/rimu.jpg"),
    tertiaryImage: MediaFile(
        3, MediaFileType.jpg, "Rimu", "assets/images/tertiary/rimu.jpg"),
    pronunciationAudio: null,
    birdCallAudio: null,
  ),
  FactFileEntry(
    id: 5,
    categoryId: 2,
    title: 'Mountain Beech',
    description:
        'Very common forest canopy tree in drier upland areas bearing small '
        'leathery leaves arranged along the twig and that are pale underneath and with '
        'incurved margins. Leaves 10-15mm long, appearing pointed. Flowers and fruits '
        'inconspicuous, but these and new leaf growth can change a trees colour.',
    content: 'Nothofagus solandri var.'
        ' cliffortioides, commonly called mountain beech, is a species of'
        ' Southern beech tree and is endemic to New Zealand. Mountain beech '
        'grows in mountainous regions at high altitudes. In New Zealand the'
        ' taxon is called Fuscospora cliffortioides.',
    mainImage: MediaFile(1, MediaFileType.jpg, "Mountain Beech",
        "assets/images/primary/mountainBeech.jpg"),
    secondaryImage: MediaFile(2, MediaFileType.jpg, "Mountain Beech",
        "assets/images/secondary/mountainBeech.jpg"),
    tertiaryImage: MediaFile(3, MediaFileType.jpg, "Mountain Beech",
        "assets/images/tertiary/mountainBeech.jpg"),
    pronunciationAudio: null,
    birdCallAudio: null,
  ),
];

List<FactFileEntry> otherEntries = [
  FactFileEntry(
    id: 6,
    categoryId: 3,
    title: 'Manapōuri Power Station',
    description:
        'A visit to the Manapouri Underground Power Station begins with a cruise across'
        ' beautiful Lake Manapouri. You will then travel by coach down a 2km (1.2 miles) spiral tunnel'
        ' to view the immense underground machine hall and learn the story behind this power station.',
    content: 'Manapōuri Power Station '
        'is an underground hydroelectric power station on the western arm of Lake'
        ' Manapouri in Fiordland National Park, in the South Island of New Zealand.'
        ' At 850 MW installed capacity, it is the largest hydroelectric power'
        ' station in New Zealand, and the second largest power station in New '
        'Zealand.',
    mainImage: MediaFile(1, MediaFileType.jpg, "Power Station",
        "assets/images/primary/powerStation.jpg"),
    secondaryImage: MediaFile(2, MediaFileType.jpg, "Power Station",
        "assets/images/secondary/powerStation.jpg"),
    tertiaryImage: MediaFile(3, MediaFileType.jpg, "Power Station",
        "assets/images/tertiary/powerStation.jpg"),
    pronunciationAudio: null,
    birdCallAudio: null,
  ),
];
