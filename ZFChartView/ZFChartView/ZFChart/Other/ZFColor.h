/**
 *  直接填写小数
 */
#define ZFDecimalColor(r, g, b, a)    [UIColor colorWithRed:r green:g blue:b alpha:a]

/**
 *  直接填写整数
 */
#define ZFColor(r, g, b, a)    [UIColor colorWithRed:r / 255.f green:g / 255.f blue:b / 255.f alpha:a]

/**
 *  随机颜色
 */
#define ZFRandom    ZFColor(arc4random() % 256, arc4random() % 256, arc4random() % 256, 1)

#define ZFBlack         [UIColor blackColor]
#define ZFDarkGray      [UIColor darkGrayColor]
#define ZFLightGray     [UIColor lightGrayColor]
#define ZFWhite         [UIColor whiteColor]
#define ZFGray          [UIColor grayColor]
#define ZFRed           [UIColor redColor]
#define ZFGreen         [UIColor greenColor]
#define ZFBlue          [UIColor blueColor]
#define ZFCyan          [UIColor cyanColor]
#define ZFYellow        [UIColor yellowColor]
#define ZFMagenta       [UIColor magentaColor]
#define ZFOrange        [UIColor orangeColor]
#define ZFPurple        [UIColor purpleColor]
#define ZFBrown         [UIColor brownColor]
#define ZFClear         [UIColor clearColor]
#define ZFSkyBlue       ZFDecimalColor(0, 0.68, 1, 1)
#define ZFLightBlue     ZFColor(125, 231, 255, 1)
#define ZFSystemBlue    ZFColor(10, 96, 254, 1)
#define ZFFicelle       ZFColor(247, 247, 247, 1)
#define ZFTaupe         ZFColor(238, 239, 241, 1)
#define ZFTaupe2        ZFColor(237, 236, 236, 1)
#define ZFTaupe3        ZFColor(236, 236, 236, 1)
#define ZFGrassGreen    ZFColor(254, 200, 122, 1)
#define ZFGold          ZFColor(255, 215, 0, 1)
#define ZFDeepPink      ZFColor(238, 18, 137, 1)
