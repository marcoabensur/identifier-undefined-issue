
#ifndef PORT_H_INCLUDED
#define PORT_H_INCLUDED

#include <parts.h>
#include <io.h>

/** Convenience definition for GPIO module group A on the device (if
 *  available). */
#if (PORT_GROUPS > 0) || defined(__DOXYGEN__)
#  define PORTA             PORT->Group[0]
#endif

#if (PORT_GROUPS > 1) || defined(__DOXYGEN__)
/** Convenience definition for GPIO module group B on the device (if
 *  available). */
#  define PORTB             PORT->Group[1]
#endif

#if (PORT_GROUPS > 2) || defined(__DOXYGEN__)
/** Convenience definition for GPIO module group C on the device (if
 *  available). */
#  define PORTC             30
#endif

#if (PORT_GROUPS > 3) || defined(__DOXYGEN__)
/** Convenience definition for GPIO module group D on the device (if
 *  available). */
#  define PORTD             40
#endif

#endif
