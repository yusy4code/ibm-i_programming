# Create Data Queue

CRTDTAQ command to create a DTAQ. Provide the max length of your data and sequence model (LIFO, FIFO or KEYED). If KEYED is chosen then provide the length of Key as well.

Example (for following my program):

CRTDTAQ DTAQ(\*LIBL/SAMPLEQ) MAXLEN(100) SEQ(\*FIFO)

CRTDTAQ DTAQ(\*LIBL/SAMPLEQ) MAXLEN(100) SEQ(\*KEYED) KEYLEN(10)

IBM Reference:

https://www.ibm.com/support/knowledgecenter/en/ssw_ibm_i_73/cl/crtdtaq.htm
