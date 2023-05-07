import math
import json

"""
整体说明
本程序通过模拟在计算机中计算卷积，来体会cache带来的性能提升
卷积计算过程中（conv）所有需要存取数据的操作都通过read/write函数完成，借此记录存取数据
read/write函数中根据模拟的缓存判断此时模拟中应当从内存中取数据还是从缓存中取，
对应调用read_memory和write_memory或者直接读写缓存，并加以记录和统计
"""

"""
如果访主存次数较多，仿真程序将会运行的比较慢
这套机制用于帮助显示进度，具体实现位于函数read()中
"""
landmark = [0]
step = 500000


def round_block(addr):
    """缓存一次以一行为单位读，这里就是为了拿到addr所在的一行的地址"""
    x = 65536 - block_size
    return addr & x


# read main memory(lw)
def read_memory(addr):
    block = []
    memory_visit[0] += 1
    for i in range(block_size):
        addr_t = i + addr
        if addr_t < core_base:
            d = image[addr_t]
        elif addr_t < result_base:
            d = core[addr_t - core_base]
        else:
            d = r[addr_t - result_base]
        block.append(d)
    return block


# write main memory(sw)
def write_memory(addr, data):
    memory_visit[0] += 1
    for i in range(block_size):
        addr_t = i + addr
        if addr_t < core_base:
            image[addr_t] = data[i]
        elif addr_t < result_base:
            core[addr_t - core_base] = data[i]
        else:
            r[addr_t - result_base] = data[i]


def kickoff():
    """
    当cache满时，需要调用此函数进行替换。目前的替换方式为完全随机替换
    """
    cache_replace[0] += 1
    from random import choice
    index = choice(list(cache.keys()))
    d = cache.pop(index)
    addr = index * block_size
    write_memory(round_block(addr), d)


def read(addr):
    """
    这个函数用于读存储器，在更改conv函数的实现方式时，读image、core或result均需要通过这个接口
    """
    cnt[addr] += 1
    cache_visit[0] += 1
    if cache_visit[0] > landmark[0] + step:
        acc = (cache_visit[0] + 0.0) / 110592.0
        acc = round(acc, 2)
        print('进度：{}%'.format(acc))
        landmark[0] = cache_visit[0]
    index = int(addr / block_size)
    if index not in cache.keys():
        if len(cache) >= nums:
            # 缓存中条目已满，需要清除一个才能加入
            kickoff()
        block = read_memory(round_block(addr))
        cache[index] = block
    offset = addr % block_size
    x = cache[index][offset]
    return x


def write(addr, data):
    """
    这个函数用于写存储器，在更改conv函数的实现方式时，写image、core或result均需要通过这个接口
    """
    cnt[addr] += 1
    cache_visit[0] += 1
    index = int(addr / block_size)
    if index not in cache.keys():
        if len(cache) >= nums:
            kickoff()
        block = read_memory(round_block(addr))
        cache[index] = block
    offset = addr % block_size
    cache[index][offset] = data


# cal conv
def conv(size, kernel_size, in_channels, out_channels):
    """
    内存布局：从外到内
    image:in_channels - height - width
    core:in_channels - out_channels - coreHeight - coreWidth
    result:out_channels - rHeight - rWidth
    即channel first

    计算方式：
    no padding，即rHeight = height - coreHeight + 1

    其他说明：
    图片和卷积核均为正方形，即height == width == size； coreHeight == coreWidth == kernel_size
    """
    r_size = size - kernel_size + 1
    for h in range(r_size):
        for w in range(r_size):
            for H in range(kernel_size):
                for W in range(kernel_size):
                    for i in range(in_channels):
                        for j in range(out_channels):
                            addr_image = w + W + size * (h + H + size * i)
                            addr_core = W + kernel_size * (H + kernel_size * (j + out_channels * i))
                            addr_result = w + r_size * (h + r_size * j)
                            t1 = read(addr_image + image_base)
                            t2 = read(addr_core + core_base)
                            t3 = read(addr_result + result_base)
                            t3 += t1 * t2
                            write(addr_result + result_base, t3)


def back_to_memory():
    """
    完成计算后要将cache写回主存，结束进程
    """
    for index in cache.keys():
        addr = index * block_size
        write_memory(addr, cache[index])


# 这三个变量用于计算cache指标
memory_visit = [0]
cache_visit = [0]
cache_replace = [0]

"""
nums:cache项数
block_size:一项cache中的字数，也是cache与主存交互的最小单位
"""
nums = 256
block_size = 8
cache = {}

"""
内存排布方式
"""
image_base = 0
core_base = 2352
result_base = 7152

"""
模拟读取硬盘数据，装入内存
"""
image = json.load(open('image.json'))
core = json.load(open('core.json'))
r = [0] * 576 * 64

"""
用于统计各个部位的访问次数，同学们可以在实现新的conv函数后，在函数执行过程中查看此变量信息，方便进行分析与统计
"""
cnt = [0] * (len(r) + result_base)

"""
计算
"""
conv(28, 5, 3, 64)
back_to_memory()

"""
与标准结果进行正确性比较
"""
EPS = 1e-12
r2 = json.load(open('result.json'))
for i in range(576 * 64):
    if math.fabs(r[i] - r2[i]) > EPS:
        print('Cannot Pass Correctness Check!')
        exit()
print('Pass Correctness Check!')

"""
正确性确保后，进行cache统计与分析
"""
data_sum = cache_visit[0] * 32
data_memory = memory_visit[0] * 32 * block_size
data_origin = cache_visit[0] * 32 * block_size
times_origin = 10 * cache_visit[0]
times_now = cache_visit[0] + 10 * memory_visit[0]
times = times_origin / times_now
times = round(times, 2)
data_sum = (data_sum + 0.0) / 1048576
data_sum = round(data_sum, 3)
data_memory = (data_memory + 0.0) / 1048576
data_memory = round(data_memory, 3)
data_origin = (data_origin + 0.0) / (1073741824)
data_origin = round(data_origin, 3)
print('总共访存量为{}MiB，在这过程中与主存交互字节数{}MiB，如果不使用cache，共需与主存交互{}GiB字节数据！\n'
      '总共访问cache {}次，总共访问主存{}次，假设主存的访问时间为cache的10倍，则整体访存效率提高了{}倍！'
      .format(data_sum, data_memory, data_origin, cache_visit[0], memory_visit[0], times))
