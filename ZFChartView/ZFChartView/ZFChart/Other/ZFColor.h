#define ZFBlack [UIColor blackColor]
#define ZFDarkGray [UIColor darkGrayColor]
#define ZFLightGray [UIColor lightGrayColor]
#define ZFWhite [UIColor whiteColor]
#define ZFGray [UIColor grayColor]
#define ZFRed [UIColor redColor]
#define ZFGreen [UIColor greenColor]
#define ZFBlue [UIColor blueColor]
#define ZFCyan [UIColor cyanColor]
#define ZFYellow [UIColor yellowColor]
#define ZFMagenta [UIColor magentaColor]
#define ZFOrange [UIColor orangeColor]
#define ZFPurple [UIColor purpleColor]
#define ZFBrown [UIColor brownColor]
#define ZFClear [UIColor clearColor]
#define ZFSkyBlue [UIColor colorWithRed:0 green:0.68 blue:1 alpha:1]

#define ZFZhuClolor ZFColor(178, 179, 181, 1) 

/**
 *  直接填写小数
 */
#define ZFDecimalColor(r, g, b, a) [UIColor colorWithRed:r green:g blue:b alpha:a]

/**
 *  直接填写整数
 */
#define ZFColor(r, g, b, a) [UIColor colorWithRed:r / 255.f green:g / 255.f blue:b / 255.f alpha:a]

/**
 *  随机颜色
 */
#define ZFRandomColor ZFColor(arc4random() % 256, arc4random() % 256, arc4random() % 256, 1)