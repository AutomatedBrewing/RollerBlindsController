/*
 * utils.h
 *
 *  Created on: 12 Mar 2023
 *      Author: dev
 */

#ifndef NVM_CONFIGURATION_H_
#define NVM_CONFIGURATION_H_

/* Private includes ----------------------------------------------------------*/
#include "nvm.h"

/* Public define -------------------------------------------------------------*/
/* Public typedef ------------------------------------------------------------*/
struct travel_time
{
    uint32_t time;
};

struct nvm_configuration
{
    const struct nvm_config configuration;
    uint32_t default_time;
};

/* Public macro --------------------------------------------------------------*/
/* Public variables ----------------------------------------------------------*/
/* Public function prototypes ------------------------------------------------*/

#endif /* NVM_CONFIGURATION_H_ */
