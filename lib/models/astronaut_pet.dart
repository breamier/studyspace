import 'package:isar/isar.dart';

part 'astronaut_pet.g.dart';

@Collection()
class AstronautPet {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  String name = 'Sigma';
  bool isAlive = true;
  double hp = 100.0;
  double progress = 0.0;
  // dito mababawas ang pet skin and spaceship
  int progressPoints = 0;
  int planetsCount = 0;
  String skinType = 'default';
  String shipType = 'default';

  bool isTraveling = false;

  int userPoints = 0;

  AstronautPet();

  AstronautPet.create({
    required this.name,
    this.skinType = 'default',
    this.shipType = 'default',
  })  : isAlive = true,
        hp = 100.0,
        progress = 0.0,
        progressPoints = 0,
        planetsCount = 0,
        userPoints = 0;
}
