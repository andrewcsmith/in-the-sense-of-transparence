F0: Pitch, LH position
F1: Bow position (higher is closer to the bridge)
F2: Bow speed (higher is faster) -- i, y, etc.

All parameters are log2, then normalized to 0.0 - 1.0.

[ 9.250932238285122,  -0.016164444943482403]
[ 10.297862063391788, -0.00038245360383215576]
[ 11.36018375548594,  -0.017037774875150014]

12/28:  Parse from TextGrid into separate segments DONE
	Generate normalized pitch contours DONE
	Mark and extract remainder of syllables DONE

12/29:  Generate F1 and F2 linear fits for entire piece DONE
      	Quantize pitch contours based on harmonicity DONE
      	Figure out how to make the staff in Lilypond DONE

12/30: 	Generate Lilypond notenames based on pitches DONE
	      Create multipliers for F1 and F2 slopes DONE
	      Scale F1 and F2 data to the proper values DONE
      	Generate Lilypond line coordinates from F1 and F2 DONE

12/31:  Create rhythm map for the sequence DONE
        Generate pitch strings for each measure DONE
        Generate line strings for each measure DONE
