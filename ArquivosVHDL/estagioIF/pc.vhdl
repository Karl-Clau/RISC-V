-- Registrador de 32 bits com entradas PCin, clk, reset e saída PCout

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pc is
	Port (
    	pc_i : in std_logic_vector(31 downto 0);
    	clk: in std_logic;
        reset: in std_logic;

        pc_o: out std_logic_vector(31 downto 0)
    	);
end pc;

architecture Behavioral of pc is

begin

process(clk, reset)
begin
	if reset = '1' then pc_o <= X"00000000";
	else
		if clk'event and clk = '1' then
			pc_o <= pc_i;
		end if;
	end if;
end process;

end Behavioral;
