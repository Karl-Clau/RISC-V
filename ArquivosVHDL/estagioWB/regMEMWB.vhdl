-- Registrador que guarda os dados necessários entre MEM e WB. Esses dados são:
-- A flag MemToReg, calculada lá em ID e propagada pela pipeline
-- O código do registrador Rd, também calculado lá em ID e propagado
-- ALU_result, o resultado da operação da ULA, calculado em EX e propagado por MEM
-- Read_data, o valor que foi lido na memória no estágio MEM


-- JA ESTA PRESENTE EM EX_MEM_Reg.vhdl

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MEM_WB_pipeline is
	Port (
    	clk: in std_logic;
        reset: in std_logic;

		memToReg_in: in std_logic;
		Rd_in: in std_logic_vector(4 downto 0);

		ALUresult_in: in std_logic_vector(31 downto 0);
		Read_data_in: in std_logic_vector(31 downto 0);

        memToReg_out: out std_logic;
		Rd_out: out std_logic_vector(4 downto 0);

		ALUresult_out: out std_logic_vector(31 downto 0);
		Read_data_out: out std_logic_vector(31 downto 0)
    	);
end MEM_WB_pipeline;

architecture Behavioral of MEM_WB_pipeline is

begin

process(clk, reset)
begin
	if reset = '1' then
        memToReg_out <= '0';
		Rd_out <= '00000';

		ALU_result_out <= X"00000000";
		Read_data_out <= X"00000000";
	else
		if clk'event and clk = '1' then
			memToReg_out <= memToReg_in;
			Rd_out <= Rd_in;

			ALU_result_out <= ALU_result_in;
			Read_data_out <= Read_data_in;
		end if;
	end if;
end process;

end Behavioral;
