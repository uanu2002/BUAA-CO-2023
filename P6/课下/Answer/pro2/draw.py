import pandas as pd
import matplotlib.pyplot as plt

# 将数据放入DataFrame中
data = pd.DataFrame({
    'Nums': [256, 128, 512, 1024, 64, 256, 256, 256, 256],
    'Block size': [8, 8, 8, 8, 8, 4, 2, 1, 16],
    'Cache visit': [11059200, 11059200, 11059200, 11059200, 11059200, 11059200, 11059200, 11059200, 11059200],
    'Memory visit': [3195006, 7935498, 860738, 28426, 10452584, 4235946, 5567678, 7232164, 2339638],
    'Cache replace': [1597247, 3967621, 429857, 13189, 5226228, 2117717, 2783583, 3615826, 1169563],
    'Times': [2.57, 1.22, 5.62, 9.75, 0.96, 2.07, 1.66, 1.33, 3.21],
    'Capacity': [2048, 1024, 4096, 8192, 512, 1024, 512, 256, 4096]
})

# 按照Nums和Block size分组，并计算平均值
grouped = data.groupby(['Capacity', 'Block size']).mean()

# 绘制柱状图
grouped.plot(kind='bar', y='Times')

# 绘制折线图
grouped.plot(kind='line', y='Memory visit')
plt.xticks(rotation=-15)
plt.show()