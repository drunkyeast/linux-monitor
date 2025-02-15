#!/usr/bin/env bash
# env的位置基本是规定了要固定的, env根据当前的PATH查找名为bash的可执行文件并运行它
# env bash -c 'echo "hello world"' 其中-c表示command_string, 执行单条命令.

set -e 
#如果脚本中的任意命令返回非零退出状态，脚本会立即退出。
# echo $? 如果出错了,能打印出返回值为1 
# 但是在逻辑运算符（如 && 和 ||）的上下文中。 遇到了错误不会退出, 卧槽. 别搞这么细了.

cd "$(dirname "${BASH_SOURCE[0]}")"
# BASH_SOURCE[0] 是脚本文件对于当前路径的相对路径
# dirname是查找这个路径所在的目录.
# BASH_SOURCE再命令行环境中是空的, 它主要用于脚本执行时记录调用栈中的脚本路径

# https://github.com/abseil/abseil-cpp/archive/refs/tags/20200225.2.tar.gz
# Install abseil.

THREAD_NUM=$(nproc)
# $(nproc)是命令替换,nproc命令的输出作为结果返回. 常见的还有$(date)或者`date`
# ``也可以像$()做命令替换,是旧语法, 推荐使用后者, 后者是现代语法且支持嵌套.
# $nproc和${nproc},nproc都表示变量名. $((5 + 3 * 2))里面放运算表达式.

VERSION="20200225.2"
PKG_NAME="abseil-cpp-${VERSION}.tar.gz"

tar xzf "${PKG_NAME}"
# 初心老哥: z参数表示用gzip是处理.gz文件, x与c分别表示extract和compress提取和压缩, v表示显示压缩解压的文件 f要放到最后面紧跟文件.
# tar -zcvf与-zxvf xxx.tar.gz文件

pushd "abseil-cpp-${VERSION}" 
    mkdir build && cd build
    cmake .. \
        -DBUILD_SHARED_LIBS=ON \
        -DCMAKE_CXX_STANDARD=14 \
        -DCMAKE_INSTALL_PREFIX=/usr/local
    make -j${THREAD_NUM}
    make install
popd
# pushd：切换到指定目录，并将当前目录压入目录栈中。popd：从目录栈中弹出最近的目录，并切换到该目录。
# abseil在我cmake ..和make后生成了很多.a文件, make install后才在指定的/usr/mytest中生成了.so文件在lib/和头文件在include/文件
# 这些东西chatgpt回答就很一坨屎, 幻觉严重啊, hallucination

ldconfig
# 系统命令,刷新新生成的动态链接库. ldconfig - configure dynamic linker run-time bindings

# Clean up
rm -rf "abseil-cpp-${VERSION}" "${PKG_NAME}"