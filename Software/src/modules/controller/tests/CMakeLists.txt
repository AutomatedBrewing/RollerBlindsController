add_unit_test(${FW_LIBRARY_TARGET} test_controller 
    test_controller.c
    controller_test_vectors.c)

mock_function(test_controller em_publish_message)

# em_timer.h
mock_function(test_controller em_timer_create)
mock_function(test_controller em_timer_set_period)
mock_function(test_controller em_timer_set_event_id)
mock_function(test_controller em_timer_start)
mock_function(test_controller em_timer_stop)

#nvm.h
mock_function(test_controller nvm_init)
mock_function(test_controller nvm_read)

# configuration.h
mock_function(test_controller get_list_of_devices_by_type)


