abstract class Graphic {
  void draw();
}

abstract class Shape implements Graphic {
  String _name;

  Shape(String name) {
    this._name = name;
  }

  @override
  void draw() {
    print("Draw ${toString()}");
  }

  @override
  String toString() => "the shape: $_name";
}

class Circle extends Shape {
  double _radius = 0.0;

  Circle(double radius) : super("Circle") {
    this._radius = radius;
  }

  @override
  void draw() {
    super.draw();
    print("Finish drawing, ${toString()}");
  }

  @override
  String toString() => "${super.toString()}, radius: $_radius";
}

void main() {
  print("hellow,world");

  Shape circle = Circle(12.1);
  circle.draw();
  print("Here is $circle");
}