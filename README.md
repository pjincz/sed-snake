Snake game wrote by SED
=======================

run line by line

    sed -f snake.sed
    Then press enter key to start.

run with keyseq.sh (auto)

	./keyseq.sh | sed -f snake.sed

run without keyseq.sh (auto, but has some issue)

    while true; do read -t0.1 -n3 -s key; echo $key; done | sed -f snake.sed
    # -t0.1 for speed, smaller is faster
    # -n3 for arrow control, -n1 for asdw control

Enjoy...
