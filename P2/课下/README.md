## 单步汉诺塔

**代码：hanoi.asm**

-   输入格式：

    -   输入包含1行，只包含1个1位整数，即0-9中的某一个整数，记其为n
    -   汉诺塔三根柱子的编号从左到右依次为'A','B','C',初始的时候所有盘子都在‘A'上，编号从上（小）到下（大）分别为0~n
    -   移动这些盘子到’C‘，要求移动时只能将某个柱子上最上面的盘子移动到相邻的柱子，并且任何情况下大盘子不能在小盘子上面，即A上的盘子不能直接移动到C上

-   输出格式：请参照下文的C语言样例，要求实现同粒度的输出（即能通过逐行strcmp的检测）

-   数据范围：

    -   0<n<10

-   C语言样例：

    ```c
    #include <stdio.h>
    void move(int id, char from, char to) {
      printf("move disk %d from %c to %c\n", id, from, to);
    }
    void hanoi(int base, char from, char via, char to) {
      if (base == 0) {
          move(base, from, via);
          move(base, via, to);
          return;
      }
      hanoi(base - 1, from, via, to);
      move(base, from, via);
      hanoi(base - 1, to, via, from);
      move(base, via, to);
      hanoi(base - 1, from, via, to);
    }
    int main() {
      int n;
      scanf("%d", &n);
      hanoi(n, 'A', 'B', 'C');
      return 0;
    }
    ```

-   输入输出样例：

    -   输入：

        ```
        2
        ```

    -   输出：

        ```
        move disk 0 from A to B
        move disk 0 from B to C
        move disk 1 from A to B
        move disk 0 from C to B
        move disk 0 from B to A
        move disk 1 from B to C
        move disk 0 from A to B
        move disk 0 from B to C
        move disk 2 from A to B
        move disk 0 from C to B
        move disk 0 from B to A
        move disk 1 from C to B
        move disk 0 from A to B
        move disk 0 from B to C
        move disk 1 from B to A
        move disk 0 from C to B
        move disk 0 from B to A
        move disk 2 from B to C
        move disk 0 from A to B
        move disk 0 from B to C
        move disk 1 from A to B
        move disk 0 from C to B
        move disk 0 from B to A
        move disk 1 from B to C
        move disk 0 from A to B
        move disk 0 from B to C
        ```

-   有关输出格式的提示

对于输出格式感到困难的同学，可以初始化一个字符串，ID 为 0，`from` 和 `to` 都为 ‘A',然后在输出的时候替换相应的字节。这也是题目为何要求 n<10 的一个原因

## 提交要求

1.  **请勿使用** `.globl main`
2.  不考虑延迟槽
3.  只需要提交.asm文件。
4.  程序的初始地址设置为**Compact,Data at Address 0**。





## 高精度乘法

**代码：mul.asm**

十进制高精度整数乘法。

## 输入格式

-   对于每一个乘数，先输入一个整数 n 作为位数，之后输入 n 个 1 位整数，每个 1 行。建议采用 5 号 syscall 进行读入。
-   一共有两个乘数，记它们的位数分别为 n1, n2。
-   输入一共包括 1+n1+1+n2 行。

## 数据范围

-   0<n1<250,0<n2<250
-   输入的乘数不存在前导零。

## 输出格式

-   输出包括一行，为乘法结果；需要按照十进制进行进位，不能包含前导零。结果为 0 时需输出 "0"。
-   可以使用 1 号 syscall 进行输出。

## 输入输出样例

-   输入1

    ```
    2
    1
    5
    2
    1
    5
    ```

-   输出1

    ```
    225
    ```

-   输入2

    ```
    3
    9
    9
    9
    3
    9
    9
    9
    ```

-   输出2

    ```
    998001
    ```

-   输入3

    ```
    1
    0
    6
    1
    1
    4
    5
    1
    4
    ```

-   输出3

    ```
    0
    ```

## 提示

如果用数组保存的高精度整数 `a` 和 `b`（低地址保存低位），那么只需要执行 `c[i+j] += a[i] * b[j]` 然后对 `c` 进行进位即可得到结果。





## 矩阵快速幂

**代码：matrix2.asm**

使用 MIPS 汇编语言编写程序，满足下列要求：

-   计算 m*m 矩阵的 2^n 次幂。
-   矩阵乘法次数不能超过 2n，否则可能超过指令条数限制。

算法提示：矩阵快速幂。将矩阵进行 n 次自乘运算，详情见代码：

```c
#include <stdio.h>

int tempMatrix[8][8];
int resultMatrix[8][8];
int m, n;

// 将 temp 矩阵平方并存入 result 矩阵
void sqrtTempMatrix()
{
    int i, j, k;
    // 常规的矩阵乘法，和课下一致
    for (i = 0; i < m; i++)
        for (j = 0; j < m; j++)
        {
            resultMatrix[i][j] = 0;
            for (k = 0; k < m; k++)
                resultMatrix[i][j] += tempMatrix[i][k] * tempMatrix[k][j];
        }
}

// 将 result 矩阵转移到 temp 矩阵
void replaceTempMatrix() {
    int i, j;
    for (i = 0; i < m; i++)
        for (j = 0; j < m; j++)
            tempMatrix[i][j] = resultMatrix[i][j];
}

// 计算 temp 矩阵的 2^n 次幂
void powerTempMatrix() {
    int i;
    // 对 temp 矩阵进行 n 次平方运算
    for (i = 0; i < n; i++)
    {
        // temp 矩阵自乘并存入 result 矩阵
        sqrtTempMatrix();
        // 将 result 矩阵转移到 temp 矩阵
        replaceTempMatrix();
    }
}

int main()
{
    int i, j;
    scanf("%d", &n);
    scanf("%d", &m);
    // 输入矩阵
    for (i = 0; i < m; i++)
        for (j = 0; j < m; j++)
            scanf("%d", &tempMatrix[i][j]);
    // 计算矩阵的 2^n 次幂
    powerTempMatrix();
    // 输出矩阵
    for (i = 0; i < m; i++)
    {
        for (j = 0; j < m; j++)
            printf("%d ", tempMatrix[i][j]);
        printf("\n");
    }
    return 0;
}
```

## 具体要求

-   首先读幂的次数 n，然后读入矩阵大小 m，然后再依次读取矩阵（m 行 m 列）中的元素。
-   我们提供的测试数据中 0<m≤8,0≤n≤10，每个矩阵元素小于 10。算法中所有所涉及的矩阵元素均不会溢出。
-   最终将计算出的结果输出，输出矩阵的 2^n 次幂的结果。每行 m 个数据，每个数据间用空格分开。评测机会自动过滤掉行尾空格以及最后的回车。
-   指令条数限制: 200000

## 样例

输入:

```
1
2
1
2
3
4
```

输出:

```
7 10
15 22
```

## 提交要求

-   请勿使用 `.globl main`。
-   不考虑延迟槽。
-   只需要提交 .asm 文件。
-   程序的初始地址设置（Mars->Settings->Memory Configuration）为 Compact,Data at Address 0。