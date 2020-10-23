#!/bin/bash

filename=$1

if [ "$filename" == "" ]; then
    echo "usage: ./trans-format.sh filename"
    echo ""
    echo "filename is not empty!!!"
    echo ""
    exit 1
fi


# 标题格式
sed -i 's/^=====/#####/g' $filename
sed -i 's/^====/####/g' $filename
sed -i 's/^===/###/g' $filename
sed -i 's/^==/##/g' $filename
sed -i 's/^=/#/g' $filename


# 列表格式
line=`sed -n '/::$/=' $filename`

for num in $line
do
    sed -i "${num}s/^/**/g" $filename
done

sed -i 's/::$/**/g' $filename


# 置空只有 + 的行
sed -i 's/^+$//g' $filename


# 代码块
sed -i 's/^----$/```/g' $filename
sed -i 's/^--$/```/g' $filename
sed -i 's/^....$/```/g' $filename


# 删除网页格式的锚点
sed -i '/^\[\[.*\]\]$/d' $filename


# 删除行
sed -i '/^\[verse\]$/d' $filename
sed -i '/^\[\#/d' $filename


# 图片格式
sed -i 's/^image::/!\[\]\(/g' $filename
sed -i 's/\[width=.*\]$/\)/g' $filename




# 去除列表格式（此处理放在最后）
line2=`sed -n '/::/=' $filename`

for num in $line2
do
    sed -i "${num}s/^/**/g" $filename
done

sed -i 's/::/**/g' $filename

line3=`sed -n '/;;/=' $filename`

for num in $line3
do
    sed -i "${num}s/^/**/g" $filename
done

sed -i 's/;;/**/g' $filename


