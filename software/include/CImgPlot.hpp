#ifndef CIMGPLOT_HPP
#define CIMGPLOT_HPP

#include <vector>
#include <string>
#include <iostream>
#include <iomanip>
#include <sstream>
#include <math.h>
#include <exception>

#include <CImg.h>

#include <ColorWheel.hpp>

using namespace cimg_library;

class CImgPlot : public CImg<float>
{
private:
   float m_xlow;
   float m_xhigh;
   float m_ylow;
   float m_yhigh;
   bool m_grid;
   bool m_axes;
   float m_leftBorderFrac;
   float m_rightBorderFrac;
   float m_topBorderFrac;
   float m_bottomBorderFrac;
   std::string m_xTitle;
   std::string m_yTitle;
   bool m_update;
   float m_backgroundColor;
   color_t m_foregroundColor;
   color_t m_gridColor;
   float m_xRange;
   float m_xRangeFollow;

   // derived member variables
   unsigned int m_leftBorderSize;
   unsigned int m_rightBorderSize;
   unsigned int m_topBorderSize;
   unsigned int m_bottomBorderSize;
   unsigned int m_xBorderSize;
   unsigned int m_yBorderSize;
   unsigned int m_xDataWindowSize;
   unsigned int m_yDataWindowSize;
   std::vector<float> m_xTicks;
   std::vector<float> m_yTicks;
   std::vector<float> m_xMinorTicks;
   std::vector<float> m_yMinorTicks;
   ColorWheel m_colorWheel;

   // data
   struct line_t {
      std::vector<float> x;
      std::vector<float> y;
      color_t color{0.0,0.0,0.0};
      std::string style = "lp";
      float xMin;
      float xMax;
      float yMin;
      float yMax;
   };
   std::vector<line_t> m_lines;

   // private functions
   unsigned int xToPixel(float x);
   unsigned int yToPixel(float y);
   void handleLine(line_t &line);

public:
   CImgPlot(unsigned int pixWidthX, unsigned int pixWidthY);
   ~CImgPlot(){};

   // background is a value from 0.0 (black) to 1.0 (white)
   void setBackgroundColor(float c){ m_backgroundColor = c; };
   void setForegroundColor(color_t c)
   {
      m_foregroundColor[0] = c[0];
      m_foregroundColor[1] = c[1];
      m_foregroundColor[2] = c[2];
   };

   void setTicks(std::vector<float> &xTicks, std::vector<float> &yTicks)
   {
      m_xTicks = xTicks;
      m_yTicks = yTicks;
   };
   void setMinorTicks(std::vector<float> &xMinorTicks,
		      std::vector<float> &yMinorTicks)
   {
      m_xMinorTicks = xMinorTicks;
      m_yMinorTicks = yMinorTicks;
   };
   void createTicks(unsigned int nMajor = 5, unsigned int nMinor = 4);
   void setTitle(std::string xTitle, std::string yTitle = "")
   {
      m_xTitle = xTitle;
      m_yTitle = yTitle;
   };
   void setXRange(const float min, const float max, bool follow = false);

   void line(const int index, std::vector<float> x, std::vector<float> y,
	     color_t color, std::string style);
   void line(const int index, std::vector<float> x, std::vector<float> y,
	     std::string style);
   void line(std::vector<float> x, std::vector<float> y,
	     std::string style = "lp");
   void line(std::vector<float> x, std::vector<float> y, color_t color,
	     std::string style = "lp");
   void draw();

};

#endif
