**
* Software:			fupload Version 0.5
* Programmer:		Valério Farias
* Comments:		   Modify the files deleting the empty spaces and copy files to tmp folder
**

SET CENTURY ON
SET DEFAULT TO ( "d:\upload" )

Public originalName, modifiedName, logFile, originalFullPath, finalPath, fileSize

**
* Main program: search all files of the standard folder  
**
PROCEDURE fupload 

PARAMETERS param

SET PROCEDURE TO d:\classes\progs\funcgen.prg

**
* param variable must be a string
**
IF Type('param') == "N" 

   MESSAGEBOX("The parameter must be a string.")
   CLEAR ALL memory 
	CANCEL 

ELSE 

  	IF NOT Empty(param)

  		param = param + "_"

  	ELSE

  		param = ""

  	ENDIF 

ENDIF 

SET DATE TO YMD
datahora = DTOC( DATE() ) + "__" + TIME()
datahoralimpo = ClearString( datahora, "_" )

SET DATE TO BRITISH
datahora = DTOC( DATE() ) + " - " + TIME()

quant = ADIR( aDocs )

* log file that'll have links to put in site
logFile = Fcreate( "d:\upload\temp\logupload_" + datahoralimpo + "_" + param + "n" + ALLTRIM(STR(quant)) + ".txt" )
Fputs( logFile, "Arquivo de Log para Upload: " + datahora )
Fputs( logFile, "Quantidade de arquivos: " + ALLTRIM(STR(quant))) 	
FPuts( logFile, "" )
FPuts( logFile, "<ul>" )

FOR arq = 1 TO quant

	 originalFullPath = aDocs( arq, 1 )  && name with extension
	 originalName = LOWER( SUBSTR( originalFullPath, 1, LEN( originalFullPath ) - 4 ) )
	 
	 modifiedName = LOWER(param + ClearString( RemoveAccents( originalFullPath ) ) )  && name withou spaces and withou accents
	 finalPath = LOWER( "d:\upload\temp\" + param + ClearString( RemoveAccents( originalFullPath ) ) )
	 fileSize = FileSize( aDocs( arq, 2 )) && return fileSize in KB, MB ou GB
	
	 DO uploadArquivos
	 
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

	COPY FILE ( originalFullPath ) TO "&finalPath." &&( finalPath )
	
	linkpdf = '<li><a href="/pdf/Documentos/&modifiedName.">&originalName. (&fileSize.)</a></li>'
	linkzip = '<li><a href="/zip/Formularios/&modifiedName.">&originalName. (&fileSize.)</a></li>'
	link = ""
	
	link = IIF( RIGHT( UPPER( originalFullPath ), 3 ) == "PDF", linkpdf, linkzip )

	Fputs( logFile, link )

CATCH TO oError

	? oError.Message 
	messagebox( oError.Message )
	
ENDTRY

ENDPROC 
