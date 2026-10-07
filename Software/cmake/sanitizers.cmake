# Enable address sanitizer for particular test.
function(enable_sanitizers TEST_NAME)
    target_compile_options(${TEST_NAME} PUBLIC -fsanitize=address)
    target_link_options(${TEST_NAME} PUBLIC -fsanitize=address)
endfunction()
