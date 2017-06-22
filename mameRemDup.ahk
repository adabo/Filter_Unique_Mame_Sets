; Remove similar named files from a list: dual column: Set Name | File Name, CSV, XML, DAT, Single Column
; Get preffered order from user: Rev[hi]/[low], (World, (US, (Japan, (Set[hi]/[low].

fileRead, gameList, f:\Desktop\MAME Tools\MFM 0.8.500\Lists\EnglishOnly[Fixed].txt

preferredHiLo := "low"
preferredRegion := "US,World,Euro"
wordCnt := 0
lineCnt := 0
ix := 0
gameListLines := strSplit(gameList, "`n")

loop,% gameListLines.MaxIndex()
{
	++wordCnt
	++lineCnt
	currentWords := strSplit(gameListLines[lineCnt], a_Space, """")
	if (doesMatch(referenceWords, currentWords))
	{
		continue
	}
	else
	{
		regexMatch(gameListLines[lineCnt], "^.*?,(\w*)", machineName)
		;toClipboard .= ix " " referenceLine "`n"
		toClipboard .= ix " " machineName1 "`n"
		referenceWords := currentWords
		referenceLine := gameListLines[lineCnt]
		++ix
	}
}

doesMatch(R, C)
{
	i := 0
	while(i < R.MaxIndex())
	{
		++i
		RCurChar := subStr(R[i], 1, 1)
		CCurChar := subStr(C[i], 1, 1)

		;Need to check if first 'char' is '(', or if the 'words' are different
		;Some Game (Rev 1)
		;Some Game (Rev 2)
		;Some Game Different
		if ( (RCurChar == "(" || CCurChar == "(") || (R[i] != C[i]))
		{
			;Then return if they are the same set family
			;If both 'char' == '(', then same family
			return ((RCurChar == "(") && (CCurChar == "("))
		}
	}
}

Clipboard := toClipboard
Gui, Gui1:Add, Edit, ReadOnly w600 h800,% toClipboard
Gui, Gui1:+Resize
Gui, Gui1:Show
msgBox, Finished.
*~Esc::ExitApp

