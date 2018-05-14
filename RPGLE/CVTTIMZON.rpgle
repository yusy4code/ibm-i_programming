  * ********************************************************************         
  * Program ID  : CVTTIMZON                                                      
  * Type        : *PGM                                                           
  * Author      : Mohammed Yusuf                                                 
  * Date        : Dec 2016                                                       
  * Description : PGM to Convert Time Zone & Retrive Time zone value             
  *               by using QWCCVTDT API                                          
  *                                                                              
  * -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-        
  * Usage:                                                                       
  *                                                                              
  *   This program will be using QWCCVTDT API to convert Time stamp              
  *   from one Zone to Another (considering Day Light Saving) and also           
  *   we can retrive the Time Zone value                                         
  *                                                                              
  * Parameters:                                                                  
  *   It takes 5 parameters:-                                                    
  *     1. Input Date 8 Char YYYYMMDD                                            
  *     2. Input Time 6 Char HHMMSS                                              
  *     3. From Time Zone (*UTC , *SYS or any value from WRKTIMZON)              
  *     4. To Time Zone (Any value from WRKTIMZON)                               
  *     5. Zone Abbrevation (Blanks)                                             
  *                                                                              
  *                                                                              
  * Example: Converting 2017-01-01 10:30:00 from UTC to IST                      
  *                                                                              
  *   CALL PGM(CVTTIMZON)                                                        
  *        PARM('20170101' '103000' '*UTC' 'QP0530IST' ' ')                      
  *                                                                              
  * ********************************************************************         
 H Option(*SrcStmt:*NoDebugIO)                                                   
 H Debug(*Yes)                                                                   
 H Optimize(*Full)                                                               
  *                                                                              
 DdsDateStruc      DS                  Qualified                                 
 D Date                           8S 0                                           
 D Time                           6S 0                                           
 D MilliSec                       6S 0                                           
  *                                                                              
 DInputStruc       DS                  LikeDS(dsDateStruc) Inz                   
 DOutputStruc      DS                  LikeDS(dsDateStruc) Inz                   
  *                                                                              
 DdsErrCode        DS                  Qualified                                 
 D BytesProvided                 10I 0 Inz(%Size(dsErrCode.MsgData))             
 D BytesAvail                    10I 0                                           
 D ExceptionID                    7                                              
 D Reserved                       1                                              
 D MsgData                      128                                              
  *                                                                              
 DCvtDateTimeFmt   PR                  ExtPgm('QWCCVTDT')                        
 D InputFormat                   10    Const                                     
 D InputTS                             Const LikeDS(dsDateStruc)                 
 D OutputFormat                  10    Const                                     
 D OutputTS                            LikeDS(dsDateStruc)                       
 D dsErrCode                           LikeDS(dsErrCode)                         
 D InputTZ                       10    Const                                     
 D OutputTZ                      10    Const                                     
 D TimeZoneInfo                        LikeDs(dsTimeZone)                        
 D TimeZoneInfoL                 10I 0 Const                                     
 D PrecisionInd                   1    Const                                     
  *                                                                              
 DdsTimeZone       DS                  Qualified                                 
 D BytesReturned                 10I 0                                           
 D BytesAvailable                10I 0                                           
 D TimeZoneName                  10                                              
 D Reserved1                      1                                              
 D DaylightSaving                 1                                              
 D CurOffset                     10I 0                                           
 D CurFullName                   50                                              
 D CurAbbrName                   10                                              
 D MsgFile                        7                                              
 D MsgFileLib                    10                                              
  *                                                                              
 D TS_Char         S             26                                              
 D InputTS         S               Z                                             
  *                                                                              
 D Date8           S              8A                                             
 D Time6           S              6A                                             
 D MiSec6          S              6S 0 Inz(000001)                               
 D parmInputTZ     S             10                                              
 D parmOutputTZ    S             10                                              
 D ZoneAbb         S             10                                              
  *                                                                              
 D GenericTS       DS            30                                              
 D  Year                   1      4                                              
 D  Cst01                  5      5                                              
 D  Month                  6      7                                              
 D  Cst02                  8      8                                              
 D  Day                    9     10                                              
 D  Cst03                 11     11                                              
 D  HH                    12     13                                              
 D  Cst04                 14     14                                              
 D  MM                    15     16                                              
 D  Cst05                 17     17                                              
 D  SS                    18     19                                              
 D                                                                               
  *------------------------ Main -------------------------------------*          
 C                                                                               
 C     *Entry        Plist                                                       
 C                   Parm                    Date8                               
 C                   Parm                    Time6                               
 C                   Parm                    parmInputTZ                         
 C                   Parm                    parmOutputTZ                        
 C                   Parm                    ZoneAbb                             
 C                                                                               
  *                                                                              
  /Free                                                                          
                                                                                 
       TS_Char =  %Char(%Date(%Dec(Date8:8:0):*ISO):*ISO)+'-'+                   
                  %Char(%Time(%Dec(Time6:6:0):*ISO):*ISO)+'.'+                   
                  %EditC(MiSec6:'X');                                            
                                                                                 
       InputTS = %TimeStamp(TS_Char) ;                                           
                                                                                 
       InputStruc.Date=%Int(%Char(%Date(InputTS):*ISO0));                        
       InputStruc.Time=%Int(%Char(%Time(InputTS):*ISO0));                        
       InputStruc.MilliSec=%SubDt(InputTS:*MS);                                  
                                                                                 
       CvtDateTimeFmt('*YYMD':                                                   
                          InputStruc:                                            
                          '*YYMD':                                               
                          OutputStruc:                                           
                          dsErrCode:                                             
                          parmInputTZ:                                           
                          parmOutputTZ:                                          
                          dsTimeZone:                                            
                          %Size(dsTimeZone):                                     
                          (InputStruc.MilliSec>0));                              
                                                                                 
       TS_Char =  %Char(%Date(OutputStruc.Date:*ISO):*ISO)+'-'+                  
                      %Char(%Time(OutputStruc.Time:*ISO):*ISO)+'.'+              
                      %EditC(OutputStruc.MilliSec:'X');                          
                                                                                 
       GenericTS = TS_Char ;                                                     
                                                                                 
       Date8 = Year + Month + Day ;                                              
       Time6 = HH + MM + SS ;                                                    
       ZoneAbb = dsTimeZone.CurAbbrName ;                                        
                                                                                 
       *inlr = *on;                                                              
                                                                                 
       Return ;                                                                  
                                                                                 
  /End-Free                                                                      
  *                                                                              
  *------------------------ Main -------------------------------------*          
