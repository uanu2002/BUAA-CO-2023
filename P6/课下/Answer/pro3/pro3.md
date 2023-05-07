## pro3

### 替换策略

**LRU替换策略：**

*   将被访问的数据放在头部
*   将最长时间未被访问的数据置换

```diff
44,46d43
<     if data[2] == 0:
<         return
<     data = data[0]
63c60,61
<     index = list(cache.keys())[0]
---
>     from random import choice
>     index = choice(list(cache.keys()))
86,89c84
<         cache[index] = [block, 0, 0]
<     else:
<         value = cache.pop(index)
<         cache[index] = value
---
>         cache[index] = block
91c86
<     x = cache[index][0][offset]
---
>     x = cache[index][offset]
106,109c101
<         cache[index] = [block, 0, 0]
<     else:
<         value = cache.pop(index)
<         cache[index] = value
---
>         cache[index] = block
111,112c103
<     cache[index][0][offset] = data
<     cache[index][2] = 1
---
>     cache[index][offset] = data
```

**结果：**

Random9.61 -> FIFO9.64 -> LRU9.74

![image-20230422102405579](C:\Users\DELL\AppData\Roaming\Typora\typora-user-images\image-20230422102405579.png)

### 写回修改

增加dirty位。

**结果：**

无dirty9.74 -> 有dirty9.75

![image-20230422095442249](C:\Users\DELL\AppData\Roaming\Typora\typora-user-images\image-20230422095442249.png)
