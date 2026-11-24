LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY twenty_four_hour_clock_tb IS
END twenty_four_hour_clock_tb;

ARCHITECTURE tb OF twenty_four_hour_clock_tb IS

	COMPONENT twenty_four_hour_clock IS
	GENERIC (
			G_MAX       : integer RANGE 0 TO 999 := 999  -- max number
		);
	PORT (
		strt_in : IN std_logic; 
		rst_in  : IN std_logic;
		clk_in  : IN std_logic;
		plus_one: IN std_logic;
		
		ltn_in : IN std_logic;
		bln_in : IN std_logic;
		
		cntrl_in: IN std_logic_vector ( 2 DOWNTO 0 );		
		busy_out : OUT std_logic_vector ( 2 DOWNTO 0);

		seg_out: OUT std_logic_vector ( 41 DOWNTO 0)
	
		);	
END COMPONENT twenty_four_hour_clock;

	SIGNAL strt_in_tb, rst_in_tb, clk_in_tb, plus_one_tb, ltn_in_tb, bln_in_tb : std_logic := '0';
	SIGNAL cntrl_in_tb, busy_out_tb : std_logic_vector( 2 DOWNTO 0 ) := "000";
	SIGNAL seg_out_tb : std_logic_vector( 41 DOWNTO 0 ) := "000000000000000000000000000000000000000000";
	

BEGIN
	DUT: twenty_four_hour_clock
	GENERIC MAP (
		G_MAX => 999
		)
	PORT MAP (
		strt_in => strt_in_tb,
		rst_in  => rst_in_tb,
		clk_in  => clk_in_tb,
		plus_one => plus_one_tb,
		ltn_in   => ltn_in_tb,
		bln_in	 => bln_in_tb,
		cntrl_in => cntrl_in_tb,		
		busy_out => busy_out_tb,
		seg_out => seg_out_tb
		);

	clk_process : PROCESS
	BEGIN
		WAIT FOR 5 ns;
		WHILE now < 100000 ns LOOP
			clk_in_tb <= NOT clk_in_tb;
			WAIT FOR 1 ps;
		END LOOP;
		WAIT;
	END PROCESS clk_process;
	
	stim_proc : PROCESS
	BEGIN
	
	ltn_in_tb <= '1';
	bln_in_tb <= '0';
	
	-- Test cases
	-- Test case 1: reset the counter
	rst_in_tb <= '0';
	WAIT FOR 10 ns;
	rst_in_tb <= '1';
	WAIT FOR 10 ns;

	-- Test case 2: Start the counter
	strt_in_tb <= '1';
	WAIT FOR 1000 ns;
	strt_in_tb <= '0';
	WAIT FOR 1000 ns;

	-- Test case 3: Increment the counter manually
	cntrl_in_tb <= "001";
	plus_one_tb <= '1';
	WAIT FOR 100 ns;	

	-- second digit
	cntrl_in_tb <= "010";
	plus_one_tb <= '1';
	WAIT FOR 100 ns;

	-- third digit
	cntrl_in_tb <= "011";
	plus_one_tb <= '1';
	WAIT FOR 100 ns;

	-- third digit
	cntrl_in_tb <= "100";
	plus_one_tb <= '1';
	WAIT FOR 100 ns;

	-- third digit
	cntrl_in_tb <= "101";
	plus_one_tb <= '1';
	WAIT FOR 100 ns;

	-- third digit
	cntrl_in_tb <= "110";
	plus_one_tb <= '1';
	WAIT FOR 100 ns;

	-- no digit
	cntrl_in_tb <= "000";
	plus_one_tb <= '1';
	WAIT FOR 100 ns;

	-- Test case 5: Reset counter after counts
	rst_in_tb <= '0'; 
	WAIT FOR 1000 ns;			
	
	WAIT;
	END PROCESS;
END tb;


