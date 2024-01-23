# 设定时钟约束
create_clock -period 20.000 -name CLOCK_50    ;# 时钟周期为 20 ns，这里的 clk 是你设计中的时钟端口


derive_pll_clocks     ;# 推导所有时钟

derive_clock_uncertainty ;# 推导时钟不确定性