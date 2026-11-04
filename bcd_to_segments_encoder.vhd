--
-- Authors:
--
-- Implement a BCD to seven segment decoder.
--
-- The following truth table shows the required functionality:
-- +-------------------------------------------------------------------------+
-- | decimal in | ltn_in | bln_in |  bcd_in |  segments_out |  seven segment |
-- |            |        |        |         | a b c d e f g | should display |
-- +-------------------------------------------------------------------------+
-- |     0      |    1   |    0   | 0 0 0 0 | 0 0 0 0 0 0 1 |        0       |
-- |     1      |    1   |    0   | 0 0 0 1 | 1 0 0 1 1 1 1 |        1       |
-- |     2      |    1   |    0   | 0 0 1 0 | 0 0 1 0 0 1 0 |        2       |
-- |     3      |    1   |    0   | 0 0 1 1 | 0 0 0 0 1 1 0 |        3       |
-- |     4      |    1   |    0   | 0 1 0 0 | 1 0 0 1 1 0 0 |        4       |
-- |     5      |    1   |    0   | 0 1 0 1 | 0 1 0 0 1 0 0 |        5       |
-- |     6      |    1   |    0   | 0 1 1 0 | 0 1 0 0 0 0 0 |        6       |
-- |     7      |    1   |    0   | 0 1 1 1 | 0 0 0 1 1 1 1 |        7       |
-- |     8      |    1   |    0   | 1 0 0 0 | 0 0 0 0 0 0 0 |        8       |
-- |     9      |    1   |    0   | 1 0 0 1 | 0 0 0 0 1 0 0 |        9       |
-- |     10     |    1   |    0   | 1 0 1 0 | 1 1 1 1 1 1 1 |                |
-- |     11     |    1   |    0   | 1 0 1 1 | 1 1 1 1 1 1 1 |                |
-- |     12     |    1   |    0   | 1 1 0 0 | 1 1 1 1 1 1 1 |                |
-- |     13     |    1   |    0   | 1 1 0 1 | 1 1 1 1 1 1 1 |                |
-- |     14     |    1   |    0   | 1 1 1 0 | 1 1 1 1 1 1 1 |                |
-- |     15     |    1   |    0   | 1 1 1 1 | 1 1 1 1 1 1 1 |                |
-- |     16     |    0   |    1   | x x x x | 0 0 0 0 0 0 0 |        8       |
-- |     17     |    0   |    0   | x x x x | 1 1 1 1 1 1 1 |                |
-- +-------------------------------------------------------------------------+
--
-- The design should not implement any registers.
--
------------------------------------------------------------------------------
------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


------------------------------------------------------------------------------
-- entity
------------------------------------------------------------------------------

ENTITY bcd_to_segments_encoder IS
    PORT (  ltn_in : in std_logic;                                            -- when '0' -> test mode, else normal mode
            bln_in : in std_logic;                                            -- when in test mode: 1 sets all segments, 0 resets all segments
            bcd_in : in std_logic_vector(3 downto 0);                         -- BCD input
            a_out, b_out, c_out, d_out, e_out, f_out, g_out : out std_logic   -- segments
	  );
END ENTITY bcd_to_segments_encoder;


------------------------------------------------------------------------------
-- architecture
------------------------------------------------------------------------------
ARCHITECTURE behav OF bcd_to_segments_encoder IS

------------------------------------------------------------------------------
-- signals
------------------------------------------------------------------------------

BEGIN

------------------------------------------------------------------------------
-- processes
------------------------------------------------------------------------------
    PROCESS(ltn_in, bln_in, bcd_in)
    BEGIN
------------------------------------------------------------------------------
-- first case: normal function 
------------------------------------------------------------------------------
	
	IF ltn_in = '1' AND bln_in = '0' THEN
		
		-- output a
		a_out <= ( (NOT bcd_in(0)) AND (NOT bcd_in(1)) AND 	  bcd_in(2)		       			   ) OR
					( (    bcd_in(0)) AND (NOT bcd_in(1)) AND (NOT bcd_in(2)) AND (NOT bcd_in(3)) ) OR 
					(  			               bcd_in(1)                      AND      bcd_in(3)  ) OR
					(        		    			bcd_in(2)  AND      							 bcd_in(3)  );
		
		-- output b
		b_out <= (      		   				bcd_in(1)  AND     			   			 bcd_in(3)  ) OR
					(      bcd_in(0)  AND (NOT bcd_in(1)) AND 		bcd_in(2)		               ) OR
					( (NOT bcd_in(0)) AND      bcd_in(1)  AND      	bcd_in(2)		     				) OR
					( 																bcd_in(2)  AND     bcd_in(3)  );

		-- output c
		c_out <= ( 			   					bcd_in(1)  AND			    				    bcd_in(3)  ) OR
				   (														     bcd_in(2)  AND      bcd_in(3)  ) OR
					( (NOT bcd_in(0)) AND      bcd_in(1)  AND (NOT bcd_in(2))		               );

		-- output d
		d_out <= ( 	    bcd_in(0)  AND (NOT bcd_in(1)) AND (NOT bcd_in(2)) AND (NOT bcd_in(3)) ) OR
					( (NOT bcd_in(0)) AND (NOT bcd_in(1)) AND      bcd_in(2)		                  ) OR
					( 		 bcd_in(0)  AND	   bcd_in(1)  AND 	  bcd_in(2)  AND (NOT bcd_in(3)) ) OR
					( 			    				   bcd_in(1)  AND		        	    		    bcd_in(3)  ) OR
					(        		    									  bcd_in(2)  AND      bcd_in(3)  );

		-- output e
		e_out <= ( 	    bcd_in(0) 							       												) OR
					(  		             (NOT bcd_in(1)) AND 	  bcd_in(2)		      				) OR
					(			    			      bcd_in(1)  AND 			  					 bcd_in(3)  );

		-- output f
		f_out <= (      bcd_in(0)   AND 		  			       (NOT bcd_in(2)) AND (NOT bcd_in(3)) ) OR
					( 			    					bcd_in(1)  AND  (NOT bcd_in(2)) 		                ) OR
					( 		 bcd_in(0)   AND     bcd_in(1) 					   							    ) OR
					( 					       									 bcd_in(2) AND      bcd_in(3)  );



			 

		-- output g
		g_out <= (		     				  (NOT bcd_in(1)) AND (NOT bcd_in(2)) AND (NOT bcd_in(3)) ) OR
			      (  	bcd_in(0)  AND 	    bcd_in(1)  AND	   bcd_in(2) 		                ) OR
				   (																bcd_in(2)  AND 	    bcd_in(3)) OR
			      ( 								    bcd_in(1)  AND 			    					 bcd_in(3));

	-- second case: all segments on
	ELSIF ltn_in = '0' AND bln_in = '1' THEN
		a_out <= '0';
		b_out <= '0';
		c_out <= '0';
		d_out <= '0';
		e_out <= '0';
		f_out <= '0';
		g_out <= '0';

	-- third case: all segments off
	ELSIF ltn_in = '0' AND bln_in = '0' THEN
		a_out <= '1';
		b_out <= '1';
		c_out <= '1';
		d_out <= '1';
		e_out <= '1';
		f_out <= '1';
		g_out <= '1';

	-- all other cases 
	ELSE
		a_out <= 'X';
		b_out <= 'X';
		c_out <= 'X';
		d_out <= 'X';
		e_out <= 'X';
		f_out <= 'X';
		g_out <= 'X';   

	END IF;
    END PROCESS;
END ARCHITECTURE behav;
