add_unit_test(${FW_LIBRARY_TARGET} test_buttons test_buttons.c)

# em_timer.h
mock_function(test_buttons em_timer_create)
mock_function(test_buttons em_timer_set_period)
mock_function(test_buttons em_timer_set_event_id)
mock_function(test_buttons em_timer_start)

# gpio.h
mock_function(test_buttons gpio_pin_init)
mock_function(test_buttons gpio_input_configure)
mock_function(test_buttons gpio_input_is_active)
mock_function(test_buttons gpio_input_interrupt_enable)
mock_function(test_buttons gpio_input_interrupt_disable)

# gpio_pins.h
mock_function(test_buttons find_gpio_pin_context)

# configuration.h
mock_function(test_buttons get_list_of_devices_by_type)


