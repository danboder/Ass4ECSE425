LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY branch_control IS
	PORT(
		Choose		: IN STD_LOGIC;
		Branch_Addr	: IN STD_LOGIC_VECTOR(31 downto 0);
		Addend		: OUT INTEGER
	);
END branch_control;

ARCHITECTURE behavior of branch_control IS
BEGIN

choose_process : PROCESS(Choose,Branch_Addr)

BEGIN
	REPORT "FETCH";
	if choose = '0' then
		Addend <= 1;
	else
		Addend <= 1 + to_integer(signed(Branch_Addr));
	end if;
END process;
END behavior;
