#include "CImgPlot.hpp"

CImgPlot::CImgPlot(unsigned int pixWidthX, unsigned int pixWidthY) :
   m_xlow(-1.0f),
   m_xhigh(1.0f),
   m_ylow(-1.0f),
   m_yhigh(1.0f),
   m_grid(false),
   m_axes(true),
   m_leftBorderFrac(0.1f),
   m_rightBorderFrac(0.05f),
   m_topBorderFrac(0.05f),
   m_bottomBorderFrac(0.1f),
   m_xTitle(""),
   m_yTitle(""),
   m_update(true),
   m_backgroundColor(1.0f),
   m_foregroundColor{0.0f, 0.0f, 0.0f},
   m_gridColor{0.8f, 0.8f, 0.8f},
   m_xRange{2.0},
   m_xRangeFollow{false}
{
   
   this->assign(pixWidthX, pixWidthY, 1, 3, 0);

   float width = static_cast<float>(this->width());
   m_leftBorderSize = static_cast<unsigned int>(m_leftBorderFrac*width);
   m_rightBorderSize = static_cast<unsigned int>(m_rightBorderFrac*width);
   m_xBorderSize = m_leftBorderSize + m_rightBorderSize;
   m_xDataWindowSize = width - m_xBorderSize;
   
   float height = static_cast<float>(this->height());
   m_topBorderSize = static_cast<unsigned int>(m_topBorderFrac*height);
   m_bottomBorderSize = static_cast<unsigned int>(m_bottomBorderFrac*height);
   m_yBorderSize = m_topBorderSize + m_bottomBorderSize;
   m_yDataWindowSize = height - m_yBorderSize;
   
   m_colorWheel.setDivergingPalette();
}

unsigned int CImgPlot::yToPixel(float y)
{
   return m_topBorderSize + static_cast<unsigned int>
      ( (m_yhigh - y)*(float)m_yDataWindowSize / (m_yhigh - m_ylow) );
}

unsigned int CImgPlot::xToPixel(float x)
{
   return m_leftBorderSize + static_cast<unsigned int>
      ( (x - m_xlow)*(float)m_xDataWindowSize / (m_xhigh - m_xlow) );
}

void CImgPlot::createTicks(unsigned int nMajor, unsigned int nMinor)
{
   // create x ticks
   float dataRange = m_xhigh - m_xlow;
   float majorDelta = dataRange/static_cast<float>(nMajor);
   float scale = 1.0;
   while ( majorDelta*scale < 1.0 ) scale *= 10.0;
   float majorTickWidth = std::floor(majorDelta*scale)/scale;
   float tick = majorTickWidth * std::floor(m_xhigh/majorTickWidth);
   m_xTicks.clear();
   while ( tick > m_xlow ) {
      if ( tick < m_xhigh ) m_xTicks.push_back(tick);
      tick -= majorTickWidth;
   }
   float minorTickWidth = majorTickWidth/static_cast<float>(nMinor);
   tick = minorTickWidth * std::floor(m_xhigh/minorTickWidth);
   m_xMinorTicks.clear();
   for ( unsigned int i = 0; i < m_xTicks.size(); ++i ) {
      for ( unsigned int n = 0; n < nMinor - 1; ++n ) {
	 tick = m_xTicks[i] + minorTickWidth * (1.0 + n);
	 if ( tick < m_xhigh ) m_xMinorTicks.push_back(tick);
      }
   }
   tick = m_xTicks.back() - minorTickWidth;
   while ( tick > m_xlow ) {
      m_xMinorTicks.push_back(tick);
      tick -= minorTickWidth;
   }

   // create y ticks
   dataRange = m_yhigh - m_ylow;
   majorDelta = dataRange/static_cast<float>(nMajor);
   scale = 1.0;
   while ( majorDelta*scale < 1.0 ) scale *= 10.0;
   majorTickWidth = std::floor(majorDelta*scale)/scale;
   tick = majorTickWidth * std::floor(m_yhigh/majorTickWidth);
   m_yTicks.clear();
   while ( tick > m_ylow ) {
      if ( tick < m_yhigh ) m_yTicks.push_back(tick);
      tick -= majorTickWidth;
   }
   minorTickWidth = majorTickWidth/static_cast<float>(nMinor);
   tick = minorTickWidth * std::floor(m_yhigh/minorTickWidth);
   m_yMinorTicks.clear();
   for ( unsigned int i = 0; i < m_yTicks.size(); ++i ) {
      for ( unsigned int n = 0; n < nMinor - 1; ++n ) {
	 tick = m_yTicks[i] + minorTickWidth * (1.0 + n);
	 if ( tick < m_yhigh ) m_yMinorTicks.push_back(tick);
      }
   }
   tick = m_yTicks.back() - minorTickWidth;
   while ( tick > m_ylow ) {
      m_yMinorTicks.push_back(tick);
      tick -= minorTickWidth;
   }
}

