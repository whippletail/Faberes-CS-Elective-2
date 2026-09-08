class Product {
  const Product({
    required this.id,
    required this.name,
    required this.tagline,
    required this.price,
    required this.imageAsset,
    required this.darkImageAsset,
    required this.badge,
    required this.rating,
    required this.description,
    required this.length,
    required this.skillLevel,
  });

  final String id;
  final String name;
  final String tagline;
  final int price;

  final String imageAsset;
  final String darkImageAsset;

  final String badge;
  final double rating;
  final String description;
  final String length;
  final String skillLevel;
}

const products = <Product>[
  Product(
    id: 'reef-glider',
    name: 'Reef Glider',
    tagline: 'Fast, light, and made for clean lines',
    price: 4599,
    imageAsset: 'assets/images/sw1.png',
    darkImageAsset: 'assets/images/dsw1.png',
    badge: 'BEST SELLER',
    rating: 4.9,
    description: 'A responsive all-around skimboard with a lightweight profile for quick transitions and clean shoreline lines.',
    length: '41 in',
    skillLevel: 'All levels',
  ),
  Product(
    id: 'sunset-cruiser',
    name: 'Sunset Cruiser',
    tagline: 'Stable shape for effortless beach runs',
    price: 3899,
    imageAsset: 'assets/images/sw2.png',
    darkImageAsset: 'assets/images/dsw2.png',
    badge: 'BEGINNER PICK',
    rating: 4.8,
    description: 'A stable, forgiving board made for building confidence and enjoying smooth beach runs.',
    length: '40 in',
    skillLevel: 'Beginner',
  ),
  Product(
    id: 'tide-carbon',
    name: 'Tide Carbon',
    tagline: 'Performance build for serious riders',
    price: 7499,
    imageAsset: 'assets/images/sw3.png',
    darkImageAsset: 'assets/images/dsw3.png',
    badge: 'PRO SERIES',
    rating: 5.0,
    description: 'A performance-focused carbon build that delivers speed, control, and crisp response in demanding sessions.',
    length: '42 in',
    skillLevel: 'Advanced',
  ),
  Product(
    id: 'island-bloom',
    name: 'Island Bloom',
    tagline: 'Tropical style with a forgiving profile',
    price: 4299,
    imageAsset: 'assets/images/sw4.png',
    darkImageAsset: 'assets/images/dsw4.png',
    badge: 'NEW',
    rating: 4.7,
    description: 'Tropical artwork meets an easy-riding profile designed for relaxed sessions and steady progression.',
    length: '40 in',
    skillLevel: 'Beginner',
  ),
  Product(
    id: 'blue-current',
    name: 'Blue Current',
    tagline: 'Smooth control across shallow water',
    price: 5199,
    imageAsset: 'assets/images/sw5.png',
    darkImageAsset: 'assets/images/dsw5.png',
    badge: 'POPULAR',
    rating: 4.9,
    description: 'Balanced rocker and smooth rails provide confident control through shallow water and changing conditions.',
    length: '41 in',
    skillLevel: 'Intermediate',
  ),
  Product(
    id: 'shore-break',
    name: 'Shore Break',
    tagline: 'Durable everyday board for sandy sessions',
    price: 3499,
    imageAsset: 'assets/images/sw6.png',
    darkImageAsset: 'assets/images/dsw6.png',
    badge: 'VALUE PICK',
    rating: 4.6,
    description: 'A durable everyday board built to handle sandy sessions while staying comfortable and predictable.',
    length: '39 in',
    skillLevel: 'All levels',
  ),

    Product(
    id: 'aqua-flash',
    name: 'Aqua Flash',
    tagline: 'Lightweight board designed for fast flatland tricks',
    price: 4799,
    imageAsset: 'assets/images/sw7.png',
    darkImageAsset: 'assets/images/dsw7.png',
    badge: 'FREESTYLE',
    rating: 4.8,
    description: 'Lightweight construction and a lively outline make flatland tricks feel quick, playful, and controlled.',
    length: '40 in',
    skillLevel: 'Intermediate',
  ),
  Product(
    id: 'wave-master',
    name: 'Wave Master',
    tagline: 'Advanced control for powerful shore-break waves',
    price: 6299,
    imageAsset: 'assets/images/sw8.png',
    darkImageAsset: 'assets/images/dsw8.png',
    badge: 'ADVANCED',
    rating: 4.9,
    description: 'A powerful premium shape with dependable grip and control for larger, faster shore-break waves.',
    length: '43 in',
    skillLevel: 'Advanced',
  ),
];
