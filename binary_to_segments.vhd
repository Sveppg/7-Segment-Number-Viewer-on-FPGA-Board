LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY binary_to_segments IS
	GENERIC ( G_BCD_DIGITS : integer RANGE 1 TO 5 := 3;                       -- number of output digits
              	  G_INPUT_WIDTH : integer := 7                                    -- input bit width
		);
    
    	PORT    (   
		ltn_in : IN std_logic;
		bln_in : IN std_logic;
		clk_in : IN std_logic;
		rst_in : IN std_logic;
		bin_in : IN std_logic_vector (G_INPUT_WIDTH - 1 DOWNTO 0 );
		sta_in : IN std_logic;

		segment_out : OUT std_logic_vector ( G_BCD_DIGITS * 7 - 1 DOWNTO 0);
		-- a_out,  b_out, c_out, d_out, e_out, f_out, g_out : OUT std_logic;
		busy_out : OUT std_logic
          );
END ENTITY binary_to_segments;

ARCHITECTURE Struct of binary_to_segments IS


	COMPONENT bcd_to_segments_encoder IS
  		  PORT (  ltn_in : IN std_logic;                                            -- when '0' -> test mode, else normal mode
 		          bln_in : IN std_logic;                                            -- when in test mode: 1 sets all segments, 0 resets all segments
  		          bcd_in : IN std_logic_vector( 3 DOWNTO 0 );                         -- BCD input
           		  a_out, b_out, c_out, d_out, e_out, f_out, g_out : OUT std_logic   -- segments
	  		);
	END COMPONENT bcd_to_segments_encoder;

	COMPONENT binary_to_bcd IS
    		GENERIC ( G_BCD_DIGITS : integer RANGE 1 TO 5 := 2;                       -- number of output digits
         		    G_INPUT_WIDTH : integer := 7                                    -- input bit width
		        );
    		PORT    ( clk_in    : IN std_logic;                                          -- clock input
              		 rst_in    : IN std_logic;                                          -- reset input
            		 binary_in : IN std_logic_vector(G_INPUT_WIDTH-1 DOWNTO 0);      -- binary input, to be converted into BCD
						 start_in  : IN std_logic;                                        -- pull high to start conversion, control signal
          		    bcd_out   : OUT std_logic_vector( G_BCD_DIGITS * 4 -  1 DOWNTO 0);    -- BCD output (for example: G_BCD_DIGITS = 2, bcd_out = (bcd_1(3), bcd_1(2), bcd_1(1), bcd_1(0), bcd_0(3), bcd_0(2), bcd_0(1), bcd_0(0)))
          		    busy_out  : OUT std_logic                                        -- '1' when currently converting, '0' when not, control signal
		        );
	END COMPONENT binary_to_bcd;


SIGNAL s_connect : std_logic_vector
    ((G_BCD_DIGITS * 4 - 1) DOWNTO 0);

SIGNAL s_start : std_logic;

BEGIN

    -- KEY1 ist aktiv LOW
    s_start <= NOT sta_in;

    u_bin_bcd : binary_to_bcd
    GENERIC MAP (
        G_BCD_DIGITS  => 3,
        G_INPUT_WIDTH => 7
    )
    PORT MAP (
        clk_in    => clk_in,
        rst_in    => rst_in,
        binary_in => bin_in,
        start_in  => s_start,

        bcd_out   => s_connect,
        busy_out  => busy_out
   );
	
	
	u_bcd_seg_01 : bcd_to_segments_encoder
        PORT MAP (
		ltn_in => ltn_in,
      bln_in => bln_in,
		bcd_in => s_connect ( 3 DOWNTO 0),
		a_out  => segment_out(0),
		b_out  => segment_out(1),
		c_out  => segment_out(2),
		d_out  => segment_out(3),
		e_out  => segment_out(4),
		f_out  => segment_out(5),
		g_out  => segment_out(6)
		);
		
	u_bcd_seg_02 : bcd_to_segments_encoder
        PORT MAP (
		ltn_in => ltn_in,
      bln_in => bln_in,
		bcd_in => s_connect ( 7 DOWNTO 4),
		a_out  => segment_out(7),
		b_out  => segment_out(8),
		c_out  => segment_out(9),
		d_out  => segment_out(10),
		e_out  => segment_out(11),
		f_out  => segment_out(12),
		g_out  => segment_out(13)
		);
		
		u_bcd_seg_03 : bcd_to_segments_encoder
        PORT MAP (
		ltn_in => ltn_in,
      bln_in => bln_in,
		bcd_in => s_connect ( 11 DOWNTO 8),
		a_out  => segment_out(14),
		b_out  => segment_out(15),
		c_out  => segment_out(16),
		d_out  => segment_out(17),
		e_out  => segment_out(18),
		f_out  => segment_out(19),
		g_out  => segment_out(20)
		);
		
		
END Struct;
