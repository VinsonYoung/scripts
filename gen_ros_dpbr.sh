#!/bin/bash

set -e

# 下载 ISP 地址
declare -A ops=(
  ["ct"]="dpbr-CT"      # 电信
  ["cu"]="dpbr-CT"      # 联通
  ["edu"]="dpbr-CT"     # 教育网
  ["drpeng"]="dpbr-CT"  # 鹏博士
  ["broadnet"]="dpbr-CT" # 广电
  ["gwbn"]="dpbr-CT"    # 长城宽带
  ["others"]="dpbr-CT"  # 其他
  ["cm"]="dpbr-CMCC"    # 移动
)

base_url="https://ispip.clang.cn"

tmp_dir="$(mktemp -d)"
out_file="ros-dpbr-CT-CMCC.rsc"

# 下载所有ISP文件到临时目录
for op in "${!ops[@]}"; do
  wget --no-check-certificate -O "$tmp_dir/$op.txt" "$base_url/$op.txt"
done

# 生成 MikroTik address-list 语句，去重
{
  echo "/ip firewall address-list"
  # 用 associative array 去重
  declare -A seen
  for op in "${!ops[@]}"; do
    list="${ops[$op]}"
    while read -r addr; do
      addr="${addr//[$'\r\n']}" # 去掉换行回车
      [[ -z "$addr" ]] && continue
      # 地址去重
      if [[ -z "${seen[$addr]}" ]]; then
        seen[$addr]=1
        echo "add list=$list address=$addr"
      fi
    done < "$tmp_dir/$op.txt"
  done
} > "$out_file"

rm -rf "$tmp_dir"
