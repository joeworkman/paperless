# Release Notes for Paperless

Join the Paperless User Group <https://app.glassboard.com/web/invitation/code/akkmo>


## v0.2.3 (March 28, 2013)
---
1. Spaces inside each rule condition get replaced with '\s*'. This is to compensate for OCR's inaccuracies with white space.  


## v0.2.2 (March 27, 2013)
---
1. The default rules file has been renamed to paperless.rules.yaml. The file still lives in the home folder. 



## v0.2.0 (March 27, 2013)
---

1. Added new `<filename>` varaible. 
2. The --prompt option can now be used to rename the file name in simulate mode. 
3. Added PDFPenPro6 and PDFpen6 as an option for an OCR Engine. 
4. Added new date format into date search... December 2012
5. New option to dump the OCR'd documents text content to the terminal. 
6. Some tweaks to the date search logic.
7. The file gets renamed to the title before it gets added to Evernote. This is so the underlying file has the same name.
8. If a document has been found to already been OCR'd then its not processed again. 
9. If the date is not found inside the doc contents, the filename is searched.
10. Fixed bug where paperless would crash when the title of the file never changed and shoudl default to the filename. 
11. If the path passed is a directory and not a file, its just ignored. 
