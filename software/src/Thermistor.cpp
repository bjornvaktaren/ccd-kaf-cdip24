#include <Thermistor.hpp>

Thermistor::Thermistor(
   const double R25,
   const double beta,
   const double V0,
   const double Rref
   ) : m_R25  { R25 },
       m_beta { beta },
       m_V0   { V0 },
       m_Rref { Rref }
{
};

double Thermistor::celsius(const double &U)
{
   return 1.0 / 
      ( 1.0/m_beta * std::log( m_Rref*U / (m_V0*m_R25 - m_R25*U) ) + 1/m_T25 )
      - m_T0;
}
