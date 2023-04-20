-- An implementation of the generic package defined in stack.ads

package body StackPkg is
   function isEmpty (s : Stack) return Boolean is
   begin
      return s.Top = 0;
   end isEmpty;

   function isFull (s : Stack) return Boolean is
   begin
      return s.Top = Size;
   end isFull;

   procedure push (item : ItemType; s : in out Stack) is
   begin
      if isFull(s) then
         raise Stack_Full;
      end if;
      -- Precondition guarantees that stack is not full.
      -- Verify this.
      s.Top := s.Top + 1;
      s.Elements(s.Top) := item;
   end push;

   procedure pop (s : in out Stack) is
   begin
      if isEmpty(s) then
         raise Stack_Empty;
      end if;
      s.Top := s.Top - 1;
   end pop;

   function top (s : Stack) return ItemType is
   begin
      if isEmpty(s) then
         raise Stack_Empty;
      end if;
      return s.Elements(s.Top);
   end top;


end StackPkg;
