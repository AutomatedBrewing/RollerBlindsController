if(DEFINED OS AND EXISTS ${CMAKE_CURRENT_LIST_DIR}/${OS})
    add_subdirectory(${OS})
endif()