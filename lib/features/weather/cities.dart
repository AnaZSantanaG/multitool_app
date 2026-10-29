class City {
  const City(this.name, this.latitude, this.longitude);

  final String name;
  final double latitude;
  final double longitude;
}

const List<City> cities = [
  City('Santo Domingo', 18.4861, -69.9312),
  City('Santiago', 19.4517, -70.6970),
  City('Puerto Plata', 19.7934, -70.6884),
  City('La Romana', 18.4273, -68.9728),
  City('San Pedro de Macorís', 18.4539, -69.3086),
  City('Higüey', 18.6150, -68.7083),
  City('Punta Cana', 18.5820, -68.4055),
  City('Samaná', 19.2058, -69.3363),
  City('Barahona', 18.2085, -71.1008),
  City('San Francisco de Macorís', 19.3009, -70.2528),
];
