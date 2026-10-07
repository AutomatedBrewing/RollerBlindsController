add_unit_test(${FW_LIBRARY_TARGET} test_motor 
    test_motor.c
    motor_test_vectors.c)

mock_function(test_motor em_publish_message)

# em_timer.h
mock_function(test_motor em_timer_create)
mock_function(test_motor em_timer_set_period)
mock_function(test_motor em_timer_set_event_id)
mock_function(test_motor em_timer_start)
mock_function(test_motor em_timer_stop)

# gpio.h
mock_function(test_motor gpio_pin_init)
mock_function(test_motor gpio_output_configure)
mock_function(test_motor gpio_output_set)
mock_function(test_motor gpio_output_clear)

# gpio_pins.h
mock_function(test_motor find_gpio_pin_context)

# configuration.h
mock_function(test_motor get_list_of_devices_by_type)


