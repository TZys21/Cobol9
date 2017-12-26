      *Lab9b Tyler Zysberg
      *Check a file for a record using a hash function
	   
	   identification Division.
       Program-ID. Lab9b.
      
       Environment Division. 
       Input-Output Section.
       File-Control.
       Select inputfile
          Assign to "Lab9-upsert.dat"
          Organization is line sequential.
         
       Select DeleteFile
          Assign to "Lab9-del.dat"
          Organization is line sequential.
		  
	   Select Indexfile
	      Assign to "Lab9b-master.dat"
		  Organization is Indexed
		  Access Mode is sequential
		  Record Key is OutNumber
		  Status is OutFileStat.
         
       Select Outputfile
          Assign to "Lab9b-master.dat"
          Organization is Indexed
          Access Mode is Random
          Record Key is OutNumber
          Status is OutFileStat.
       
        Data Division.
        File Section.
        FD inputfile.
        01 MovieRecord.
           05 MovieNum Pic 9(5).
           05 MovName Pic X(50).
           05 MovGen Pic X(20).
           
        FD Deletefile.
        01 DeleteNum pic 9(5).
        
        FD Outputfile.
        01 OutRec.
           05 OutNumber Pic 9(5).
           05 OutName Pic X(50).
           05 OutGen Pic X(20).
        
        Working-Storage Section.
        01 EOF Pic X.
           88 Finished Value 'Y'.
        01 OutFileStat Pic 99.
        01 Var pic X.
           88 Found Value "Y".
        01 WriteVar Pic X.
           88 Written Value "Y".
        01 DelVar Pic X.
           88 Deleted Value "Y".
        01 CurrentRecord.
           05 CurNumber Pic 9(5).
           05 CurName Pic X(50).
           05 CurGen Pic X(20).


        Procedure Division.
        000-Main.
	    	Open Output Outputfile.
            Close Outputfile.
            Perform 100-SetRelFile
            Perform 101-DeleteFiles
			Move "N" to EOF
		    Close Outputfile.
			Open Input Indexfile.
			Perform Until Finished
            Read IndexFile into CurrentRecord
			at end
			Move "Y" to EOF
			not at end
            Perform 102-DisplayScreen
            end-perform
			Close DeleteFile.
            Close Indexfile.
            stop run.
        
		
		102-DisplayScreen.
            Display CurNumber " " CurName " " CurGen.
			
			
	    100-SetRelFile.
            Open Input inputfile.
            Open I-O Outputfile.
            Perform Until Finished
            Read inputfile
            at end
            move 'Y' to EOF
            not at end
            Move MovieRecord to OutRec
            Write OutRec
            Evaluate OutFileStat
			When 00
			continue
			When 22
			if OutName <> " "
			if OutGen <> " "
			Perform 111-RewriteFile
			end-if
			end-if
			when other
			Display "wtf"
            Perform 111-RewriteFile
	        end-evaluate
            end-perform
            Close inputfile.
            
        111-RewriteFile.
		    Rewrite OutRec
			Evaluate OutFileStat
			when 00
			continue
			when 23
			Display "Record " MovieNum" cannot be rewritten"
			when other
			Display "Unknown error"
			end-evaluate.
			
		101-DeleteFiles.
            Open Input Deletefile.
            Move 'N' to EOF
            Perform until Finished
            Read Deletefile
            at end
            Move 'Y' to EOF
            not at end
            Move "N" to Var
            Move DeleteNum to OutNumber
            Move 'Y' to DelVar
             Read Outputfile
             If OutNumber = DeleteNum
              Move "Y" to Var
             end-if
            if Found
            Read Outputfile
            Delete Outputfile
            evaluate OutFileStat
            when 00
            move "Y" to WriteVar
            when 22
            Display "Could not find Record " DeleteNum with no advancing
            Display " to delete"
            end-evaluate
            else
            Display "Could not find record " DeleteNum with no advancing
            Display " to delete"
            end-if
            end-perform.

 