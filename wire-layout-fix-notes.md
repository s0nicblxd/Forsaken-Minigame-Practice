# Connect the Wires follow-up
Matching terminals must occupy different edges, differ by at least one terminal
width on both axes, and be separated by at least two terminal widths. A bounded
random-layout search uses backtracking to pair positions and has a known-valid
fallback layout. User-requested constraints extend the supplied client layout.

Square terminals share Flow's palette, bold Arial label proportions, black
stroke, 450ms Quad Out fade pulse (radius ratio .5/.33), and 400ms sinusoidal
13% size bump. Bumps affect both square and number and persist across drag redraws.

Checked 3,000 boards across 4/5/6 pairs, pointer linking/disconnecting, pulse
persistence, scoring once, automatic next round, and cleanup.