void CImgPlot::setXRange(const float min, const float max, bool follow)
{
   m_xlow = min;
   m_xhigh = max;
   m_xRange = std::abs(max - min);
   m_xRangeFollow = true;
   
   return;
}


void CImgPlot::handleLine(line_t &line)
{
   // compute line max and min
   line.xMin = *std::min_element(line.x.begin(), line.x.end());
   line.xMax = *std::max_element(line.x.begin(), line.x.end());
   line.yMin = *std::min_element(line.y.begin(), line.y.end());
   line.yMax = *std::max_element(line.y.begin(), line.y.end());
      
   m_update = true;
   
   return;
}

void CImgPlot::line(const int index, std::vector<float> x,
		    std::vector<float> y, color_t color, std::string style)
{
   if ( x.size() != y.size() ) {
      std::cerr << "ERROR: size of x (" << x.size() << ") != size of y ("
		<< y.size() << ")\n";
      return;
   }

   // create and add the line
   line_t line;
   line.x = x;
   line.y = y;
   line.color[0] = color[0];
   line.color[1] = color[1];
   line.color[2] = color[2];
   line.style = style;
   
   this->handleLine(line);

   try {
      m_lines.at(index) = line;
   }
   catch (std::exception &e) {
      m_lines.push_back(line);
      std::cout << "WARNING: Caught exception " << e.what() << "Probably, line"
		<< " index " << index << " does not exist. Adding it.\n";
   }

   return;
}

void CImgPlot::line(const int index, std::vector<float> x,
		    std::vector<float> y, std::string style)
{
   this->line(index, x, y, m_colorWheel.getColor(index), style);

   return;
}

void CImgPlot::line(std::vector<float> x, std::vector<float> y,
		    color_t color, std::string style)
{
   if ( x.size() != y.size() ) {
      std::cerr << "ERROR: size of x (" << x.size() << ") != size of y ("
		<< y.size() << ")\n";
      return;
   }

   // create and add the line
   line_t line;
   line.x = x;
   line.y = y;
   line.color[0] = color[0];
   line.color[1] = color[1];
   line.color[2] = color[2];
   line.style = style;

   this->handleLine(line);

   m_lines.push_back(line);

   m_update = true;

   return;
}

void CImgPlot::line(std::vector<float> x, std::vector<float> y,
			std::string style)
{
   this->line(x, y, m_foregroundColor, style);
}

