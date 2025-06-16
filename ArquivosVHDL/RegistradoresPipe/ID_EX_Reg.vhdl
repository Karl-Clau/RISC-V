library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ID_EX_Pipeline is
    Port (
        clk           : in  std_logic;
        reset         : in  std_logic;

        -- Control signals
        ALUOp_in      : in  std_logic_vector(1 downto 0);
        ALUSrc_in     : in  std_logic;
        memRead_in   : in  std_logic;
        memWrite_in  : in  std_logic;
        memToReg_in  : in  std_logic;
        regWrite_in  : in  std_logic;
        branch_in    : in  std_logic;
        jump_in      : in  std_logic;
        -- Data signals
        Rs1_data_in  : in  std_logic_vector(31 downto 0);
        Rs2_data_in  : in  std_logic_vector(31 downto 0);
        Imm_in : in  std_logic_vector(31 downto 0);
        Rs1_in         : in  std_logic_vector(4 downto 0);
        Rs2_in         : in  std_logic_vector(4 downto 0); 
        Rd_in         : in  std_logic_vector(4 downto 0);
        PC_in         : in std_logic_vector(31 downto 0);
        
        bubble        : in std_logic; -- Input de bubble síncrono

        -- Control outputs
        ALUOp_out     : out std_logic_vector(1 downto 0);
        ALUSrc_out    : out std_logic;
        memRead_out   : out std_logic;
        memWrite_out  : out std_logic;
        memToReg_out  : out std_logic;
        regWrite_out  : out std_logic;
        branch_out    : out std_logic;
        jump_out      : out std_logic;
        -- Data outputs
        Rs1_data_out       : out std_logic_vector(31 downto 0);
        Rs2_data_out       : out std_logic_vector(31 downto 0);
        Imm_out       : out std_logic_vector(31 downto 0);
        Rs1_out       : out std_logic_vector(4 downto 0);
        Rs2_out       : out std_logic_vector(4 downto 0);
        Rd_out        : out std_logic_vector(4 downto 0);
        PC_out        : out std_logic_vector(31 downto 0)
    );
end ID_EX_Pipeline;

architecture Behavioral of ID_EX_Pipeline is
begin
    process(clk, reset)
    begin
        if reset = '1' then
            -- On reset, clear all outputs
            ALUOp_out      <= (others => '0');
            ALUSrc_out     <= '0';
            memRead_out    <= '0';
            memWrite_out   <= '0';
            memToReg_out   <= '0';
            regWrite_out   <= '0';
            branch_out     <= '0';
            jump_out       <= '0';
            Rs1_data_out       <= (others => '0');
            Rs2_data_out       <= (others => '0');
            Imm_out       <= (others => '0');
            Rs1_out         <= (others => '0');
            Rs2_out         <= (others => '0');
            Rd_out         <= (others => '0');
            PC_out         <= (others => '0');
        elsif rising_edge(clk) then
            if bubble = '1' then
                ALUOp_out      <= (others => '0');
                ALUSrc_out     <= '0';
                memRead_out    <= '0';
                memWrite_out   <= '0';
                memToReg_out   <= '0';
                regWrite_out   <= '0';
                branch_out     <= '0';
                jump_out       <= '0';
                Rs1_data_out       <= (others => '0');
                Rs2_data_out       <= (others => '0');
                Imm_out       <= (others => '0');
                Rs1_out         <= (others => '0');
                Rs2_out         <= (others => '0');
                Rd_out         <= (others => '0');
                PC_out         <= (others => '0');
            else
                -- On clock edge, latch inputs to outputs
                ALUOp_out      <= ALUOp_in;
                ALUSrc_out     <= ALUSrc_in;
                memRead_out    <= memRead_in;
                memWrite_out   <= memWrite_in;
                memToReg_out   <= memToReg_in;
                regWrite_out   <= regWrite_in;
                branch_out     <= branch_in;
                jump_out       <= jump_in;
                Rs1_data_out       <= Rs1_data_in;
                Rs2_data_out       <= Rs2_data_in;
                Imm_out       <= Imm_in;
                Rs1_out         <= Rs1_in;
                Rs2_out         <= Rs2_in;
                Rd_out         <= Rd_in;
                PC_out <= PC_in;
            end if;
        end if;
    end process;
end Behavioral;
