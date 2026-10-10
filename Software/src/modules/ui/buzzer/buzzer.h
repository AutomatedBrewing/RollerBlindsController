#ifndef SRC_MODULES_UI_BUZZER_H_
#define SRC_MODULES_UI_BUZZER_H_

/* Private includes ----------------------------------------------------------*/
#include <stdbool.h>
#include <stdint.h>

#include "gpio_pins.h"
#include "pwm.h"

/* Public define -------------------------------------------------------------*/
/* Public typedef ------------------------------------------------------------*/
struct buzzer {
    enum board_input_pin_id pin_id;
    uint32_t frequency_hz;
    pwm_handle_t pwm_handle;
    bool is_on;
};

struct buzzer_config {
    enum board_input_pin_id pin_id;
    uint32_t frequency_hz;
};

/* Public macro --------------------------------------------------------------*/
/* Public variables ----------------------------------------------------------*/
/* Public function prototypes ------------------------------------------------*/
bool buzzer_init(struct buzzer *buzzer,
                 const struct buzzer_config *config);

bool buzzer_on(struct buzzer *buzzer);
bool buzzer_off(struct buzzer *buzzer);

#endif /* SRC_MODULES_UI_BUZZER_H_ */