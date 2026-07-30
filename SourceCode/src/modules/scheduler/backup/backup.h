/*
 * backup.h
 *
 *  Created on: 23 Jun 2023
 *      Author: dev
 */

#ifndef SRC_MODULES_SCHEDULER_BACKUP_BACKUP_H_
#define SRC_MODULES_SCHEDULER_BACKUP_BACKUP_H_

#include <stdbool.h>
#include <stdint.h>

bool save_data_to_non_volatile_memory(uint8_t *data, uint32_t size);
bool read_data_from_non_volatile_memory(uint8_t *data, uint32_t size);

#endif /* SRC_MODULES_SCHEDULER_BACKUP_BACKUP_H_ */
