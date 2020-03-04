import 'dart:math';
import 'dart:ui';

import 'package:flare_flutter/flare.dart';
import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

import 'dart:developer' as developer;

// controller that interpolates the main anim from an asset
// depending on the tab
class mainFabAnimController extends FlareController {


  TabController tabCtrl;


  double animVal = 0;
  double oldVal = 0;

  mainFabAnimController({
    this.tabCtrl,
  }):super();

  FlutterActorArtboard _artboard;
  ActorAnimation _mainAnim;

  @override
  void initialize(FlutterActorArtboard artboard) {
    _mainAnim = artboard.getAnimation("main");
    _artboard = artboard;
    isActive.value = true;

    try {
      if (tabCtrl.index == 1) {
        forceSetAnimVal(1);
      } else {
        forceSetAnimVal(0);
      }
    } catch (e) {
      developer.log("mainFabAnimController: tabCtrl uninitialized; doing nothing");
    }

  }


  @override
  bool advance(FlutterActorArtboard artboard, double elapsed) {

    if (oldVal == animVal) {
      isActive.value = false;
      return true;
    } else {
      isActive.value = true;
      oldVal = animVal;

      _mainAnim.apply(animVal*_mainAnim.duration, artboard, 20);

      FlareAnimationLayer layer = FlareAnimationLayer();
      layer.name = "main";
      layer.animation = _mainAnim;
      layer.time = elapsed;
      layer.mix = 1;
      layer.apply(_artboard);

      return false;
    }
  }

  void setAnimVal(double value) { // set animation position but take into account past values and
    animVal = value;              // don't do anything if the value is the same as the last
    this.advance(_artboard, animVal*_mainAnim.duration);
  }

  void forceSetAnimVal(double value) { // set animation position regardless of past values
    oldVal = -1;
    animVal = value;
    this.advance(_artboard, animVal*_mainAnim.duration);
  }

  @override
  void setViewTransform(Mat2D viewTransform) {
  }
}