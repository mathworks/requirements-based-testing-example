/*
 * File: CruiseControl_C.h
 *
 * Code generated for Simulink model 'CruiseControl_C'.
 *
 * Model version                  : 1.357
 * Simulink Coder version         : 9.1 (R2019a) 23-Nov-2018
 * C/C++ source code generated on : Tue Apr  2 18:13:36 2019
 *
 * Target selection: ert.tlc
 * Embedded hardware selection: 32-bit Generic
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#ifndef CruiseControl_C_h_
#define CruiseControl_C_h_
#ifndef CruiseControl_C_COMMON_INCLUDES_
# define CruiseControl_C_COMMON_INCLUDES_
#include "rtwtypes.h"
#endif                                 /* CruiseControl_C_COMMON_INCLUDES_ */

/* Block states */
typedef struct {
  uint8_T is_active;
  uint8_T is_TOP;       
  uint8_T is_CRUISE;                   
  uint8_T is_ON;    
  uint32_T counter;
  uint8_T tspeed;
  boolean_T AccelResSw_prev;
  boolean_T CoastSetSw_prev ;
} chartState_T;

/* Block states */
extern chartState_T cs;

/*
 * Exported Global Parameters
 *
 */
extern uint8_T holdrate;               
extern uint8_T incdec;                 
extern uint8_T maxtspeed;              
extern uint8_T mintspeed;              

/* Model entry point functions */
extern void initialize(uint8_T holdrateVal, uint8_T incdecVal, 
        uint8_T maxtspeedVal, uint8_T mintspeedVal);

/* Customized model step function */
extern void computeTargetSpeed(boolean_T CruiseOnOff, boolean_T Brake, uint8_T
  Speed, boolean_T CoastSetSw, boolean_T AccelResSw, boolean_T *engaged, uint8_T
  *tspeed);

#endif                                 /* CruiseControl_C_h_ */

/*
 *
 * [EOF]
 *
 */
