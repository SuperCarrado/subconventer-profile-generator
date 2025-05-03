#!/bin/bash

# 检查config文件夹和相关文件是否存在
if [ ! -d "config" ]; then
    echo "错误: 找不到 config 目录。"
    exit 1
fi

if [ ! -f "config/config.txt" ]; then
    echo "错误: 找不到 config/config.txt 文件。"
    exit 1
fi

if [ ! -f "config/default_url.txt" ]; then
    echo "错误: 找不到 config/default_url.txt 文件。"
    exit 1
fi

# 读取config.txt的内容
config_content=$(cat "config/config.txt")

# 读取urls目录下的所有txt文件内容并用|连接
url_files_content=""
for file in config/urls/*.txt; do
    if [ -f "$file" ]; then
        file_content=$(cat "$file")
        if [ -z "$url_files_content" ]; then
            url_files_content="$file_content"
        else
            url_files_content="$url_files_content|$file_content"
        fi
    fi
done

# 读取wireguard目录下的所有conf文件，生成wireguard格式的base64链接，并用|链接
for file in config/wireguards/*.conf; do
    if [ -f "$file" ]; then
        base64_content="$(base64 $file -w 0)"
        wireguard_url="wireguard://$base64_content"
        if [ -z "$wireguard_url" ]; then
            url_files_content="$wireguard_url"
        else
            url_files_content="$url_files_content|$wireguard_url"
        fi
    fi
done

# 遍历default_url.txt中的每一行，生成对应的输出文件
while IFS= read -r line; do
    # 使用awk分割第一部分为name，第二部分为url
    name=$(echo "$line" | awk -F: '{print $1}' | xargs)
    url=$(echo "$line" | awk -F: '{print substr($0, index($0,$2))}' | xargs)

    # 检查name和url是否为空
    if [ -z "$name" ] || [ -z "$url" ]; then
        echo "警告: 跳过无效行 [$line]，因为name或URL为空。"
        continue
    fi
    
    # 生成输出文件名为name的值加上.ini扩展名
    output_file="${name}.ini"

    # 创建并写入output_file
    cat <<EOL > "$output_file"
[Profile]
url=$url|$url_files_content
target=clash
config=$config_content
EOL

    echo "文件 $output_file 已生成。"
done < "config/default_url.txt"