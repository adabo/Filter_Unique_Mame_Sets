;gameList =
;(
;Kung-Fu Master,kungfum,Irem,1984,Fighter / 2D,good,null,0.023,horizontal,raster,2,2,,,,null,,no,no,,
;Kung-Fu Master (bootleg set 1),kungfub,bootleg,1984,Fighter / 2D,good,kungfum,0.024,horizontal,raster,2,2,,,,null,,no,no,,
;Kung-Fu Master (bootleg set 2),kungfub2,bootleg,1984,Fighter / 2D,good,kungfum,.034b07,horizontal,raster,2,2,,,,null,,no,no,,
;Kung-Fu II,kungfuii,Irem,1984,Fighter / 2D,good,null,0.023,horizontal,raster,2,2,,,,null,,no,no,,
;Lady Bug,ladybug,Universal,1981,Maze,good,null,0.001,horizontal,raster,2,2,,,,null,,no,no,,
;Lady Bug (bootleg),ladybugb,bootleg,1981,Maze,good,ladybug,.034b03,horizontal,raster,2,2,,,,null,,no,no,,
;)
;FileRead, gameList, f:\Desktop\MAME Tools\MFM 0.8.500\Lists\EnglishOnly_v2.csv
while(gameList == "")
{
	FileSelectFile, gameList, 3, %A_WorkingDir%\*.csv, Choose your CSV MAME collection list, Text documents (*.txt; *.csv)
	if (ERRORLEVEL)
	{
		ExitApp
	}
	else if (gameList == "")
	{
		msgBox, 1, ROM Collection Filter,% "Please choose a list."
		ifMsgBox OK
			continue
		else ifMsgBox Cancel
			ExitApp
	}
	else
	{
		msgBox, 3, ROM Collection Filter,% "Is this correct? """ gameList """"
		ifMsgBox No
		{
			gameList := ""
			continue
		}
		ifMsgBox Yes
			break
		else ifMsgBox Cancel
			ExitApp
	}
}

preferredHiLo := "low"
preferredRegion := "US,World,Euro"
lineCnt := 1
gameListLines := strSplit(gameList, "`n")
lo(gameListLines.MaxIndex(), "Maxindex")

while(lineCnt < gameListLines.MaxIndex())
{
msgBox, done
	currentWords := getGameTitleWords(gameListLines[lineCnt])

	if (isSameSetFamily(referenceWords, currentWords))
	{
		++lineCnt
		continue
	}
	else
	{
		lo(referenceLine)
		regexMatch(gameListLines[lineCnt], "^.*?,(\w*)", machineName)
		toClipboard .= machineName1 ".zip`n"
		;toClipboard .= "`n" gameListLines[lineCnt]
		referenceWords := currentWords
		referenceLine := gameListLines[lineCnt]
		++lineCnt
	}
}

getReferenceWords(RW)
{
	i := 1
	while(i < RW.MaxIndex() || RW.MaxIndex() == 0)
	{
		title .= RW[i]
		++i
	}
	return title
}

getWord(nChars, ByRef i)
{
	while(nChars[i] != a_Space)
	{
		word .= nChars[i]
		++i
	}
	return word
}

isSameSetFamily(R, C)
{
	i := 1
	while((i <= R.MaxIndex() || i <= C.MaxIndex()))
	{
		RFirstChar := subStr(R[i], 1, 1)
		CFirstChar := subStr(C[i], 1, 1)
		;msgbox,% "---while test`nFirst chars---`n" RFirstChar "`n" CFirstChar "`n---i and max---`ni: " i "`nRMax: " R.MaxIndex() "`nCMax" C.MaxIndex() 
		if ( (RFirstChar == "(" || CFirstChar == "(") || (R[i] != C[i]))
		{
			return ((RFirstChar == "(" && CFirstChar == "(")
				|| (RFirstChar == "" && CFirstChar == "(")
				|| (RFirstChar == "(" && CFirstChar == ""))
		}
		++i
	}
}

getGameTitleWords(Line)
{
	regexMatch(Line, "^(.+?),", gameTitle)
	return strSplit(gameTitle1, " ")
}

lo(Ob,M="--NOMSESSAGE--"){
	if (Ob.MaxIndex()){
		while(a_index <= Ob.MaxIndex()){
			l .= Ob[a_index] "`n"
		}
		msgBox,% M "`n---------------------`n" l
	}
	else {
		msgBox,% M "`n---------------------`n" Ob
	}
}

Gui, Gui1:Add, Edit, ReadOnly w600 h800,% toClipboard
Gui, Gui1:+Resize
Gui, Gui1:Show
*~Esc::ExitApp
