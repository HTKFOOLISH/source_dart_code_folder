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

  // toJson() giúp chuyển đối tượng Device → Map (để lưu vào SharedPreferences dạng JSON)
  Map<String, dynamic> toJson() => {
    'name': name,
    'pathImageName': pathImageName,
    'isOn': isOn,
    'voltage': voltage,
    'current': current,
    'power': power,
  };

  // fromJson() giúp chuyển Map → Device (khi đọc lại từ bộ nhớ)
  factory Device.fromJson(Map<String, dynamic> json) => Device(
    name: json['name'],
    pathImageName: json['pathImageName'],
    isOn: json['isOn'],
    voltage: (json['voltage'] as num).toDouble(),
    current: (json['current'] as num).toDouble(),
    power: (json['power'] as num).toDouble(),
  );
}
