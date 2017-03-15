LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Split_32 IS
	PORT(
		instr				: IN STD_LOGIC_VECTOR(31 downto 0);
		j_addr				: OUT STD_LOGIC_VECTOR(25 downto 0);
		imm				: OUT STD_LOGIC_VECTOR(15 downto 0);
		op, funct 			: OUT STD_LOGIC_VECTOR(5 downto 0);
		s_addr, t_addr, d_addr, shamt	: OUT STD_LOGIC_VECTOR(4 downto 0)
	);
END Split_32;

ARCHITECTURE behavior OF Split_32 IS

BEGIN
	split_process : PROCESS(instr) IS
	BEGIN
		op <= instr(31 downto 26);
		j_addr <= instr(25 downto 0);
		imm <= instr(15 downto 0);
		s_addr <= instr(25 downto 21);
		t_addr <= instr(20 downto 16);
		d_addr <= instr(15 downto 11);
		shamt <= instr(10 downto 6);
		funct <= instr(5 downto 0);
	END PROCESS;
END behavior;