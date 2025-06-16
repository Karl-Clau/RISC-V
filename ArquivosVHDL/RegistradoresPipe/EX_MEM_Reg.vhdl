library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity EX_MEM_Pipeline is
    Port (
        clk          : in  std_logic;
        reset        : in  std_logic;

        -- Control signals
        MemRead_in   : in  std_logic;
        MemWrite_in  : in  std_logic;
        MemToReg_in  : in  std_logic;
        RegWrite_in  : in  std_logic;
        branch_in    : in  std_logic;
        jump_in      : in  std_logic;
        -- Data signals
        ALUResult_in : in  std_logic_vector(31 downto 0);
        WriteData_in : in  std_logic_vector(31 downto 0);
        Rd_in       : in  std_logic_vector(4 downto 0);
        zero_in       : in  std_logic;
        branch_target_in : in  std_logic_vector(31 downto 0);

        bubble       : in std_logic; -- Entrada de bubble síncrona

        -- Outputs to MEM stage
        MemRead_out  : out std_logic;
        MemWrite_out : out std_logic;
        MemToReg_out : out std_logic;
        RegWrite_out : out std_logic;
        ALUResult_out: out std_logic_vector(31 downto 0);
        WriteData_out: out std_logic_vector(31 downto 0);
        Rd_out       : out std_logic_vector(4 downto 0);
        branch_out   : out std_logic;
        jump_out     : out std_logic;
        zero_out     : out std_logic;
        branch_target_out : out std_logic_vector(31 downto 0)
    );
end EX_MEM_Pipeline;

architecture Behavioral of EX_MEM_Pipeline is
begin
    process(clk, reset)
    begin
        if reset = '1' then
            MemRead_out   <= '0';
            MemWrite_out  <= '0';
            RegWrite_out  <= '0';
            MemToReg_out  <= '0';
            ALUResult_out <= (others => '0');
            WriteData_out <= (others => '0');
            Rd_out   <= (others => '0');
            jump_out      <= '0';
            branch_out    <= '0';
            zero_out      <= '0';
            branch_target_out <= (others => '0');
        elsif rising_edge(clk) then
            if bubble = '1' then

                MemRead_out   <= '0';
                MemWrite_out  <= '0';
                RegWrite_out  <= '0';
                MemToReg_out  <= '0';
                ALUResult_out <= (others => '0');
                WriteData_out <= (others => '0');
                Rd_out   <= (others => '0');
                jump_out      <= '0';
                branch_out    <= '0';
                zero_out      <= '0';
                branch_target_out <= (others => '0');

            else
                MemRead_out   <= MemRead_in;
                MemWrite_out  <= MemWrite_in;
                RegWrite_out  <= RegWrite_in;
                MemToReg_out  <= MemToReg_in;
                ALUResult_out <= ALUResult_in;
                WriteData_out <= WriteData_in;
                Rd_out   <= Rd_in;
                jump_out      <= jump_in;
                branch_out    <= branch_in;
                zero_out      <= zero_in;
                branch_target_out <= branch_target_in;
            end if;
        end if;
    end process;
end Behavioral;
