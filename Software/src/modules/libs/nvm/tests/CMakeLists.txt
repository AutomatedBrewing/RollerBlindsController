add_unit_test(${FW_LIBRARY_TARGET} test_nvm 
    test_nvm.c
    ramdisk.c)


# configuration.h
mock_function(test_nvm get_list_of_devices_by_type)


