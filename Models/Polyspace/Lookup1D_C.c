/*
 *      Table Lookup
 *
 */

#include "Lookup1D_C.h"

/*-----------------------------------------------------------------------*/
float Lookup1D_C(char u, char X[], float Y[])
{
    float y    = 0.0f; 
    char index = 0;
    
    unsigned char mySize = 11;

    if(u >= X[mySize-1])
    {
        y = Y[mySize-1];
    }
    else if (u <= X[0])
    {
        y = Y[0];
    }
    else 
    {
        while((u >= X[index]) && (index < mySize))
        {
            index++;
        }
        if (index > 0)
        {
            y = Y[index-1] + (Y[index] - Y[index-1]) * (u - X[index-1]) / (X[index] - X[index-1]);
        }
    }
    return(y);
}

