# CMakeList.txt: ���� CMake ��Ŀ�ļ����ڴ˴�ִ��ȫ������
# ����������Ŀ��
#
cmake_minimum_required (VERSION 3.8)

project("LxProj")

set(CMAKE_CXX_STANDARD 20)

SET(EXECUTABLE_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/Out)
SET(LIBRARY_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/Out)


if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
    set(ReleaseMode off)
    if(ReleaseMode)
        set(CMAKE_BUILD_TYPE "Release")
    else()
        set(CMAKE_BUILD_TYPE "Debug")
    endif()
    message("Build Types;${CMAKE_BUILD_TYPE}")
    SET(CMAKE_CXX_FLAGS_DEBUG "$ENV{CXXFLAGS} -O0 -Wall -g -ggdb")
    SET(CMAKE_CXX_FLAGS_RELEASE "$ENV{CXXFLAGS} -O3 -Wall")
endif()


function(include_sub_directories_recursively targetProj rootDir)
    if (IS_DIRECTORY ${rootDir})               # ��ǰ·����һ��Ŀ¼���ǵĻ��ͼ��뵽����Ŀ¼
        #message("Project:"${targetProj}" include dir: " ${rootDir})
        target_include_directories(${targetProj} PUBLIC ${rootDir})
        file(GLOB ALL_SUB RELATIVE ${rootDir} ${rootDir}/*) # ��õ�ǰĿ¼�µ������ļ�������ALL_SUB�б���
        foreach(sub ${ALL_SUB})
            include_sub_directories_recursively(${targetProj} ${rootDir}/${sub}) # ����Ŀ¼�ݹ���ã�����
        endforeach()
    endif()
endfunction()
# ��������Ŀ��
add_subdirectory ("LxProj")
