#include <ColorWheel.hpp>

ColorWheel::ColorWheel() :
   m_nextColor{0}
{
   this->setDivergingPalette();
}

void ColorWheel::setDivergingPalette()
{
   m_colors.clear();
   m_colors.push_back(color::rose);
   m_colors.push_back(color::indigo);
   m_colors.push_back(color::sand);
   m_colors.push_back(color::green);
   m_colors.push_back(color::cyan);
   m_colors.push_back(color::wine);
   m_colors.push_back(color::teal);
   m_colors.push_back(color::olive);
   m_colors.push_back(color::purple);
   m_colors.push_back(color::grey);
}


void ColorWheel::setSequentialPalette()
{
   m_colors.clear();
   m_colors.push_back(color::indigo);
   m_colors.push_back(color::cyan);
   m_colors.push_back(color::teal);
   m_colors.push_back(color::green);
   m_colors.push_back(color::olive);
   m_colors.push_back(color::sand);
   m_colors.push_back(color::rose);
   m_colors.push_back(color::wine);
   m_colors.push_back(color::purple);
   m_colors.push_back(color::grey);
}
