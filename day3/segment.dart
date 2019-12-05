import 'dart:math';

enum Orientation {
  VERTICAL,
  HORITZONTAL,
}

class Segment {
  double x1;
  double y1;
  double x2;
  double y2;

  Segment(this.x1, this.y1, this.x2, this.y2);

  Orientation orientation(){
    if(this.x1 == this.x2){
      return Orientation.VERTICAL;
    }else{
      return Orientation.HORITZONTAL;
    }
  }

   double steps() {
    if (this.orientation() == Orientation.VERTICAL) {
      return (this.y1 - this.y2).abs();
    } else {
      return (this.x1 - this.x2).abs();
    }
  }

  Point intersection(Segment other) {
    if (this.x1 == this.x2 && other.y1 == other.y2) {
      if ((this.x1 >= min(other.x1, other.x2) &&
              this.x1 <= max(other.x1, other.x2)) &&
          (other.y1 >= min(this.y1, this.y2) &&
              other.y1 <= max(this.y1, this.y2))) {
        if (this.x1 != 0 && other.y1 != 0) {
          return Point(this.x1, other.y1);
        }
      }
    } else if (this.y1 == this.y2 && other.x1 == other.x2) {
      if ((other.x1 >= min(this.x1, this.x2) &&
              other.x1 <= max(this.x1, this.x2)) &&
          (this.y1 >= min(other.y1, other.y2) &&
              this.y1 <= max(other.y1, other.y2))) {
        if (other.x1 != 0 && this.y1 != 0) {
          return Point(other.x1, this.y1);
        }
      }
    }
    return null;
  }

  @override
  String toString() {
    return '[(x1: $x1, y1: $y1), (x2: $x2, y2: $y2)]';
  }
}