void CImgPlot::draw()
{
   if ( m_update ) {

      if ( m_lines.size() > 0 ) {
	 m_xlow = m_lines.at(0).xMin;
	 m_xhigh = m_lines.at(0).xMax;
	 m_ylow = m_lines.at(0).yMin;
	 m_yhigh = m_lines.at(0).yMax;
	 
	 // recompute global max and min
	 for ( const line_t l : m_lines ) {
	    m_xlow = std::min(l.xMin, m_xlow);
	    m_xhigh = std::max(l.xMax, m_xhigh);
	    m_ylow = std::min(l.yMin, m_ylow);
	    m_yhigh = std::max(l.yMax, m_yhigh);
	 }
	 // if we should follow te x-axis, we need to compute again
	 if ( m_xRangeFollow ) {
	    m_xlow = m_xhigh - m_xRange;
	    // recompute y-range here
	 }

	 // handle the case where both are 0
	 if ( std::abs(m_xhigh) < 1e-12 && std::abs(m_xlow) < 1e-12 ) {
	    m_xhigh = 1.0;
	    m_xlow = -1.0;
	 }
	 // if they are too close to each other, zoom out
	 else if ( (m_xhigh - m_xlow)/(m_xhigh + m_xlow) < 0.01 ) {
	    if ( m_xhigh > 0 ) m_xhigh *= 1.1;
	    else m_xhigh *= 0.9;
	    if ( m_xlow > 0 ) m_xlow *= 0.9;
	    else m_xlow *= 1.1;
	 }
	 // handle the case where both are 0
	 if ( std::abs(m_yhigh) < 1e-12 && std::abs(m_ylow) < 1e-12 ) {
	    m_yhigh = 1.0;
	    m_ylow = -1.0;
	 }
	 // if they are too close to each other, zoom out
	 else if ( (m_yhigh - m_ylow)/(m_yhigh + m_ylow) < 0.01 ) {
	    if ( m_yhigh > 0 ) m_yhigh *= 1.1;
	    else m_yhigh *= 0.9;
	    if ( m_ylow > 0 ) m_ylow *= 0.9;
	    else m_ylow *= 1.1;
	 }

      }

      this->createTicks();
   }
   
   this->fill(m_backgroundColor);
   
   // draw axes
   this->draw_line(m_leftBorderSize,
		   (this->height() - m_bottomBorderSize),
		   (this->width() - m_rightBorderSize),
		   (this->height() - m_bottomBorderSize),
		   &m_foregroundColor[0]);
   this->draw_line(m_leftBorderSize,
		   m_topBorderSize,
		   (this->width() - m_rightBorderSize),
		   m_topBorderSize,
		   &m_foregroundColor[0]);
   this->draw_line(m_leftBorderSize,
		   (this->height() - m_bottomBorderSize),
		   m_leftBorderSize,
		   m_topBorderSize,
		   &m_foregroundColor[0]);
   this->draw_line((this->width() - m_rightBorderSize),
		   (this->height() - m_bottomBorderSize),
		   (this->width() - m_rightBorderSize),
		   m_topBorderSize,
		   &m_foregroundColor[0]);

   // draw major ticks
   for ( float xTick : m_xTicks ) {
      this->draw_line(xToPixel(xTick),
		      (this->height() - m_bottomBorderSize),
		      xToPixel(xTick),
		      (this->height() - m_bottomBorderSize) - 10,
		      &m_foregroundColor[0]);
      this->draw_line(xToPixel(xTick),
		      m_topBorderSize,
		      xToPixel(xTick),
		      m_topBorderSize + 10,
		      &m_foregroundColor[0]);
      std::stringstream ss;
      ss << std::fixed << std::setprecision(1) << xTick;
      this->draw_text(xToPixel(xTick) - 2*ss.str().size(),
		      (this->height() - m_bottomBorderSize),
		      ss.str().c_str(),
		      &m_foregroundColor[0]);
   }
   for ( float yTick : m_yTicks ) {
      this->draw_line((this->width() - m_rightBorderSize),
		      yToPixel(yTick),
		      (this->width() - m_rightBorderSize) - 10,
		      yToPixel(yTick),
		      &m_foregroundColor[0]);
      this->draw_line(m_leftBorderSize,
		      yToPixel(yTick),
		      m_leftBorderSize + 10,
		      yToPixel(yTick),
		      &m_foregroundColor[0]);
      std::stringstream ss;
      ss << std::fixed << std::setprecision(1) << yTick;
      this->draw_text(m_leftBorderSize  - 5*ss.str().size() - 2,
		      yToPixel(yTick) - 6,
		      ss.str().c_str(),
		      &m_foregroundColor[0]);
   }
   // draw minor ticks
   for ( float xTick : m_xMinorTicks ) {
      this->draw_line(xToPixel(xTick),
		      (this->height() - m_bottomBorderSize),
		      xToPixel(xTick),
		      (this->height() - m_bottomBorderSize) - 5,
		      &m_foregroundColor[0]);
      this->draw_line(xToPixel(xTick),
		      m_topBorderSize,
		      xToPixel(xTick),
		      m_topBorderSize + 5,
		      &m_foregroundColor[0]);
   }
   for ( float yTick : m_yMinorTicks ) {
      this->draw_line((this->width() - m_rightBorderSize),
		      yToPixel(yTick),
		      (this->width() - m_rightBorderSize) - 5,
		      yToPixel(yTick),
		      &m_foregroundColor[0]);
      this->draw_line(m_leftBorderSize,
		      yToPixel(yTick),
		      m_leftBorderSize + 5,
		      yToPixel(yTick),
		      &m_foregroundColor[0]);
   }
   // draw axes titles
   this->draw_text((this->width() - m_rightBorderSize)  - 5*m_xTitle.size(),
		   (this->height() - m_bottomBorderSize/2),
		   m_xTitle.c_str(),
		   &m_foregroundColor[0]);
   // for y-axis, rotate the whole image 90 deg, draw text, then rotate back
   this->rotate(90.0);
   this->draw_text((this->width() - m_topBorderSize)  - 5*m_yTitle.size(),
		   4,
		   m_yTitle.c_str(),
		   &m_foregroundColor[0]).rotate(-90.0);

   // draw line-type data
   for ( line_t line : m_lines ) {
      for ( unsigned int i = 0; i < line.x.size(); ++i ) {
	 if ( line.x[i] < m_xlow ) continue;
	 if ( line.x[i+1] > m_xhigh ) continue;
	 if ( line.y[i] < m_ylow ) continue;
	 if ( line.y[i+1] > m_yhigh ) continue;
	 if ( line.style.find("l") != std::string::npos
	      && i < line.x.size() - 1 ) {
	    this->draw_line(xToPixel(line.x[i]), yToPixel(line.y[i]),
			    xToPixel(line.x[i+1]), yToPixel(line.y[i+1]),
			    &line.color[0]);
	 }
	 if ( line.style.find("p") != std::string::npos ) {
	    this->draw_circle(xToPixel(line.x[i]), yToPixel(line.y[i]),
			      4, &line.color[0]);
	 }
      }
   }
}
