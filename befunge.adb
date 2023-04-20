with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Text_IO;         use Ada.Text_IO;
with StackPkg;

procedure befunge is

   --gets Integer
   function Get_Integer return Integer is
      Input : Integer;
   begin
      Get (Input);
      return Input;
   end Get_Integer;

   r : Integer := Get_Integer;
   c : Integer := Get_Integer;

   --Array of string of size c
   subtype Row_String is String (1 .. c);
   type String_Array is array (Positive range <>) of Row_String;

   --when an Integer is pulled new line is not consumed
   procedure Toss_New_Line is
      Toss : String := Get_Line;
   begin
      null;
   end Toss_New_Line;

   --Gets a grid of the specified input size
   function Get_Grid (rows : Integer) return String_Array is
      Grid : String_Array (1 .. r);
   begin
      Toss_New_Line;
      for Index in 1 .. r loop
         declare
            Input : String := Get_Line;
            Row   : Row_String;
         begin
            for I in Input'Range loop
               Row (I) := Input (I);
            end loop;
            Grid (Index) := Row;
         end;
      end loop;
      return Grid;
   end Get_Grid;

   --actual grid used
   Grid : String_Array := Get_Grid (r);

   package MyStack is new StackPkg (Size => 1_000, ItemType => Integer);
   use MyStack;

   --actual stack used
   Befunge_Stack : Stack;

   type Direction_Enum is (Up, Down, Right, Left);

   type Position_Type is record

      Current_Row    : Integer        := 1;
      Current_Column : Integer        := 1;
      Direction      : Direction_Enum := Right;
      Done           : Boolean        := False;
   end record;

   Position : Position_Type;
begin

   declare
      --true if is an operator
      function isOperator (c : in Character) return Boolean is
      begin
         return c = '+' or c = '-' or c = '*' or c = '/';
      end isOperator;

      --gets the top of the stack out
      function getTop (s : in out Stack) return Integer is
         Item : Integer;
      begin
         Item := Top (s);
         Pop (s);
         return Item;
      end getTop;

      --gets the top and doesn't do anything else
      procedure getTop (s : in out Stack) is
         Item : Integer;
      begin
         Item := Top (s);
         Pop (s);
      end getTop;

      --does specific operation on desired numbers
      procedure doOperation (s : in out Stack; op : Character) is
         First     : Integer;
         Second    : Integer;
         New_Value : Integer;
      begin
         First  := getTop (s);
         Second := getTop (s);
         if op = '+' then
            New_Value := First + Second;
         elsif op = '-' then
            New_Value := Second - First;
         elsif op = '*' then
            New_Value := First * Second;
         elsif op = '/' then
            New_Value := Second / First;
         end if;
         Push (New_Value, s);
      end doOperation;

      --duplicates the top
      procedure Duplicate (s : in out Stack) is
         Item : Integer := Top (s);
      begin
         Push (Item, s);
      end Duplicate;

      --swaps the first two items on the stack
      procedure Swap (s : in out Stack) is
         First  : Integer;
         Second : Integer;
      begin
         First  := getTop (s);
         Second := getTop (s);
         Push (First, s);
         Push (Second, s);
      end Swap;

      Invalid_Instruction : exception;
   begin

      while (not Position.Done) loop
         declare

            current : Character :=
              Grid (Position.Current_Row) (Position.Current_Column);

         begin
            if current = '@' then
               Position.Done := True;
            elsif current = '>' then
               Position.Direction := Right;
            elsif current = '<' then
               Position.Direction := Left;
            elsif current = '^' then
               Position.Direction := Up;
            elsif current = 'v' then
               Position.Direction := Down;
            elsif isOperator (current) then
               doOperation (Befunge_Stack, current);
            elsif current = '.' then
               Put (getTop (Befunge_Stack), 0);
               Put (" ");
            elsif current = '$' then
               getTop (Befunge_Stack);
            elsif current = ':' then
               Duplicate (Befunge_Stack);
            elsif current = '\' then
               Swap (Befunge_Stack);
            elsif current = '_' then
               declare
                  Item : Integer := getTop (Befunge_Stack);
               begin
                  if Item = 0 then
                     Position.Direction := Right;
                  else
                     Position.Direction := Left;
                  end if;
               end;
            elsif current = '|' then
               declare
                  Item : Integer := getTop (Befunge_Stack);
               begin
                  if Item = 0 then
                     Position.Direction := Down;
                  else
                     Position.Direction := Up;
                  end if;
               end;
            elsif current = ' ' then
               null;
            elsif current >= '0' and current <= '9' then
               Push
                 (Character'Pos (current) - Character'Pos ('0'),
                  Befunge_Stack);
            else
               raise Invalid_Instruction;
            end if;

            if Position.Direction = Up then
               Position.Current_Row := Position.Current_Row - 1;
            elsif Position.Direction = Down then
               Position.Current_Row := Position.Current_Row + 1;
            elsif Position.Direction = Left then
               Position.Current_Column := Position.Current_Column - 1;
            elsif Position.Direction = Right then
               Position.Current_Column := Position.Current_Column + 1;
            end if;
         end;

      end loop;

   exception
      when Constraint_Error =>
         Put_Line ("Error: Out of bounds");
      when Stack_Empty =>
         Put_Line
           ("Error: Attempted to access top element from an empty stack");
      when Stack_Full =>
         Put_Line ("Error: Stack overflow");
      when Invalid_Instruction =>
         Put_Line ("Error: Invalid instruction");
   end;
end befunge;
