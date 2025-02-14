git ls-files | xargs du | awk '{sum += $1} END {printf "%.2f MB\n", sum/1024}'
git ls-files | xargs du -b | awk '{sum += $1} END {printf "%.2f MB\n", sum/1024/1024}'
初始文件大小49MB
