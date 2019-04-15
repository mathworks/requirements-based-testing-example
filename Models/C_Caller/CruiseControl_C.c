/*
 * File: CruiseControl_C.c
 *
 * Code initially generated from Simulink model 'CruiseControl_C'.
 * Modified to hand code style
 *
 */

#include "CruiseControl_C.h"

/* Named constants for Chart: '<Root>/computeTargetSpeed' */
#define IN_NO_ACTIVE_CHILD ((uint8_T)0U)

/* TOP States */
#define IN_CRUISE      ((uint8_T)1U)
#define IN_OFF         ((uint8_T)2U)
/* CRUISE States */
#define IN_ON          ((uint8_T)1U)
#define IN_STANDBY     ((uint8_T)2U)
/* ON States */
#define IN_Accel       ((uint8_T)1U)
#define IN_Coast       ((uint8_T)2U)
#define IN_Steady      ((uint8_T)3U)

/* parameters */
uint8_T holdrate = 5U;                 
uint8_T incdec = 1U;                   
uint8_T maxtspeed = 90U;               
uint8_T mintspeed = 20U;               

/* Block states (default storage) */
chartState_T cs;


static int32_T div_s32(int32_T numerator, int32_T denominator);

/* Divide by zero protection */
static int32_T div_s32(int32_T numerator, int32_T denominator)
{
    int32_T quotient;
    uint32_T tempAbsQuotient;
    if (denominator == 0) {
        quotient = numerator >= 0 ? MAX_int32_T : MIN_int32_T;

    //   Divide by zero handler 
    } 
    else {
        tempAbsQuotient = (uint32_T)((numerator < 0 ? (uint32_T)((uint32_T)
            ~(uint32_T)numerator + 1U) : (uint32_T)numerator) / (denominator < 0 ?
            (uint32_T)((uint32_T)~(uint32_T)denominator + 1U) : (uint32_T)denominator));
        quotient = (numerator < 0) != (denominator < 0) ? (int32_T)-(int32_T)
        tempAbsQuotient : (int32_T)tempAbsQuotient;
    }

  return quotient;
}


