**FREE                                                        
      Ctl-Opt DftActGrp(*no) BndDir('DEVYUS/WEB':'QC2LE');

      // External Procedure for writing data into browser    
        Dcl-PR  WriteToWeb  ExtProc('QtmhWrStout');           
          Datavar     Char(65535)   Options(*Varsize);        
          DataVarLen  Int(10)       Const;                    
          ErrCode     Char(8000)    Options(*Varsize);        
        End-PR;                                               
                                                              
         Dcl-DS  ErrDS   Qualified;                           
           BytesProv   Int(10)   Inz(0);                      
           BytesAvail  Int(10)   Inz(0);                      
         End-DS;                                              
                                                              
      // Procedure for getting environment variables
         Dcl-PR  GetEnv Pointer  ExtProc('getenv');           
          *N   Pointer    Value Options(*string);             
         End-PR;                                              

      // Standard Error Data Structure
         /COPY QSYSINC/QRPGLESRC,QUSEC                        

      // Procedure for reading standard input (payload)
         Dcl-PR ReadStdInput  ExtProc('QtmhRdStin');          
           szRtnBuffer    Char(65535) Options(*Varsize);      
           nBufLen        Int(10)     Const;                  
           nRtnLen        Int(10);                            
           QUSEC                      Like(QUSEC);         
         End-PR;                                           

      // Procdure for translating from ASCII to EBCDIC
         Dcl-PR   Translate   ExtPgm('QDCXLATE');          
          *N  Packed(5:0)  Const;                          
          *N  Char(32766)  Options(*varsize);              
          *N  Char(10)     Const;                          
         End-PR;                                           
                        

      // Local Variables
         Dcl-S   Data    Char(5000);                       
         Dcl-C   CRLF    x'0d25';                          
                                                           
         Dcl-S   URL    Char(100);                         
         Dcl-S   ContentType Char(100);                    
         Dcl-S   ReqMethod   Char(20);                     
                                                           
         Dcl-S  RtnBuffer    Char(4096) Inz;               
         Dcl-S  RtnLen       Int(10);                      
         Dcl-DS apiError     LikeDS(QUSEC) Inz;            
                                                           
         Dcl-S  EBCData   Char(32766) Inz;                 

      // Setting up content type
         Data = 'Content-type: text/html' + CRLF + CRLF ;  
         WriteToWeb(Data : %len(%Trim(Data)): ErrDS);      
         Data = '<h1>hello world from RPG</h1>';                        
         WriteToWeb(Data : %len(%Trim(Data)): ErrDS);                   

      // Retrieve environment variables                                                         
         URL = %Str(GetEnv('REQUEST_URI'));                             
         ReqMethod = %Str(GetEnv('REQUEST_METHOD'));                    
                                                                        
         If ReqMethod = 'POST';                                         
           ContentType = %Str(GetEnv('CONTENT_TYPE'));                  
           ReadStdInput(RtnBuffer: %size(RtnBuffer): RtnLen: apiError); 
           If ContentType = 'application/json';                         
             EBCData = %Trim(rtnBuffer);                                
             Translate(%len(%Trim(EBCData)): EBCData: 'QTCPEBC');       
           EndIf;                                                       
         EndIf;                                                         

      // Write more response to browser                                                      
         Data = 'URL:' + %trim(URL) + '<br>' +                          
                'Req Method:' + %trim(ReqMethod) + '<br>' +             
                'Contenttype:' + %trim(ContentType) + CRLF ;            
         WriteToWeb(Data : %len(%Trim(Data)): ErrDS);                   
         Data = 'Data:' + %trim(RtnBuffer) + CRLF ;                     
         WriteToWeb(Data : %len(%Trim(Data)): ErrDS);                   
                                                                        
         Data = 'Converted Data:' + %trim(EBCData) ;                    
         WriteToWeb(Data : %len(%Trim(Data)): ErrDS);                   
                       
         *Inlr = *On;  
         Return;       
