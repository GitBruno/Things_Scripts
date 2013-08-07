# ExportWIPThings - for exporting Things work in progress projects to the Desktop as ThingsWIP.txt
# Based on the script of Dexter Ang (Thanks!)

set exportTag to "kids"

set theFileName to "JobList_Projects.txt"
#set theFilePath to (path to desktop as Unicode text) & theFileName
set theFilePath to (path to home folder as Unicode text) & "WIP:_Admin:JobListGen:" & theFileName

set theFile to (open for access file theFilePath with write permission)
set eof of theFile to 0
set pCount to 0

tell application "Things" to activate

tell application "Things"
	
	log completed now
	empty trash
	
	set allProjects to to dos of list "Projects"
	
	--First loop over the prject and count them for the header
	repeat with thisProject in allProjects
		set tagList to tags of thisProject
		set tagNames to tag names of thisProject
		repeat with thisTag in tagList
			set tagName to the name of thisTag
			if tagName is exportTag then
				set pCount to pCount + 1
			end if
		end repeat
	end repeat
	
	write "TOTAL PROJECTS: " & pCount & linefeed & linefeed to theFile
	
	repeat with thisProject in allProjects
		set tdName to the name of thisProject
		set tdDueDate to the due date of thisProject
		set tdNotes to the notes of thisProject
		set tagList to tags of thisProject
		set tagNames to tag names of thisProject
		
		repeat with thisTag in tagList
			set tagName to the name of thisTag
			if tagName is exportTag then
				write "Project: " & tdName & linefeed to theFile
				if tdNotes is not "" then
					repeat with noteParagraph in paragraphs of tdNotes
						write "Status: " & noteParagraph & linefeed to theFile
					end repeat
				end if
				if tdDueDate is not missing value then
					write "Due: " & date string of tdDueDate & linefeed to theFile
				end if
				set prToDos to to dos of project tdName
				repeat with prToDo in prToDos
					set prtdName to the name of prToDo
					set prtdDueDate to the due date of prToDo
					set prtdNotes to the notes of prToDo
					
					write tab & "- Todo: " & prtdName & linefeed to theFile
					if prtdDueDate is not missing value then
						write tab & "  Due: " & tab & date string of prtdDueDate & linefeed to theFile
					end if
					
					if prtdNotes is not "" then
						repeat with prnoteParagraph in paragraphs of prtdNotes
							write tab & "  Status: " & prnoteParagraph & linefeed to theFile
						end repeat
					end if
					
				end repeat
				write linefeed to theFile
			end if
		end repeat
	end repeat
	
	close access theFile
	
end tell