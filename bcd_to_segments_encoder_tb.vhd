LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY  bcd_to_segments_encoder_tb IS
   END bcd_to_segments_encoder_tb;

ARCHITECTURE tb OF bcd_to_segments_encoder_tb IS

   	

	SIGNAL s_ltn_in : std_logic;
	SIGNAL s_bln_in : std_logic;
	SIGNAL s_bcd_in : std_logic_vector(3 DOWNTO 0);
	SIGNAL s_a_out, s_b_out, s_c_out, s_d_out, s_e_out, s_f_out, s_g_out :  std_logic;

	COMPONENT bcd_to_segments_encoder IS
    PORT (  ltn_in : IN std_logic;                                            -- when '0' -> test mode, else normal mode
            bln_in : IN std_logic;                                            -- when in test mode: 1 sets all segments, 0 resets all segments
            bcd_in : IN std_logic_vector(3 DOWNTO 0);                         -- BCD input
            a_out, b_out, c_out, d_out, e_out, f_out, g_out : OUT std_logic   -- segments
         );
END COMPONENT bcd_to_segments_encoder;


BEGIN
   
   -- Verwendung der Komponente: Verknüpfung der Eingangssignale mit zuvor definierten Signalen
   unit_bcd_conv : bcd_to_segments_encoder 
	PORT MAP ( 
		ltn_in => s_ltn_in,
		bln_in => s_bln_in,
		bcd_in => s_bcd_in,
		a_out  => s_a_out,
		b_out  => s_b_out, 
 		c_out  => s_c_out,
		d_out  => s_d_out, 
		e_out  => s_e_out, 
		f_out  => s_f_out,
		g_out  => s_g_out 
                            );
   ---
   stim_proc : PROCESS
   BEGIN

      s_bcd_in(0) <= '0' AFTER   0 ns,
                     '1' AFTER  10 ns,
                     '0' AFTER  20 ns,
                     '1' AFTER  30 ns,

                     '0' AFTER  40 ns,
                     '1' AFTER  50 ns, 
                     '0' AFTER  60 ns,
                     '1' AFTER  70 ns,

                     '0' AFTER  80 ns,
                     '1' AFTER  90 ns, 
                     '0' AFTER 100 ns,
                     '1' AFTER 110 ns,
                   
                     '0' AFTER 120 ns,
                     '1' AFTER 130 ns, 
                     '0' AFTER 140 ns,
                     '1' AFTER 150 ns,
                     
                     '0' AFTER 160 ns,
                     '1' AFTER 170 ns,
                     '0' AFTER 180 ns,
                     '1' AFTER 190 ns,

                     '0' AFTER 200 ns,
                     '1' AFTER 210 ns, 
                     '0' AFTER 220 ns,
                     '1' AFTER 230 ns,

                     '0' AFTER 240 ns,
                     '1' AFTER 250 ns, 
                     '0' AFTER 260 ns,
                     '1' AFTER 270 ns,
                   
                     '0' AFTER 280 ns,
                     '1' AFTER 290 ns, 
                     '0' AFTER 300 ns,
                     '1' AFTER 310 ns;



    


    s_bcd_in(1) <=   '0' AFTER   0 ns,
                     '1' AFTER  20 ns, 
                     '0' AFTER  40 ns,
                     '1' AFTER  60 ns,
                   
                     '0' AFTER  80 ns,
                     '1' AFTER 100 ns, 
                     '0' AFTER 120 ns,
                     '1' AFTER 140 ns,
                     
                     '0' AFTER 160 ns,
                     '1' AFTER 180 ns, 
                     '0' AFTER 200 ns,
                     '1' AFTER 220 ns,
                   
                     '0' AFTER 240 ns,
                     '1' AFTER 260 ns, 
                     '0' AFTER 280 ns,
                     '1' AFTER 300 ns;
   

    s_bcd_in(2) <=   '0' AFTER   0 ns,
                     '1' AFTER  40 ns, 
                     '0' AFTER  80 ns,
                     '1' AFTER 120 ns,
                     
                     '0' AFTER 160 ns,
                     '1' AFTER 200 ns, 
                     '0' AFTER 240 ns,
                     '1' AFTER 280 ns;



   s_bcd_in(3) <=    '0' AFTER   0 ns,
                     '1' AFTER  80 ns,
                     
                     '0' AFTER 160 ns,
                     '1' AFTER 240 ns;  
                   

   s_ltn_in  <=    '1' AFTER   0 ns,
                   '0' AFTER 320 ns;
   
   s_bln_in  <=    '0' AFTER   0 ns,
                   '1' AFTER 160 ns,
                   '0' AFTER 320 ns,
                   '1' AFTER 480 ns;
						 
	WAIT FOR 1000 ns;


                   ---- End of testbench
   WAIT;
END PROCESS;

END tb;
