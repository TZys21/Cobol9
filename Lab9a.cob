     
      *Lab9 Tyler Zysberg
      *Check a file for a record using a hash function
	   
	   identification Division.
       Program-ID. Lab9a.
     
       Environment Division. 
       Input-Output Section.
       File-Control.
       Select inputfile
          Assign to "Lab9-in.dat"
          Organization is line sequential.
         
       Select DeleteFile
          Assign to "Lab9-del.dat"
          Organization is line sequential.
         
       Select Outputfile
          Assign to "Lab9a-master.dat"
          Organization is Relative
          Access Mode is Random
          Relative Key is OutKey
          Status is OutFileStat.
       
        Data Division.
        File Section.
        FD inputfile.
        01 MovieRecord.
           05 MovNumber Pic 9(5).
           05 MovName Pic X(50).
           05 MovGen Pic X(20).
           
        FD Deletefile.
        01 DeleteNumber pic 9(5).
        
        FD Outputfile.
        01 OutRec.
           05 OutNumber Pic 9(5).
           05 OutName Pic X(50).
           05 OutGen Pic X(20).
        
        Working-Storage Section.
        01 EOF Pic X.
           88 Finished Value 'Y'.
        01 OutKey Pic 99.
        01 OutFileStat Pic 99.
        01 Var pic X.
           88 Found Value "Y".
        01 WriteVar Pic X.
           88 Written Value "Y".
        01 DelVar Pic X.
           88 Deleted Value "Y".
        01 cursr Pic 99.
        01 CurrentRecord.
           05 CurNumber Pic 9(5).
           05 CurName Pic X(50).
           05 CurGen Pic X(20).
        01 RecCount Pic 99.
        01 DisplayVar Pic X.
           88 DispDone Value "Y".
		01 LastNumber Pic 9(5).


        Procedure Division.
        000-Main.
            Open Output Outputfile.
            Close Outputfile.
			Set cursr to 1
            Perform 100-SetRelFile
            Perform 101-DeleteFiles
            Perform 102-DisplayScreen until RecCount = 53
            Close DeleteFile.
            Close Outputfile.
            stop run.
            
			
	    102-DisplayScreen.
            Move cursr to OutKey
            Read Outputfile into CurrentRecord
			Display OutKey " " with no advancing
            if CurNumber = LastNumber
            Display "Unused"
            else
			Display CurNumber " " CurName " " CurGen
			Move OutNumber to LastNumber
			end-if
            add 1 to cursr
            add 1 to RecCount.
            
        
        101-DeleteFiles.
            Open Input Deletefile.
            Move 'N' to EOF
            Perform until Finished
            Read Deletefile
            at end
            Move 'Y' to EOF
            not at end
            Move "N" to Var
            Move DeleteNumber to OutKey
            Move 'Y' to DelVar
            Perform 53 times
             if OutKey > 53
              Subtract 53 from OutKey
             end-if
             Read Outputfile
             If OutNumber = DeleteNumber
              Move "Y" to Var
             else
              Add 1 to OutKey
             end-if
            end-perform
            if Found
            Read Outputfile
            Delete Outputfile
            evaluate OutFileStat
            when 00
            move "Y" to WriteVar
            when 22
            Display "Could not find Record " DeleteNumber 
			with no advancing
            Display " to delete"
            end-evaluate
            else
            Display "Could not find record " DeleteNumber 
			with no advancing
            Display " to delete"
            end-if
            end-perform.
			
			
		100-SetRelFile.
            Open Input inputfile.
            Open I-O Outputfile.
            Perform Until Finished
            Read inputfile
            at end
            move 'Y' to EOF
            not at end
            Move MovNumber to OutKey
            Move MovieRecord to OutRec
            Move "N" to WriteVar
            perform until Written
            if OutKey > 53
            Subtract 53 from OutKey
            end-if
            Write OutRec
            Evaluate OutFileStat
            when 00
            move "Y" to WriteVar
            when 22
            add 1 to OutKey
            end-evaluate
            end-perform
            end-perform
            Close inputfile.
            
        
            


 