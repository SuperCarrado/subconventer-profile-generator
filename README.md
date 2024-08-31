# 自动合成Subconverter的Profile配置文件
因为profile文件在需要合并多个url的时候，全部写在一行，一旦需要修改难以操作。

因此创建了这个脚本，通过读取各个txt文件然后自动合成profile。

生成的配置文件内容如下：
```
[Profile]
url=订阅地址|其他url
target=clash
config=外部配置文件地址
```

详情请参考原repo的文档：https://github.com/tindy2013/subconverter/blob/master/README-cn.md#%E9%85%8D%E7%BD%AE%E6%A1%A3%E6%A1%88


# 需要自己配置的文件
## 订阅地址
config/default_url.txt为订阅地址，可以配置多行，每一行都会生成一个profile文件（配置文件以其中的Key部分来命名）。

比如配置文件是：
```
订阅名1：地址1
订阅名2：地址2
```
那么就会生成 订阅名1.ini 和 订阅名2.ini。

## 附加地址
config/urls目录中为需要合并到最终配置文件的url中的地址，优先保证default_url.txt的地址在前，然后自动合并所有目录中的txt配置的地址，支持订阅地址或者单节点地址。

## 外部配置文件地址
config/config.txt文件为引用的外部config配置文件地址。

# 生成最终profile
直接运行 sh convet.sh