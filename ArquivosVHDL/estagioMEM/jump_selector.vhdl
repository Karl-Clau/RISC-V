library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pc_target_selector is
    Port (
        jump          : in  STD_LOGIC;
        branch        : in  STD_LOGIC;
        jump_target   : in  STD_LOGIC_VECTOR(31 downto 0);
        branch_target : in  STD_LOGIC_VECTOR(31 downto 0);
        target_address: out STD_LOGIC_VECTOR(31 downto 0);
        pc_sel        : out STD_LOGIC
    );
end pc_target_selector;

architecture Behavioral of pc_target_selector is
begin

    -- MUX for target address
    target_address <= jump_target when (jump = '1') 
                      else branch_target;

    -- PC select signal logic
    pc_sel <= jump or branch;

end Behavioral;
