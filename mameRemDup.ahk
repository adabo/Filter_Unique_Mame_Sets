while(!gameListFile)
{
	FileSelectFile, gameListFile, 3, %A_WorkingDir%\*.csv, Choose your CSV MAME collection list, Text documents (*.txt; *.csv)
	if (ERRORLEVEL)
	{
		ExitApp
	}
	else if (gameListFile == "")
	{
		msgBox, 1, ROM Collection Filter,% "Please choose a list."
		ifMsgBox OK
			continue
		else ifMsgBox Cancel
			ExitApp
	}
	else
	{
		msgBox, 3, ROM Collection Filter,% "Is this correct? """ gameListFile """"
		ifMsgBox No
		{
			gameListFile := ""
			continue
		}
		ifMsgBox Yes
			break
		else ifMsgBox Cancel
			ExitApp
	}
}

FileRead, gameList,% gameListFile

preferredHiLo := "low"
preferredRegion := "US,World,Euro"
lineCnt := 1
gameListLines := strSplit(gameList, "`n")

while(lineCnt < gameListLines.MaxIndex())
{
	currentWords := getGameTitleWords(gameListLines[lineCnt])

	if (isSameSetFamily(referenceWords, currentWords))
	{
		++lineCnt
		continue
	}
	else
	{
		regexMatch(gameListLines[lineCnt], "^.*?,(\w*)", machineName)
		toClipboard .= machineName1 ".zip`n"
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
