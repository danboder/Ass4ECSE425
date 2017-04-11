LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY branch_predictor_tb IS
END branch_predictor_tb;

ARCHITECTURE behaviour OF branch_predictor_tb IS

--Declare the component that you are testing:
    COMPONENT predictor IS
        PORT (
		reset: in std_logic;
		clk  : in std_logic;
     		taken: in std_logic;
     		predicted_outcome: out std_logic
        );
    END COMPONENT;

    --all the input signals with initial values
    signal clk : std_logic := '0';
    constant clk_period : time := 1 ns;
    signal reset : std_logic;
    signal taken : std_logic;
    signal predicted_outcome : std_logic;

BEGIN

    --dut => Device Under Test
    dut: predictor
                PORT MAP(
                    reset,
                    clk,
                    taken,
                    predicted_outcome
                );

    clk_process : process
    BEGIN
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    test_process : process
    BEGIN
        
	taken <= '1';
	wait for 1 * clk_period;
	taken <= '1';
	wait for 1 * clk_period;
	taken <= '1';
	
	--report "output" & std_logic'image(predicted_outcome);
	
	
	
	

    END PROCESS;

 
END;
