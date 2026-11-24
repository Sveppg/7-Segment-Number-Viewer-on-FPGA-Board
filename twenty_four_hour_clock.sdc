# DE2-115 CLOCK_50: 50 MHz = 20 ns
create_clock -name clk_in -period 20.000 [get_ports {clk_in}]
derive_clock_uncertainty
