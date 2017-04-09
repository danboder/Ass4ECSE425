LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY pipelined_processor_tb IS
END pipelined_processor_tb;

ARCHITECTURE behavior OF pipelined_processor_tb IS

COMPONENT pipelined_processor IS
	PORT(
	clk, enable, reset, done	: IN STD_LOGIC
	);
END COMPONENT;
CONSTANT clk_period : time := 1 ns;
SIGNAL clk, enable, reset, done : STD_LOGIC;
BEGIN

P1 : pipelined_processor PORT MAP (clk, enable, reset, done);

clk_process : PROCESS
BEGIN
	clk <= '0';
	wait for clk_period/2;
	clk <= '1';
	wait for clk_period/2;
end PROCESS;

test_process : PROCESS
BEGIN

enable <= '0';
reset <= '1';
done <= '0';
wait for clk_period;
reset <= '0';
enable <= '1';

wait for 90 ns;
done <= '1';
wait;
END PROCESS;

END behavior;

