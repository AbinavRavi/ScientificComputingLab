function b= num_entries(a)
% This function finds the number of elements in an object assuming each
% object takes 8 bytes of memory for storage.

S=whos('a'); %creates a struct containing info about a
b=S.bytes/8; % acess the byte attribute
end