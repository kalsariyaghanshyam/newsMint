import 'package:flutter/material.dart';

BorderRadius radius = BorderRadius.zero;

extension SuperRadius on BorderRadius {
  //==============================================================================
  //     **   Radius From All  **
  //==============================================================================

  BorderRadius allF(double value) {
    var radius = Radius.circular(value);
    return copyWith(bottomLeft: radius, bottomRight: radius, topRight: radius, topLeft: radius);
  }

  BorderRadius get none => allF(0);
  BorderRadius get all1 => allF(1);
  BorderRadius get all2 => allF(2);
  BorderRadius get all3 => allF(3);
  BorderRadius get all4 => allF(4);
  BorderRadius get all5 => allF(5);
  BorderRadius get all6 => allF(6);
  BorderRadius get all7 => allF(7);
  BorderRadius get all8 => allF(8);
  BorderRadius get all9 => allF(9);
  BorderRadius get all10 => allF(10);
  BorderRadius get all11 => allF(11);
  BorderRadius get all12 => allF(12);
  BorderRadius get all13 => allF(13);
  BorderRadius get all14 => allF(14);
  BorderRadius get all15 => allF(15);
  BorderRadius get all16 => allF(16);
  BorderRadius get all17 => allF(17);
  BorderRadius get all18 => allF(18);
  BorderRadius get all19 => allF(19);
  BorderRadius get all20 => allF(20);
  BorderRadius get all21 => allF(21);
  BorderRadius get all22 => allF(22);
  BorderRadius get all23 => allF(23);
  BorderRadius get all24 => allF(24);
  BorderRadius get all25 => allF(25);
  BorderRadius get all26 => allF(26);
  BorderRadius get all27 => allF(27);
  BorderRadius get all28 => allF(28);
  BorderRadius get all29 => allF(29);
  BorderRadius get all30 => allF(30);
  BorderRadius get all31 => allF(31);
  BorderRadius get all32 => allF(32);
  BorderRadius get all33 => allF(33);
  BorderRadius get all34 => allF(34);
  BorderRadius get all35 => allF(35);
  BorderRadius get all36 => allF(36);
  BorderRadius get all37 => allF(37);
  BorderRadius get all38 => allF(38);
  BorderRadius get all39 => allF(39);
  BorderRadius get all40 => allF(40);
  BorderRadius get all41 => allF(41);
  BorderRadius get all42 => allF(42);
  BorderRadius get all43 => allF(43);
  BorderRadius get all44 => allF(44);
  BorderRadius get all45 => allF(45);
  BorderRadius get all46 => allF(46);
  BorderRadius get all47 => allF(47);
  BorderRadius get all48 => allF(48);
  BorderRadius get all49 => allF(49);
  BorderRadius get all50 => allF(50);
  BorderRadius get all63 => allF(63);
  BorderRadius get all85 => allF(85);
  BorderRadius get all100 => allF(100);
  BorderRadius get all140 => allF(140);

  //==============================================================================
  //     **   Radius From Left  **
  //==============================================================================

  BorderRadius _lF(double value) {
    var radius = Radius.circular(value);
    return copyWith(bottomLeft: radius, topLeft: radius);
  }

  BorderRadius get l1 => _lF(1);
  BorderRadius get l2 => _lF(2);
  BorderRadius get l3 => _lF(3);
  BorderRadius get l4 => _lF(4);
  BorderRadius get l5 => _lF(5);
  BorderRadius get l6 => _lF(6);
  BorderRadius get l7 => _lF(7);
  BorderRadius get l8 => _lF(8);
  BorderRadius get l9 => _lF(9);
  BorderRadius get l10 => _lF(10);
  BorderRadius get l15 => _lF(15);
  BorderRadius get l20 => _lF(20);
  BorderRadius get l25 => _lF(25);
  BorderRadius get l30 => _lF(30);

  //==============================================================================
  //     **   Radius From Right  **
  //==============================================================================

  BorderRadius _rF(double value) {
    var radius = Radius.circular(value);
    return copyWith(bottomRight: radius, topRight: radius);
  }

  BorderRadius get r1 => _rF(1);
  BorderRadius get r2 => _rF(2);
  BorderRadius get r3 => _rF(3);
  BorderRadius get r4 => _rF(4);
  BorderRadius get r5 => _rF(5);
  BorderRadius get r10 => _rF(10);
  BorderRadius get r15 => _rF(15);
  BorderRadius get r20 => _rF(20);
  BorderRadius get r25 => _rF(25);
  BorderRadius get r30 => _rF(30);

  //==============================================================================
  //     **   Radius From Top  **
  //==============================================================================

  BorderRadius _tF(double value) {
    var radius = Radius.circular(value);
    return copyWith(topLeft: radius, topRight: radius);
  }

  BorderRadius get t1 => _tF(1);
  BorderRadius get t5 => _tF(5);
  BorderRadius get t10 => _tF(10);
  BorderRadius get t15 => _tF(15);
  BorderRadius get t20 => _tF(20);
  BorderRadius get t25 => _tF(25);
  BorderRadius get t30 => _tF(30);

  //==============================================================================
  //     **   Radius From Bottom  **
  //==============================================================================

  BorderRadius _bF(double value) {
    var radius = Radius.circular(value);
    return copyWith(bottomRight: radius, bottomLeft: radius);
  }

  BorderRadius get b1 => _bF(1);
  BorderRadius get b5 => _bF(5);
  BorderRadius get b10 => _bF(10);
  BorderRadius get b15 => _bF(15);
  BorderRadius get b20 => _bF(20);
  BorderRadius get b25 => _bF(25);
  BorderRadius get b30 => _bF(30);
}
