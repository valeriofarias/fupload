**
* Software:			fupload Version 1.2
* Programmer:		Val�rio Farias
* Comments:		   Modify the file name, deleting the empty spaces and copy files to tmp folder
**

SET CENTURY ON

#DEFINE DEFAULTFOLDER  "c:\fupload\"
#DEFINE STARTFOLDER    DEFAULTFOLDER  + "start"
#DEFINE TMPFOLDER 	  DEFAULTFOLDER  + "tmp\"	
#DEFINE SCRIPTFOLDER   DEFAULTFOLDER  + "script\"	

#DEFINE SERVERFOLDERPDF   "\pathpdf\"	
#DEFINE SERVERFOLDERZIP   "\pathzip\"	

Public originalName, modifiedName, logFile, originalFullPath, finalPath, fileSize

**
* Main program: search all files of the standard folder  
**
PROCEDURE fupload 

PARAMETERS param

SET PROCEDURE TO SCRIPTFOLDER + "functions.prg"
SET DEFAULT TO ( STARTFOLDER )

**
* param variable must be a string
**
IF Type('param') == "N" 

   MESSAGEBOX("The parameter must be a string.")
   CLEAR ALL memory 
	CANCEL 

ELSE 

  	IF NOT Empty( param )

  		param = param + "_"

  	ELSE

  		param = ""

  	ENDIF 

ENDIF 


SET DATE TO YMD
dateandtime = DTOC( DATE() ) + "__" + TIME()
dateandtimeonlynumbers = ClearString( dateandtime, "_" )

SET DATE TO BRITISH
dateandtime = DTOC( DATE() ) + " - " + TIME()

quant = ADIR( aDocs )

* log file will have links to put in site
logFile = Fcreate( TMPFOLDER + "logupload_" + dateandtimeonlynumbers + "_" + param + "n" + ALLTRIM(STR(quant)) + ".txt" )
Fputs( logFile, "Log file for upload: " + dateandtime )
Fputs( logFile, "Quantity of files: " + ALLTRIM(STR(quant))) 	
FPuts( logFile, "" )
FPuts( logFile, "<ul>" )

FOR arq = 1 TO quant

    ? aDocs( arq, 1 )
	 originalFullPath = aDocs( arq, 1 )  && name with extension
	 originalName = RecoverSpaces( LOWER( JUSTSTEM( originalFullPath ) ) )
	 firstletter  = UPPER( LEFT( originalName, 1 ) )
	 originalName = STUFF( originalName, 1, 1, firstletter )
	 
	 modifiedName = LOWER( param + ClearString( RemoveAccents( originalFullPath ) ) )  && name without spaces and without accents
	 finalPath 	  = LOWER( TMPFOLDER + modifiedName )
	 fileSize     = FileSize( aDocs( arq, 2 ) ) && return fileSize in KB, MB ou GB
	
	 DO uploadFiles
	 
ENDFOR 

FPuts( logFile, "</ul>" )
Fclose( logFile )
CLEAR ALL memory 

MESSAGEBOX( "End procedure", 64 )

ENDPROC 

** 
* Rename the files and upload to
* temp folder
**
PROCEDURE uploadFiles

TRY

	COPY FILE( originalFullPath ) TO "&finalPath." 
	
	linkpdf = '<li><a href="'+ SERVERFOLDERPDF + '&modifiedName.">&originalName. (&fileSize.)</a></li>'
	linkzip = '<li><a href="'+ SERVERFOLDERZIP + '&modifiedName.">&originalName. (&fileSize.)</a></li>'
	link = ""
	
	link = IIF( RIGHT( UPPER( originalFullPath ), 3 ) == "PDF", linkpdf, linkzip )

	Fputs( logFile, link )

CATCH TO oError

	? oError.Message 
	messagebox( oError.Message )
	
ENDTRY

ENDPROC 
