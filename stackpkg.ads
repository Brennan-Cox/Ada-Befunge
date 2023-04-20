-- This is the generic specification for a stack abstract data type.
-- Usage: Put these lines in the client (in the appropriate place):

--    with StackPkg;   -- this statement precedes client procedure declaration
--
--                     -- the next 2 statements go inside the client procedure
--                     -- the next 2 statements go after MyType is declared
--                     -- Note that MyType, StackSize here is are
--                     -- placeholders.
--    package MyStkPkg is new StackPkg(Size => StackSize; ItemType => MyType);
--    use  MyStkPkg;

generic  -- Generic parameters are declared here

	Size : Positive;            -- Size of stack to create

	type ItemType is private;   -- Type of elements that stack will contain

package StackPkg is

	type Stack is limited private;

	Stack_Empty: exception; -- Raised if do top or pop on an empty stack
	Stack_Full : exception; -- Raised if push onto full stack

        -- Determine if stack is empty or full
	function IsEmpty (S : Stack) return Boolean;
	function IsFull  (S : Stack) return Boolean;

        -- Put element Item onto Stack s
	procedure Push (item : ItemType; S : in out Stack);

        -- Remove an element from Stack s
	procedure Pop  (S : in out Stack);

        -- Return top element from Stack s
	function  Top   (s : Stack) return ItemType;
private

	type StackElements is array(1 .. Size) of ItemType;

	type Stack is record
		Elements : StackElements;
		Top : Natural range 0 .. Size := 0;
	end record;

end StackPkg;