/* chart step function */
void computeTargetSpeed(boolean_T CruiseOnOff, boolean_T Brake, uint8_T Speed,
  boolean_T CoastSetSw, boolean_T AccelResSw, boolean_T *engaged, uint8_T
  *tspeed)
{
    
    if ((uint32_T)cs.is_active == 0U) {
        /* state machine not active, default transition to "OFF" */
        cs.is_active = 1U;
        cs.is_TOP = IN_OFF;
        *engaged = false;
        cs.tspeed = 0U;
    } 
    else if (cs.is_TOP == IN_CRUISE) {
        /* in "CRUISE" */
        
        /* check for power off transition to "OFF" */
        if (!CruiseOnOff) {
            cs.is_ON = IN_NO_ACTIVE_CHILD;
            cs.is_CRUISE = IN_NO_ACTIVE_CHILD;
            cs.is_TOP = IN_OFF;

            *engaged = false;
            cs.tspeed = 0U;
        } 
        else if (cs.is_CRUISE == IN_ON) {
            /* in "ON" (engaged) */
            *engaged = true;
            
            /* check for safety related disengage transition to "STANDBY" */
            if (Brake || (Speed > maxtspeed) || (Speed < mintspeed)) {
                cs.is_ON = IN_NO_ACTIVE_CHILD;
                cs.is_CRUISE = IN_STANDBY;
                *engaged = false;
            } 
            else {
                
                if (cs.is_ON == IN_Steady)
                    cs.counter = 0U;
                else
                    cs.counter++;
                
                switch (cs.is_ON) {
                    
                    case IN_Accel:
                        /* in "Accel" */
                        
                        /* check for "hold" event */
                        if (cs.counter >= (uint32_T)div_s32
                            ((int32_T)(10 * (int32_T)incdec), (int32_T)holdrate)) {
                            cs.is_ON = IN_Accel;
                            cs.counter = 0U;
                            cs.tspeed = (uint8_T)(int32_T)((int32_T)
                                cs.tspeed + (int32_T)incdec);
                        } 
                        else { /* check for "exit" transition to "Steady"event */
                            if ((!AccelResSw) || (cs.tspeed >= maxtspeed)) {
                                cs.is_ON = IN_Steady;
                            }
                        }
                    break;

                    case IN_Coast:
                        /* in "Coast" */
                    
                        /* check for "hold" event */
                        if (cs.counter >= (uint32_T)div_s32
                            ((int32_T)(10 * (int32_T)incdec), (int32_T)holdrate)) {
                            cs.is_ON = IN_Coast;
                            cs.counter = 0U;
                            cs.tspeed = (uint8_T)(int32_T)((int32_T)
                                cs.tspeed - (int32_T)incdec);
                        } 
                        else { /* check for "exit" transition to "Steady" */
                            if ((!CoastSetSw) || (cs.tspeed <= mintspeed)) {                    
                                cs.is_ON = IN_Steady;
                            }
                        }
                        break;

                    default:
                        /* during "Steady" */
                    
                        /* check for transition to "accel" event */
                        if ((AccelResSw > cs.AccelResSw_prev) && 
                                (cs.tspeed < maxtspeed)) {
                            cs.is_ON = IN_Accel;
                            /* increment "tspeed" */
                            cs.tspeed = (uint8_T)(int32_T)((int32_T)
                                cs.tspeed + (int32_T)incdec);
                        } 
                    
                        /* check for transition to "coast" event */
                        else if ((CoastSetSw > cs.CoastSetSw_prev) &&
                            (cs.tspeed > mintspeed)) {
                            cs.is_ON = IN_Coast;
                            /* decrement "tspeed" */
                            cs.tspeed = (uint8_T)(int32_T)((int32_T)
                                cs.tspeed - (int32_T)incdec);
                        } 
                        
                        else { /* check for "exit" transition to "Steady" */
                            if (CoastSetSw > cs.CoastSetSw_prev) {
                                cs.tspeed = Speed;
                                cs.is_ON = IN_Steady;
                            }
                        }
                        break;
                }
            }
        } 
        else {
            /* in "STANDBY" */
            *engaged = false;

            /* check for transition(s) to "ON" */
      
            /* first safety check for valid transition */
            if ((!Brake) && (Speed <= maxtspeed) && (Speed >= mintspeed)) {
     
                /* check for "AccelResSw" transition to "ON/Steady" */
                if ((cs.AccelResSw_prev < AccelResSw) &&
                    ((int32_T) cs.tspeed != 0)) {
                    cs.is_CRUISE = IN_ON;
                    *engaged = true;
                    cs.is_ON = IN_Steady;
                } 
                else { /* check for "CoastSetSw" transition to "ON/Steady" */
                    if (cs.CoastSetSw_prev < CoastSetSw) {
                        cs.is_CRUISE = IN_ON;
                        *engaged = true;
                        cs.tspeed = Speed;
                        cs.is_ON = IN_Steady;
                    }
                }
            }
        }
    } 
    else {
        /* in "OFF" */
        *engaged = false;

        /* check for transition to "CRUISE/STANDBY" */
        if (CruiseOnOff) {
            cs.is_TOP = IN_CRUISE;
            cs.is_CRUISE = IN_STANDBY;
        }
    }

    /* save previous button inputs */
    cs.AccelResSw_prev = AccelResSw;
    cs.CoastSetSw_prev = CoastSetSw;
    
    /* assign output to state tspeed */
    *tspeed = cs.tspeed;
    
}


/* chart initialize function */
void initialize(uint8_T holdrateVal, uint8_T incdecVal, 
        uint8_T maxtspeedVal, uint8_T mintspeedVal)
{
 
  /* clear chart states */
  (void) memset((void *)&cs, 0, sizeof(chartState_T));

  /* initialize chart "computeTargetSpeed" */
  cs.is_active = 0U;
  cs.is_CRUISE = IN_NO_ACTIVE_CHILD;
  cs.is_ON = IN_NO_ACTIVE_CHILD;
  cs.is_TOP = IN_NO_ACTIVE_CHILD;
  cs.counter = 0U;
  cs.tspeed = 0U;
  cs.AccelResSw_prev = (boolean_T) FALSE;
  cs.CoastSetSw_prev = (boolean_T) FALSE;
  
  /* initialize global parameters values */
  holdrate = (uint8_T) holdrateVal;  
  incdec = (uint8_T) incdecVal;  
  maxtspeed = (uint8_T) maxtspeedVal;  
  mintspeed = (uint8_T) mintspeedVal;  

}

/*
 * [EOF]
 */