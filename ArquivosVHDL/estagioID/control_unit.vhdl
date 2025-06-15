library ieee;
use ieee.std_logic_1164.all;

entity control_unit is
    port (
        -- Inputs
        reset       : in  std_logic;              -- Asynchronous reset signal
        opcode      : in  std_logic_vector(6 downto 0); -- 7-bit opcode from the instruction

        -- Outputs: Control signals for the datapath
        reg_write   : out std_logic;              -- Enable writing to the register file
        mem_to_reg  : out std_logic;              -- Selects if data from memory goes to the register file (for loads)
        mem_read    : out std_logic;              -- Enables reading from data memory
        mem_write   : out std_logic;              -- Enables writing to data memory
        alu_src     : out std_logic;              -- Selects the second ALU source:
                                                  -- '0' = rs2 data (for R-type)
                                                  -- '1' = immediate (for I, S, B, U, J-types)
        branch      : out std_logic;              -- Indicates a conditional branch instruction
        jump        : out std_logic;              -- Indicates an unconditional jump instruction (JAL, JALR)
        alu_op      : out std_logic_vector(1 downto 0) -- Controls the ALU's main operation:
                                                  -- "00" = Add (for Loads/Stores/AUIPC/LUI/JAL/JALR address calc or pass-through)
                                                  -- "01" = Subtract (for Branches for comparison)
                                                  -- "10" = R-type operation (further decoded by funct3/funct7)
                                                  -- "11" = I-type operation (further decoded by funct3)
    );
end entity control_unit;

architecture behavioral of control_unit is
    -- Define the opcodes for different instruction types as constants for readability
    constant R_TYPE_OP   : std_logic_vector(6 downto 0) := "0110011"; -- OP (e.g., ADD, SUB, AND, OR, XOR)
    constant I_TYPE_OP   : std_logic_vector(6 downto 0) := "0010011"; -- OP-IMM (e.g., ADDI, ANDI, ORI)
    constant L_TYPE_OP   : std_logic_vector(6 downto 0) := "0000011"; -- LOAD (e.g., LW)
    constant S_TYPE_OP   : std_logic_vector(6 downto 0) := "0100011"; -- STORE (e.g., SW)
    constant B_TYPE_OP   : std_logic_vector(6 downto 0) := "1100011"; -- BRANCH (e.g., BEQ, BNE)
    constant JAL_OP      : std_logic_vector(6 downto 0) := "1101111"; -- JAL (Jump and Link)
    constant JALR_OP     : std_logic_vector(6 downto 0) := "1100111"; -- JALR (Jump and Link Register)
    constant LUI_OP      : std_logic_vector(6 downto 0) := "0110111"; -- LUI (Load Upper Immediate)
    constant AUIPC_OP    : std_logic_vector(6 downto 0) := "0010111"; -- AUIPC (Add Upper Immediate to PC)

