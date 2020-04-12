#ifndef COLORWHEEL_H
#define COLORWHEEL_H

#include <vector>
#include <array>

typedef std::array<float,3> color_t;
namespace color
{
   static const color_t black  = {0.0, 0.0, 0.0};
   static const color_t white  = {1.0, 1.0, 1.0};
   static const color_t red    = {1.0, 0.0, 0.0};
   static const color_t green2 = {0.0, 1.0, 0.0};
   static const color_t blue   = {0.0, 0.0, 1.0};
   static const color_t rose   = {0.8, 0.4, 0.46666666667};
   static const color_t indigo = {0.2, 0.13333333333, 0.53333333333};
   static const color_t sand   = {0.86666666667, 0.8, 0.46666666667};
   static const color_t green  = {0.06666666667, 0.46666666667, 0.2};
   static const color_t cyan   = {0.53333333333, 0.8, 0.93333333333};
   static const color_t wine   = {0.53333333333, 0.13333333333, 0.33333333333};
   static const color_t teal   = {0.26666666667, 0.66666666667, 0.6};
   static const color_t olive  = {0.6, 0.6, 0.2};
   static const color_t purple = {0.66666666667, 0.26666666667, 0.6};
   static const color_t grey   = {0.86666666667, 0.86666666667, 0.86666666667};
}


class ColorWheel
{
public:
   ColorWheel();
   color_t getColor(const int index = -1)
   {
      if ( index < 0 ) m_colors.at(++m_nextColor);
      return m_colors.at(index);
   };
   void setDivergingPalette();
   void setSequentialPalette();
private:
   std::vector<color_t> m_colors;
   int m_nextColor;
};

#endif
