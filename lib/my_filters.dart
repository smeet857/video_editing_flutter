
const List<double> FILTER_NORMAL = [
  1,0,0,0,0,
  0,1,0,0,0,
  0,0,1,0,0,
  0,0,0,1,0
];
const List<double> FILTER_BLACK_AND_WHITE = [
  0, 1, 0, 0, 0,
  0, 1, 0, 0, 0,
  0, 1, 0, 0, 0,
  0, 1, 0, 1, 0
];
const List<double> FILTER_SEPIA = [
  1, 0,   0, 0, 0,
  0, 1,   0, 0, 0,
  0, 0, 0.8, 0, 0,
  0, 0,   0, 1, 0
];
const List<double> FILTER_INVERT = [
  -1,  0,  0,  0, 255,
  0, -1,  0,  0, 255,
  0,  0, -1,  0, 255,
  0,  0,  0,  1,   0
];
const List<double> FILTER_ALPHA_BLUE = [
  0,    0,    0, 0,   0,
  0.3,    0,    0, 0,  50,
  0,    0,    0, 0, 255,
  0.2, 0.4, 0.4, 0, -30
];
const List<double> FILTER_ALPHA_PINK = [
  0,    0,    0, 0, 255,
  0,    0,    0, 0,   0,
  0.2,    0,    0, 0,  50,
  0.2, 0.2, 0.2, 0, -20
];
const List<double> FILTER_BINARY = [
  255, 0, 0, 1, -32460,
  0, 255, 0, 1, -32460,
  0, 0, 255, 1, -32460,
  0, 0, 0, 1, 0
];
const List<double> FILTER_GREY_RED_BRIGHT = [
  1, 0, 0, 0, 0,
  1, 0, 0, 0, 0,
  1, 0, 0, 0, 0,
  0, 0, 0, 1, 0
];
const List<double> FILTER_GREY_GREEN_BRIGHT = [
  0, 1, 0, 0, 0,
  0, 1, 0, 0, 0,
  0, 1, 0, 0, 0,
  0, 0, 0, 1, 0
];
const List<double> FILTER_GREY_BLUE_BRIGHT = [
  0, 0, 1, 0, 0,
  0, 0, 1, 0, 0,
  0, 0, 1, 0, 0,
  0, 0, 0, 1, 0
];
const List<double> FILTER_SWAP_RED_TO_GREEN = [
  0, 0, 1, 0, 0,
  1, 0, 0, 0, 0,
  0, 1, 0, 0, 0,
  0, 0, 0, 1, 0
];
const List<double> FILTER_SWAP_RED_TO_BLUE = [
  0, 1, 0, 0, 0,
  0, 0, 1, 0, 0,
  1, 0, 0, 0, 0,
  0, 0, 0, 1, 0
];
const List<double> FILTER_MILK = [
  0, 1.0, 0, 0 ,0,
  0, 1.0 ,0, 0, 0,
  0, 0.6 ,1, 0, 0,
  0, 0 ,0 ,1, 0,
];
const List<double> FILTER_SEPIAM = [
  1.3 ,-0.3, 1.1, 0 ,0,
  0 ,1.3, 0.2,0, 0,
  0, 0, 0.8, 0.2, 0,
  0, 0 ,0, 1, 0,
];
const List<double> FILTER_COLD_LIFE = [
  1 ,0 ,0, 0, 0,
  0, 1 ,0, 0, 0,
  -0.2, 0.2 ,0.1 ,0.6, 0,
  0, 0, 0, 1, 0
];
const List<double> FILTER_OLDTIMES = [
  1, 0 ,0, 0 ,0,
      -0.4 ,1.3 ,-0.4, 0.2, -0.1,
  0, 0 ,1, 0, 0,
  0, 0 ,0, 1, 0
];
const List<double> FILTER_PURPLE = [
  1, -0.2, 0, 0 ,0,
  0, 1 ,0 ,-0.1, 0,
  0, 1.2 ,1, 0.1 ,0,
  0, 0 ,1.7, 1, 0
];
const List<double> FILTER_YELLOW = [
  1, 0, 0, 0, 0,
      -0.2, 1.0, 0.3, 0.1, 0,
      -0.1, 0, 1, 0, 0,
  0, 0, 0, 1, 0
];
const List<double> FILTER_CYAN = [
  1 ,0, 0 ,1.9 ,-2.2,
  0 ,1, 0 ,0.0 ,0.3,
  0 ,0 ,1 ,0, 0.5,
  0, 0 ,0 ,1, 0.2
];
const List<double> FILTER_1 = [
  1.3, 0, -0.7, 0.1, 0,
  0, 1, -0.1, 0, 0,
  0.4, 0.4, 0.1, 0, 0,
  -1.1, 0.3, 0.6, 1.3, 0
];
const List<double> FILTER_2 = [
  1.3,0.8,-3,0,0,
  0,0.7,-0.8,0,0,
  0,0.3,-1.3,-0.3,0,
  0,0,0,1,0
];