begin

    -- Main control logic process.
    -- This process is sensitive to both 'reset' and 'opcode'.
    -- All output signals must be assigned within this single process to avoid latches.
    process(reset, opcode)
    begin
        -- Handle asynchronous reset with highest priority.
        -- When 'reset' is '1', all control signals are forced to their inactive state.
        if reset = '1' then
            reg_write  <= '0';
            mem_to_reg <= '0';
            mem_read   <= '0';
            mem_write  <= '0';
            alu_src    <= '0';
            branch     <= '0';
            jump       <= '0';
            alu_op     <= "00"; -- Default ALU operation (e.g., add or pass-through)
        else
            -- Default assignments for all control signals when not under reset.
            -- This ensures that for any opcode not explicitly covered in the case
            -- statement (or before an opcode is processed), signals have a known,
            -- safe default (e.g., NOP-like behavior, no writes, no branches/jumps).
            reg_write  <= '0';
            mem_to_reg <= '0';
            mem_read   <= '0';
            mem_write  <= '0';
            alu_src    <= '0';
            branch     <= '0';
            jump       <= '0';
            alu_op     <= "00"; -- Default to "00" (Add/Pass-through) for ALU

            -- Use a case statement to decode the opcode and assert specific control signals.
            case opcode is
                -- R-Type instructions (e.g., ADD, SUB, AND, OR)
                -- Perform register-to-register operations, write result back to register file.
                when R_TYPE_OP =>
                    reg_write  <= '1';     -- Enable write to register file
                    alu_src    <= '0';     -- Second ALU operand comes from rs2 (register value)
                    alu_op     <= "10";    -- ALU performs R-type specific operation (decoded by ALU Control)

                -- I-Type instructions (Arithmetic/Logical with Immediate, excluding Loads/JALR)
                -- (e.g., ADDI, ANDI, ORI)
                -- Perform operation with immediate, write result back to register file.
                when I_TYPE_OP =>
                    reg_write  <= '1';     -- Enable write to register file
                    alu_src    <= '1';     -- Second ALU operand comes from immediate
                    alu_op     <= "11";    -- ALU performs I-type specific operation (decoded by ALU Control)

                -- Load instructions (I-type, e.g., LW)
                -- Calculate memory address using immediate, read from memory, write to register file.
                when L_TYPE_OP =>
                    reg_write  <= '1';     -- Enable write to register file
                    mem_to_reg <= '1';     -- Data from memory is written to reg file
                    mem_read   <= '1';     -- Enable memory read
                    alu_src    <= '1';     -- Second ALU operand is immediate (for address calculation)
                    alu_op     <= "00";    -- ALU performs addition (base register + immediate offset)

                -- Store instructions (S-type, e.g., SW)
                -- Calculate memory address using immediate, write to memory.
                when S_TYPE_OP =>
                    mem_write  <= '1';     -- Enable memory write
                    alu_src    <= '1';     -- Second ALU operand is immediate (for address calculation)
                    alu_op     <= "00";    -- ALU performs addition (base register + immediate offset)

                -- Branch instructions (B-type, e.g., BEQ, BNE)
                -- Compare two registers, enable branch if condition met.
                when B_TYPE_OP =>
                    branch     <= '1';     -- Indicate a branch instruction
                    alu_op     <= "01";    -- ALU performs subtraction (for comparison)

                -- LUI (Load Upper Immediate)
                -- Loads a 20-bit immediate into the upper 20 bits of a register, clearing lower 12.
                when LUI_OP =>
                    reg_write  <= '1';     -- Enable write to register file
                    alu_src    <= '1';     -- Immediate is used by ALU (often conceptually for a pass-through or add 0)
                    alu_op     <= "00";    -- ALU performs addition (effectively passes the immediate)

                -- AUIPC (Add Upper Immediate to PC)
                -- Adds a 20-bit immediate (shifted) to the PC, writes to register.
                when AUIPC_OP =>
                    reg_write  <= '1';     -- Enable write to register file
                    alu_src    <= '1';     -- Immediate is used by ALU
                    alu_op     <= "00";    -- ALU performs addition (PC + immediate)

                -- JAL (Jump and Link)
                -- Unconditional jump, saves PC+4 to rd.
                when JAL_OP =>
                    reg_write  <= '1';     -- Enable write to register file (for PC+4)
                    jump       <= '1';     -- Indicate an unconditional jump
                    alu_op     <= "00";    -- ALU may be used to calculate target address (PC + immediate) or pass PC+4

                -- JALR (Jump and Link Register)
                -- Unconditional jump to (rs1 + immediate), saves PC+4 to rd.
                when JALR_OP =>
                    reg_write  <= '1';     -- Enable write to register file (for PC+4)
                    jump       <= '1';     -- Indicate an unconditional jump
                    alu_src    <= '1';     -- Immediate is used by ALU (for address calculation)
                    alu_op     <= "00";    -- ALU performs addition (rs1 + immediate)

                -- Default case for any other undefined or unsupported opcodes.
                -- All control signals remain in their default inactive state.
                when others =>
                    null; -- Explicitly do nothing, as defaults are set above.
            end case;
        end if;
    end process;

end architecture behavioral;