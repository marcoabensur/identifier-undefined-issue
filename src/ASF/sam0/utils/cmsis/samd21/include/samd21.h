#ifndef _SAMD21_
#define _SAMD21_

/**
 * \defgroup SAMD21_definitions SAMD21 Device Definitions
 * \brief SAMD21 CMSIS Definitions.
 */

#if defined(__SAMD21G17A__) || defined(__ATSAMD21G17A__)
  #include "samd21g17a.h"
#elif defined(__SAMD21G18A__) || defined(__ATSAMD21G18A__)
  #include "samd21g18a.h"
#else
  #error Library does not support the specified device.
#endif

#endif /* _SAMD21_ */
