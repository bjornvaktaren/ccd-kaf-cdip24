#include <Thermistor.hpp>

Thermistor::Thermistor(
   const double R25,
   const double beta,
   const double V0,
   const double Rref,
   const double ADCRes
   ) : m_R25    { R25    },
       m_beta   { beta   },
       m_V0     { V0     },
       m_Rref   { Rref   },
       m_ADCRes { ADCRes },
       m_U      { -1.0   }
{
};

double Thermistor::getCelsius()
{
   if ( m_U > 0.0 ) {
      return 1.0 / 
	 ( 1.0/m_beta * std::log( m_Rref*m_U / (m_V0*m_R25 - m_R25*m_U) )
	   + 1/m_T25 )
	 - m_T0;
   }
   else return -1.0*m_T0;
}
