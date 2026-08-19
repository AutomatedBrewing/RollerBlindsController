/*
 * button.c
 *
 *  Created on: 1 Oct 2022
 *      Author: Kamil Lazowski
 */

/* Private includes ----------------------------------------------------------*/
#include "controller_test_vectors.h"

#include "configuration.h"
#include "nvm_configuration.h"

/* Private define ------------------------------------------------------------*/
/* Private typedef -----------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
/* Private function prototypes -----------------------------------------------*/
/* Private function bodies ---------------------------------------------------*/
/* Private typedef -----------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
static const struct nvm_object nvm_objects[] = {
    {
        .id = NVM_ID_TRAVEL_TIME,
        .size = sizeof(struct travel_time)
    },
};


static const struct nvm_backend nvm_backend = {
    .size = 2048U,
    .erase_size = 256U,
/*
    .read = flash_read,
    .write = flash_program,
    .erase = flash_erase
    */
};

static const struct nvm_configuration nvm_config =
{
    .configuration = 
    {    
        .backend = &nvm_backend,
        .objects = nvm_objects,
        .object_count =
        sizeof(nvm_objects) / sizeof(nvm_objects[0])
    },
    .default_time = 69,
};

const struct device_configuration nvm_list[] = {
    {
        .id = DEVICE_NVM,
        .type = DEVICE_TYPE_NVM,
        .config = &nvm_config,
    },
};