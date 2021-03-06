LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY EX IS
	PORT(
		PC, s_data, t_data, zero, sign	: IN STD_LOGIC_VECTOR(31 downto 0);
		op, funct			: IN STD_LOGIC_VECTOR(5 downto 0);
		shamt, t_addr, d_addr		: IN STD_LOGIC_VECTOR(4 downto 0);
		j_addr				: IN STD_LOGIC_VECTOR(25 downto 0);
		mode				: OUT INTEGER;
		equal				: OUT STD_LOGIC;
		result, t_out			: OUT STD_LOGIC_VECTOR(31 downto 0);
		wb_choose			: OUT STD_LOGIC;
		dest_addr			: OUT STD_LOGIC_VECTOR(4 downto 0)
	);
END EX;

ARCHITECTURE behavior OF EX IS

COMPONENT ALU_control IS
	PORT(
	op_in, funct_in	: IN STD_LOGIC_VECTOR(5 downto 0);
	choose1, choose2: OUT STD_LOGIC;
	mode		: OUT INTEGER
	);
END COMPONENT;

COMPONENT ALU IS
	PORT(
	s_data, t_data	: IN STD_LOGIC_VECTOR(31 downto 0);
	equal		: IN STD_LOGIC;
	mode		: IN INTEGER;
	shamt		: IN STD_LOGIC_VECTOR(4 downto 0);
	jump_addr	: IN STD_LOGIC_VECTOR(25 downto 0);
	final_result		: OUT STD_LOGIC_VECTOR(31 downto 0)
	);
END COMPONENT;

COMPONENT addr_mux IS
	PORT(
		mode	: IN INTEGER;
		t_addr, d_addr	: IN STD_LOGIC_VECTOR(4 downto 0);
		addr		: OUT STD_LOGIC_VECTOR(4 downto 0)
	);
END COMPONENT;

COMPONENT sign_mux IS
	PORT(
		mode	: IN INTEGER;
		zero, sign	: IN STD_LOGIC_VECTOR(31 downto 0);
		imm		: OUT STD_LOGIC_VECTOR(31 downto 0)
	);
END COMPONENT;

COMPONENT mux_2 IS
	PORT(
		choose		: IN STD_LOGIC;
		A,B		: IN STD_LOGIC_VECTOR(31 downto 0);
		C		: OUT STD_LOGIC_VECTOR(31 downto 0)
	);
END COMPONENT;

COMPONENT if_load IS
	PORT(
		mode	: IN INTEGER;
		load	: OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT comparator_32 IS
	PORT(
		A, B	: IN STD_LOGIC_VECTOR(31 downto 0);
		equal	: OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT wb_control IS
	PORT(
	mode : IN INTEGER;
	choose : OUT STD_LOGIC
	);
END COMPONENT;


	SIGNAL choose1, choose2, eq_temp	: STD_LOGIC := '0';
	SIGNAL s_temp, t_temp, imm_temp		: STD_LOGIC_VECTOR(31 downto 0) := "00000000000000000000000000000000";
	SIGNAL mode_temp			: INTEGER := 0;
BEGIN
	CTL : ALU_control PORT MAP (op, funct, choose1, choose2, mode_temp);
	CMP : comparator_32 PORT MAP (s_data, t_data, eq_temp);
	IMM : sign_mux PORT MAP (mode_temp, zero, sign, imm_temp);
	ADD : addr_mux PORT MAP (mode_temp, t_addr, d_addr, dest_addr);
	M1 : mux_2 PORT MAP(choose1, s_data, PC, s_temp);
	M2 : mux_2 PORT MAP(choose2, t_data, imm_temp, t_temp);
	A1 : ALU PORT MAP (s_data, t_data, eq_temp, mode_temp, shamt, j_addr, result);
	WBC : wb_control PORT MAP(mode_temp, wb_choose);
	t_out <= t_data;
	equal <= eq_temp;
	mode <= mode_temp;
END behavior;