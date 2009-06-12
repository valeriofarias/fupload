**
* Functions for fupload.prg
* functions.prg v1.0
* Author: Valério Farias
**

**
* Function:	ClearString()
*				replace empty spaces by "_" (underscore). Used to rename file names.
**
FUNCTION ClearString( cstringinput as String, cparamimput as String ) as String 
	
	LOCAL cstringfilterin as String, cstringfilterout as String, cstringoutput as String 
	
	IF PARAMETERS() = 1 
	
		 cstringoutput  = STRTRAN( cstringinput,  ' - ' , '_' )
		 cstringoutput  = STRTRAN( cstringoutput, '- '  , '_' )
		 cstringoutput  = STRTRAN( cstringoutput, ' -'  , '_' )
		 cstringoutput  = STRTRAN( cstringoutput, ' _ ' , '_' )
		 cstringoutput  = STRTRAN( cstringoutput, ' '   , '_' )
		 cstringoutput  = STRTRAN( cstringoutput, ','   , ''  )
		 cstringoutput  = STRTRAN( cstringoutput, 'º'   , ''  )
		 cstringoutput  = STRTRAN( cstringoutput, 'ª'   , ''  )      
	
	ELSE 
	
		cstringfilterin  = " -/|:"
		cstringfilterout = REPLICATE( cparamimput, 5 ) 
		cstringOutput = Chrtran( cstringinput, cstringfilterin, cstringfilterout )
	
	ENDIF 

	RETURN cstringoutput 

ENDFUNC 


**
* Function:	FileSize()
*				return the string with file size in KB or MB or GB			
**
FUNCTION FileSize( ifilesize as Number ) as String 

	LOCAL cstringoutput as String, i as Integer 
 
	Dimension aByte( 4 )

   aByte[1] = "KB"
   aByte[2] = "MB"
   aByte[3] = "GB"
   aByte[4] = "TB"

   If ifilesize <= 999
   	
   	ifilesize = 1
   
   EndIf 
   
   i = 0
	If ifilesize > 999
		
		Do while ifilesize > 999

	   	 ifilesize = ifilesize / 1024
		 	 i = i + 1 

		EndDo 

	EndIf 


	size = ALLTRIM( STR( ROUND( ifilesize, 1 ) ) )
	
	If i = 0 
	
		cstringOutput = size + aByte[1] 
	
	Else
	
		cstringOutput = size + aByte[i] 
	
	EndIf  
	
	RETURN cstringoutput 

ENDFUNC 

**
* EOF - FUNCTIONS.PRG
**