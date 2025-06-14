-- Registrador que guarda os dados necessários entre IF e ID. Esses dados são o valor de PC e a instrução da vez
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity IFID is
	Port (
    	PCin : in std_logic_vector(31 downto 0);
        INSTin: in std_logic_vector(31 downto 0);

    	clk: in std_logic;
        reset: in std_logic;

        PCout: out std_logic_vector(31 downto 0);
        INSTout: out std_logic_vector(31 downto 0)
    	);
end IFID;

architecture Behavioral of IFID is

begin

process(clk, reset)
begin
	if reset = '1' then
        PCout <= X"00000000";
        INSTout <= X"00000000";
	else
		if clk'event and clk = '1' then
			PCout <= PCin;
            INSTout <= INSTin;
		end if;
	end if;
end process;

end Behavioral;
