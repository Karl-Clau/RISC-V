-- Funcao not simples

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity teste is
	Port (
    	a : in std_logic;
    	b : out std_logic
    	);
end teste;

architecture Behavioral of teste is

begin

process(a)
begin
    b <= not(a);
end process;

end Behavioral;
