LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY binary_to_segments_tb IS
END ENTITY binary_to_segments_tb;

ARCHITECTURE tb OF binary_to_segments_tb IS
   
 -- Component declaration for DUT (Design Under Test)
    COMPONENT binary_to_segments
        GENERIC ( G_BCD_DIGITS : integer RANGE 1 TO 5 := 1;
                  G_INPUT_WIDTH : integer := 7
                );
        PORT (
            ltn_in : IN std_logic; 
            bln_in : IN std_logic;
            clk_in : IN std_logic;
            rst_in : IN std_logic;
            bin_in : IN std_logic_vector (G_INPUT_WIDTH - 1 DOWNTO 0 );
            sta_in : IN std_logic;
            a_out,  b_out, c_out, d_out, e_out, f_out, g_out : OUT std_logic;
            busy_out : OUT std_logic
        );
    END COMPONENT;

    -- Signals for testbench
    SIGNAL ltn_tb       : std_logic := '0';
    SIGNAL bln_tb       : std_logic := '0';
    SIGNAL clk_tb       : std_logic := '0';
    SIGNAL rst_tb       : std_logic := '0';
    SIGNAL bin_tb       : std_logic_vector(6 DOWNTO 0) := "0000000";
    SIGNAL sta_tb       : std_logic := '0';
    
    SIGNAL a_tb, b_tb, c_tb, d_tb, e_tb, f_tb, g_tb : std_logic;
    SIGNAL busy_out     : std_logic;

BEGIN

    -- Instantiate the DUT
    DUT: binary_to_segments
    GENERIC MAP (
        G_BCD_DIGITS  => 1,
        G_INPUT_WIDTH => 7
    )
    PORT MAP (
        ltn_in    => ltn_tb,
        bln_in    => bln_tb,
        clk_in    => clk_tb,
        rst_in    => rst_tb,
        bin_in    => bin_tb,
        sta_in    => sta_tb,
        a_out     => a_tb,
        b_out     => b_tb,
        c_out     => c_tb,
        d_out     => d_tb,
        e_out     => e_tb,
        f_out     => f_tb,
        g_out     => g_tb,
        busy_out  => busy_out
    );

    -- Clock process
    clk_process: PROCESS
    BEGIN
        WAIT FOR 10 ps; -- adjust the clock period as needed
        clk_tb <= NOT clk_tb;
    END PROCESS clk_process;

    -- Stimulus process
    stimulus: PROCESS
    BEGIN
        rst_tb <= '1';  -- Reset active
        WAIT FOR 5 ns;
        rst_tb <= '0';  -- Reset inactive
        WAIT FOR 10 ns;

	-- Enable function
	ltn_tb <= '1';
	bln_tb <= '0';

        -- Test cases here
        -- Example test: Input "0001010"    --> expect 0, because only one digit
        bin_tb <= "0001010";
        sta_tb <= '1';  -- Start conversion
        WAIT FOR 10 ns;
        sta_tb <= '0';  -- Stop conversion
	
	-- Example test: Input "0000001"    --> expected 1
        bin_tb <= "0000001";
        sta_tb <= '1';  -- Start conversion
        WAIT FOR 10 ns;
        sta_tb <= '0';  -- Stop conversion

	-- Example test: Input "0000010"     -- expected 2
        bin_tb <= "0000010";
        sta_tb <= '1';  -- Start conversion
        WAIT FOR 10 ns;
        sta_tb <= '0';  -- Stop conversion

	-- Example test: Input "0000010"     -- expected 3
        bin_tb <= "0000011";
        sta_tb <= '1';  -- Start conversion
        WAIT FOR 10 ns;
        sta_tb <= '0';  -- Stop conversion
	
	-- Example test: Input "0000010"     -- expected 4
        bin_tb <= "0000100";
        sta_tb <= '1';  -- Start conversion
        WAIT FOR 10 ns;
        sta_tb <= '0';  -- Stop conversion
       
        WAIT;
    END PROCESS stimulus;

END tb;

