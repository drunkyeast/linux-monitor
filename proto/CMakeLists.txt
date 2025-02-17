find_package(protobuf CONFIG REQUIRED)
find_package(gRPC CONFIG REQUIRED)
find_package(c-ares CONFIG)
# find_package(Threads)
# 确保 Protobuf 和 gRPC 的库和工具可用。REQUIRED参数, 如果不可用cmake就结束并退出.

#
# Protobuf/Grpc source files
#
set(PROTO_FILES
    monitor_info.proto
    cpu_load.proto
    cpu_softirq.proto
    cpu_stat.proto
    mem_info.proto
    net_info.proto
)

#
# Add Library target with protobuf sources
#
add_library(monitor_proto ${PROTO_FILES})
target_link_libraries(monitor_proto
    PUBLIC
        protobuf::libprotobuf
        gRPC::grpc
        gRPC::grpc++
)
# 创建一个名为 monitor_proto 的库目标
# 将 Protobuf 和 gRPC 的库链接到 monitor_proto。

target_include_directories(monitor_proto PUBLIC
${PROTOBUF_INCLUDE_DIRS} 
${CMAKE_CURRENT_BINARY_DIR})
# 为 monitor_proto 添加头文件搜索路径。
# ${PROTOBUF_INCLUDE_DIRS}：Protobuf 的头文件路径。
# ${CMAKE_CURRENT_BINARY_DIR}：当前构建目录，用于包含生成的 .pb.h 和 .grpc.pb.h 文件。

#
# Compile protobuf and grpc files in mointor proto target to cpp
#
get_target_property(grpc_cpp_plugin_location gRPC::grpc_cpp_plugin LOCATION)
protobuf_generate(TARGET monitor_proto LANGUAGE cpp)
# 使用 protobuf_generate 函数(就是protoc)为目标 monitor_proto 处理 .proto 文件，生成 Protobuf 的 C++ 文件。
protobuf_generate(TARGET monitor_proto LANGUAGE grpc GENERATE_EXTENSIONS .grpc.pb.h .grpc.pb.cc PLUGIN "protoc-gen-grpc=${grpc_cpp_plugin_location}")
# 使用 protobuf_generate 函数为目标 monitor_proto 处理 .proto 文件，生成 gRPC 的 C++ 文件。
