#!/bin/sh
set -ex

mkdir -p ./pbr
cd ./pbr

# 电信
wget --no-check-certificate -c -O ct.txt https://ispip.clang.cn/chinatelecom.txt
grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}(\/[0-9]{1,2})?" ct.txt > ct.txt.tmp; mv ct.txt.tmp ct.txt
# 联通
wget --no-check-certificate -c -O cu.txt https://ispip.clang.cn/unicom_cnc.txt
grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}(\/[0-9]{1,2})?" cu.txt > cu.txt.tmp; mv cu.txt.tmp cu.txt
# 移动(含铁通)
wget --no-check-certificate -c -O cm.txt https://ispip.clang.cn/cmcc.txt
grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}(\/[0-9]{1,2})?" cm.txt > cm.txt.tmp; mv cm.txt.tmp cm.txt
# 广电
wget --no-check-certificate -c -O chinabtn.txt https://ispip.clang.cn/chinabtn.txt
grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}(\/[0-9]{1,2})?" chinabtn.txt > chinabtn.txt.tmp; mv chinabtn.txt.tmp chinabtn.txt
# 教育网
wget --no-check-certificate -c -O cernet.txt https://ispip.clang.cn/cernet.txt
grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}(\/[0-9]{1,2})?" cernet.txt > cernet.txt.tmp; mv cernet.txt.tmp cernet.txt
# 长城宽带/鹏博士
wget --no-check-certificate -c -O gwbn.txt https://ispip.clang.cn/gwbn.txt
grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}(\/[0-9]{1,2})?" gwbn.txt > gwbn.txt.tmp; mv gwbn.txt.tmp gwbn.txt
# 其他
wget --no-check-certificate -c -O other.txt https://ispip.clang.cn/other.txt
grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}(\/[0-9]{1,2})?" other.txt > other.txt.tmp; mv other.txt.tmp other.txt

# 生成 Mikrotik address-list 并去重
{
echo "/ip firewall address-list"

for net in $(cat ct.txt) ; do
  echo "add list=dpbr-CT address=$net"
done

for net in $(cat cu.txt) ; do
  echo "add list=dpbr-CT address=$net"
done

for net in $(cat cm.txt) ; do
  echo "add list=dpbr-CMCC address=$net"
done

for net in $(cat chinabtn.txt) ; do
  echo "add list=dpbr-CT address=$net"
done

for net in $(cat cernet.txt) ; do
  echo "add list=dpbr-CT address=$net"
done

for net in $(cat gwbn.txt) ; do
  echo "add list=dpbr-CT address=$net"
done

for net in $(cat other.txt) ; do
  echo "add list=dpbr-CT address=$net"
done
} | awk '!seen[$0]++' > ../ros-dpbr-CT-CMCC.rsc

cd ..
rm -rf ./pbr
