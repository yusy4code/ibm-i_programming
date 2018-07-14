# Data Queue in IBM i

## Create Data Queue

CRTDTAQ command to create a DTAQ. Provide the max length of your data and sequence model (LIFO, FIFO or KEYED). If KEYED is chosen then provide the length of Key as well.

Example (for following my program):

CRTDTAQ DTAQ(\*LIBL/SAMPLEQ) MAXLEN(100) SEQ(\*FIFO)

CRTDTAQ DTAQ(\*LIBL/SAMPLEQ) MAXLEN(100) SEQ(\*KEYED) KEYLEN(10)

IBM Reference:

https://www.ibm.com/support/knowledgecenter/en/ssw_ibm_i_73/cl/crtdtaq.htm

## Send data into Data Queue

QSNDDTAQ is the API used for sending the data into DTAQ. 

PGMSND.pgm above reference code for sending data without key

PGMSNDK.pgm above reference code for sending data with key

IBM Reference:

https://www.ibm.com/support/knowledgecenter/ja/ssw_ibm_i_73/apis/qsnddtaq.htm

## Receive data from Data Queue

QRCVDTAQ is the API used for receiving data from DTAQ

PGMRCV.pgm reference code above for receiving data from DTAQ without key

PGMRCVK.pgm reference code above for receiving data from DTAQ with key

IBM Reference:

https://www.ibm.com/support/knowledgecenter/ja/ssw_ibm_i_73/apis/qrcvdtaq.htm
