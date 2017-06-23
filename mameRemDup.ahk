; Remove similar named files from a list: dual column: Set Name | File Name, CSV, XML, DAT, Single Column
; Get preffered order from user: Rev[hi]/[low], (World, (US, (Japan, (Set[hi]/[low].

;fileRead, gameList, f:\Desktop\MAME Tools\MFM 0.8.500\Lists\EnglishOnly_v2.csv

gameList =
(
Kung-Fu Master,kungfum,Irem,1984,Fighter / 2D,good,null,0.023,horizontal,raster,2,2,,,,null,,no,no,,
Kung-Fu Master (bootleg set 1),kungfub,bootleg,1984,Fighter / 2D,good,kungfum,0.024,horizontal,raster,2,2,,,,null,,no,no,,
Kung-Fu Master (bootleg set 2),kungfub2,bootleg,1984,Fighter / 2D,good,kungfum,.034b07,horizontal,raster,2,2,,,,null,,no,no,,
Kung-Fu II,kungfum,Irem,1984,Fighter / 2D,good,null,0.023,horizontal,raster,2,2,,,,null,,no,no,,
Lady Bug,ladybug,Universal,1981,Maze,good,null,0.001,horizontal,raster,2,2,,,,null,,no,no,,
Lady Bug (bootleg),ladybugb,bootleg,1981,Maze,good,ladybug,.034b03,horizontal,raster,2,2,,,,null,,no,no,,
)


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

	;currentWords := splitFirstColumn(gameListLines[lineCnt])
	currentWords := getGameTitleWords(gameListLines[lineCnt])
;		msgBox, check1

	;loop,% currentWords.MaxIndex()
	;{
	;	msgBox,% "30| " currentWords[a_Index]
	;}
	msgBox,% "35| Ref title| " getReferenceWords(referenceWords)
	if (doesMatch(referenceWords, currentWords))
	{
		msgBox,% "37| True. Same family, so referencWords stays unchanged"
		continue
	}
	else
	{
		msgBox, False, reference words changing
		regexMatch(gameListLines[lineCnt], "^.*?,(\w*)", machineName)
		toClipboard .= machineName1 ".zip`n"
		referenceWords := currentWords
		referenceLine := gameListLines[lineCnt]
		++ix
	}
}

getReferenceWords(RW)
{
	i := 1
;	msgBox,% "MaxIndex| " RW.MaxIndex()
	while(i < RW.MaxIndex() || RW.MaxIndex() == 0)
	{
		title .= RW[i]
		++i
	}
	msgBox,% "getReferenceWords: " title
	return title
}

;getWord(Character position)
getWord(nChars, ByRef i)
{
	while(nChars[i] != a_Space)
	{
		word .= nChars[i]
		++i
	}
	return word
}

;doesMatch([R]eferenceWords, [C]urrentWords)
doesMatch(R, C)
{
	i := 0
	while(i < R.MaxIndex())
	{
		++i
		;             subStr(str, Pos, Size)
		RFirstChar := subStr(R[i], 1, 1)
		CFirstChar := subStr(C[i], 1, 1)
		RLastChar  := subStr(R[i], 0, 1)
		CLastChar  := subStr(C[i], 0, 1)

		;Need to check if first 'char' is '(', or if the 'words' are different
		;Some Game (Rev 1)
		;Some Game (Rev 2)
		;Some Game Different
		if ( (RFirstChar == "(" || CFirstChar == "(") || (R[i] != C[i]))
		{
			msgBox,% "79| RFirstChar: " RFirstChar 
			       . "`nCFirstChar: " CFirstChar
				   . "`nR[i]: " R[i]
				   . "`nC[i]: " C[i]

			;Then return true if they are the same set family
			;If both 'char' == '(', then same family
			return ((RFirstChar == "(" && CFirstChar == "("))
		}
	}
}

getGameTitleWords(Line)
{
	regexMatch(Line, "^(.+?),", gameTitle)
	msgBox,% "getGameTitleWords() Just regex title not str split yet:`n" gameTitle1
	return strSplit(gameTitle1, " ")
}

;Clipboard := rTrim(toClipboard, "`n")
;Clipboard := SubStr(toClipboard,InStr(toClipboard,"`n",False,0)+1)
Gui, Gui1:Add, Edit, ReadOnly w600 h800,% toClipboard
Gui, Gui1:+Resize
Gui, Gui1:Show
;msgBox, Finished.
*~Esc::ExitApp

