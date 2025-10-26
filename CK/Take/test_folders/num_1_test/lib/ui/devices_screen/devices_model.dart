class Device {
  final String name;
  final String pathImageName;
  bool isOn;
  final double voltage;
  final double current;
  final double power;

  Device({
    required this.name,
    required this.pathImageName,
    required this.isOn,
    required this.voltage,
    required this.current,
    required this.power,
  });
}
