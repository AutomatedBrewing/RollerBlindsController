add_unit_test(${FW_LIBRARY_TARGET} test_ui 
    test_ui.c
    ui_test_vectors.c)

mock_function(test_ui em_publish_message)

# em_timer.h
mock_function(test_ui em_timer_create)
mock_function(test_ui em_timer_set_period)
mock_function(test_ui em_timer_set_event_id)
mock_function(test_ui em_timer_start)
mock_function(test_ui em_timer_stop)

# gpio.h
mock_function(test_ui gpio_pin_init)
mock_function(test_ui gpio_output_configure)
mock_function(test_ui gpio_output_set)
mock_function(test_ui gpio_output_clear)

# gpio_pins.h
mock_function(test_ui find_gpio_pin_context)

# configuration.h
mock_function(test_ui get_list_of_devices_by_type)


