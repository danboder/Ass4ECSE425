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
		dest_addr			: OUT STD_LOGIC_VECTOR(4 downto 0);
		predicted_outcome   : OUT STD_LOGIC
	);
END EX;

ARCHITECTURE behavior OF EX IS
-- ASSIGNS MODE INTEGER WITH VALUE BASED ON OPCODE AND FUNCTION FLAGS
COMPONENT ALU_control IS
	PORT(
	op_in, funct_in	: IN STD_LOGIC_VECTOR(5 downto 0);
	choose1, choose2: OUT STD_LOGIC;
	mode		: OUT INTEGER
	);
END COMPONENT;
-- INTERPRETS CONTROL BITS - MOST NOTABLY THE MODE INTEGER - AND PERFORMS THE NECESSARY ARITHMETIC OPERATION
COMPONENT ALU IS
	PORT(
	s_data, t_data	: IN STD_LOGIC_VECTOR(31 downto 0);
	equal		: IN STD_LOGIC;
	mode		: IN INTEGER;
	shamt		: IN STD_LOGIC_VECTOR(4 downto 0);
	jump_addr	: IN STD_LOGIC_VECTOR(25 downto 0);
	final_result		: OUT STD_LOGIC_VECTOR(31 downto 0);
	predicted_outcome   : OUT STD_LOGIC
	);
END COMPONENT;
-- CHOOSES (BASED ON MODE) THE CORRECT DESTINATION ADDRESS FOR THE FINAL RESULT
COMPONENT addr_mux IS
	PORT(
		mode	: IN INTEGER;
		t_addr, d_addr	: IN STD_LOGIC_VECTOR(4 downto 0);
		addr		: OUT STD_LOGIC_VECTOR(4 downto 0)
	);
END COMPONENT;
-- CHOOSES (BASED ON MODE) CORRECT EXTENSION OF THE IMMEDIATE VALUE
COMPONENT sign_mux IS
	PORT(
		mode	: IN INTEGER;
		zero, sign	: IN STD_LOGIC_VECTOR(31 downto 0);
		imm		: OUT STD_LOGIC_VECTOR(31 downto 0)
	);
END COMPONENT;
-- MULTIPLEXER FOR CHOOSING THE CORRECT OPERANDS (CHOOSE BITS SET BY ALU_CONTROL)
COMPONENT mux_2 IS
	PORT(
		choose		: IN STD_LOGIC;
		A,B		: IN STD_LOGIC_VECTOR(31 downto 0);
		C		: OUT STD_LOGIC_VECTOR(31 downto 0)
	);
END COMPONENT;
-- CHECKS IF OPERATION IS A LOAD (USED IN MEMORY STAGE)
COMPONENT if_load IS
	PORT(
		mode	: IN INTEGER;
		load	: OUT STD_LOGIC
	);
END COMPONENT;
-- COMPARES THE REGISTER VALUES (FOR USE IN BEQ AND BNE OPERATIONS)
COMPONENT comparator_32 IS
	PORT(
		A, B	: IN STD_LOGIC_VECTOR(31 downto 0);
		equal	: OUT STD_LOGIC
	);
END COMPONENT;
-- CHOOSES WRITE_BACK BIT (BASED ON MODE)
COMPONENT wb_control IS
	PORT(
	mode : IN INTEGER;
	choose : OUT STD_LOGIC
	);
END COMPONENT;


	SIGNAL choose1, choose2, eq_temp	: STD_LOGIC := '0';
	SIGNAL s_temp, t_temp, imm_temp		: STD_LOGIC_VECTOR(31 downto 0) := "00000000000000000000000000000000";
	SIGNAL mode_temp			: INTEGER := 0;
	--signal predicted_outcome : STD_LOGIC;
BEGIN
	CTL : ALU_control PORT MAP (op, funct, choose1, choose2, mode_temp);
	CMP : comparator_32 PORT MAP (s_data, t_data, eq_temp);
	IMM : sign_mux PORT MAP (mode_temp, zero, sign, imm_temp);
	ADD : addr_mux PORT MAP (mode_temp, t_addr, d_addr, dest_addr);
	M1 : mux_2 PORT MAP(choose1, s_data, PC, s_temp);
	M2 : mux_2 PORT MAP(choose2, t_data, imm_temp, t_temp);
	A1 : ALU PORT MAP (s_temp, t_temp, eq_temp, mode_temp, shamt, j_addr, result, predicted_outcome);
	WBC : wb_control PORT MAP(mode_temp, wb_choose);
	t_out <= t_data;
	equal <= eq_temp;
	mode <= mode_temp;
END behavior;