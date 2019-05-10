import 'dart:math';

class CartPoint {
  double _x;
  double _y;
  CartPoint(this._x, this._y);
  @override
  toString() {
    return ("x: " + this._x.toString() + "\ty: " + this._y.toString());
  }

  double get x => this._x;
  double get y => this._y;

  List toList() {
    List output = new List(2);
    output[0] = this._x;
    output[1] = this._y;
    return output;
  }

  CartPoint.fromPoint(Point p) {
    this._x = p.x;
    this._y = p.y;
  }
  Point toPoint() {
    return new Point(this._x, this._y);
  }
}
