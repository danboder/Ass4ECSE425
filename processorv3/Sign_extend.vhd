LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Sign_extend IS
	PORT(
		Imm_in			: IN STD_LOGIC_VECTOR(15 downto 0);
		sign_ext, zero_ext	: OUT STD_LOGIC_VECTOR(31 downto 0)
	);
END Sign_extend;

ARCHITECTURE behavior OF Sign_extend IS
	signal MSB : STD_LOGIC:='0';
BEGIN
	ext_process : PROCESS(Imm_in) IS
	BEGIN
		--report "Sign extend value is" & integer'image(to_integer(unsigned(Imm_in)));
		MSB <= Imm_in(15);
		if MSB = '0' then
			sign_ext <= ("0000000000000000" & Imm_in);
		else
			sign_ext <= ("1111111111111111" & Imm_in);
		end if;
		zero_ext <= ("0000000000000000" & Imm_in);
	END PROCESS;
END behavior;
