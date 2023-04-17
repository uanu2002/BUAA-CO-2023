设计一个支持**addu, subu, ori, lw, sw, beq, lui, nop, jal, jr, j**指令的单周期CPU。

不处理冲突冒险：[cpu_pipeline.circ](./cpu_pipeline.circ)

处理冲突冒险：[cpu_pipeline.circ-转发阻塞](./cpu_pipeline-转发阻塞.circ)

课下和课上对冲突冒险不作要求（即数据不出现冲突冒险），但提供冲突冒险的测试窗口。

具体实现见**设计文档**：[流水线CPU设计文档](./流水线CPU设计文档.md)