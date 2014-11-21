#!/bin/sed -nf
# init
1 {
	# 76 * 25
	s/.*/baaaaaaa......b/
	s/a/........../g
	s/.*/&&&&&&&&&&&&&&&&&&&&&&&&&/
	s/\....../xxxxxo/
	s/.*/map:& ward:d queue:o|-o|--o|---o|----o score:0/
	h
	b gen_food
}

# deal input
/^\[[ABCD]/ {
	s/\[//
	y/ABCD/wsda/
}
/^[asdwASDW]/ {
	s/\(.\).*/\1/
	y/ASDW/asdw/
	G
	s/\(.\)\n\(.*\)ward:./\2ward:\1/
	h
	s/.*//
}

# ignore error input
/^\s*$/ !b print

# save head to queue
g
s/.*map:\([^ ]*\).*/\1/
s/b//g
s/@/./g
y/.xo/--o/
# - is 1, = is 10, # is 100
s/-*$//
s/----------/=/g
s/==========/#/g
G
s/\(.*\)\n\(.*\)queue:\([^ ]*\)/\2queue:\3|\1/
h

# move head
g
/ ward:d/ {
	# right
	/o[.@]/ !b gameover
	s/o[.@]/xo/
}
/ ward:a/ {
	# left
	/[.@]o/ !b gameover
	s/[.@]o/ox/
}
/ ward:s/ {
	# down
	/o\([^ ]\{77\}\)[.@]/ !b gameover
	s/o\([^ ]\{77\}\)[.@]/x\1o/
}
/ ward:w/ {
	# up
	/[.@]\([^ ]\{77\}\)o/ !b gameover
	s/[.@]\([^ ]\{77\}\)o/o\1x/
}
h

# If food is eaten, jump to gen food, and skip clean tail one time.
/map:[^ ]*@/ !b eaten

# clean tail
g
s/.*map:\([^ ]*\).*queue:\([^ |]*\).*/\2\n\1/
s/b//g
s/$/\n/
:clean_loop_100
s/^#\([^\n]*\)\n\(.\{100\}\)\([^\n]*\)\n\(.*\)/\1\n\3\n\4\2/
t clean_loop_100
:clean_loop_10
s/^=\([^\n]*\)\n\(.\{10\}\)\([^\n]*\)\n\(.*\)/\1\n\3\n\4\2/
t clean_loop_10
:clean_loop_1
s/^-\([^\n]*\)\n\(.\)\([^\n]*\)\n\(.*\)/\1\n\3\n\4\2/
t clean_loop_1
s/o\n.\([^\n]*\)\n\(.*\)/\2.\1/
s/.\{76\}/b&b/g
G
s/\([^\n]*\)\nmap:[^ ]*\(.*\)queue:[^|]*|/map:\1\2queue:/
h

:print
g
s/.*map:\([^ ]*\).*/\1/
s/b/|/g
s/.\{78\}/ & \n/g
s/^/[H[2J --bar-- \n/
s/$/ --bar-- /
s/--bar--/+----------------------------------------------------------------------------+/g
# colorize
s/@/[01;34m@[0m/g
s/[ox][ox]*/[01;31m&[0m/g
s/[+|-][+|-]*/[01;32m&[0m/g
s/\.\.*/[01;90m&[0m/g
# add info
s/\n/  W or Up: turn up\n/4
s/\n/  S or Down: turn down\n/5
s/\n/  A or Left: turn left\n/6
s/\n/  D or Right: turn right\n/7
s/\n/  Blank line: forward\n/8
s/\n/  Score: SCORE_PLACEHOLD\n/10
G
s/SCORE_PLACEHOLD\(.*\)\n[^\n]*score:\([^ ]*\).*$/\2\1/
p
# for debug
#g
#s/.*ward:/ward:/
#p
b

:eaten
# add score
g
s/.*score:\([^ ]*\).*/\1/
# for easy deal: remove two zero, add 1, add two zero
s/00$//
s/$/z/
:add_loop
s/0z/1/; s/1z/2/; s/2z/3/; s/3z/4/; s/4z/5/; 
s/5z/6/; s/6z/7/; s/7z/8/; s/8z/9/; s/9z/z0/;
s/^z/1/; 
/z/ b add_loop
s/$/00/
G
s/\([^\n]*\)\n\(.*score:\)[^ ]*/\2\1/
h
b gen_food

:gen_food
# use buffer space to generate fake random
g
s/\./vvv/g
s/b/vv/g
s/x/vvvvvvv/g
s/o/vvvvvvvvvvvvv/g
s/-/vvvvvvvvvvv/g
s/=/vvvvvvvvvvvvvvvvv/g
s/#/vvvvvvvvvvvvvvvvvvv/g
s/[^v]/v/g
s/.\{1900\}//g
s/$/@/
# add food to map
G
s/\n.*map:\([^ ]*\).*/\n\1\n/
s/b//g
:add_food_loop_40
s/^v\{40\}\([^\n]*\)\n\(.\{40\}\)\([^\n]*\)\n\(.*\)/\1\n\3\n\4\2/
t add_food_loop_40
:add_food_loop_1
s/^v\([^\n]*\)\n\(.\)\([^\n]*\)\n\(.*\)/\1\n\3\n\4\2/
t add_food_loop_1
s/@\n\([^.]*\)\./\1@/
s/\([^\n]*\)\n\(.*\)/\2\1/
s/.\{76\}/b&b/g
G
s/\([^\n]*\)\n\(.*\)map:[^ ]*/\2map:\1/
h
b print

:gameover
g
s/.*score:\([^ ]*\).*/Game Over! Your score: \1.\n/
p
q
